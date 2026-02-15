#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Backup-Directory with Date
BACKUP_DIR="./backup/$(date +%Y%m%d_%H%M%S)"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Rockchip Backup Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Check if rkdeveloptool is available
if ! command -v rkdeveloptool &> /dev/null; then
    echo -e "${RED}✗ rkdeveloptool not found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating Backup-Directory: $BACKUP_DIR${NC}"
mkdir -p "$BACKUP_DIR"

# Step 1: Call ppt to get all Partitions
echo ""
echo -e "${YELLOW}1. Read available partitions on the device...${NC}"
echo ""

PPT_OUTPUT=$(mktemp)
rkdeveloptool ppt > "$PPT_OUTPUT" 2>&1
cat "$PPT_OUTPUT"
echo ""

PARTITION_NAMES=()
PARTITION_LBAS=()
PARTITION_COUNT=0

while IFS= read -r line; do
    line=$(echo "$line" | tr -d '\r' | xargs)
    
    if [ -z "$line" ] || echo "$line" | grep -q "NO\|Partition\|\*\*\*"; then
        continue
    fi
    
    partition_name=$(echo "$line" | awk '{print $NF}')
    lba_hex=$(echo "$line" | awk '{print $(NF-1)}')
    
    if [ -z "$partition_name" ] || [ "$partition_name" = "Name" ]; then
        continue
    fi
    
    lba_dec=$(printf "%d" "0x$lba_hex" 2>/dev/null)
    
    if [ -n "$lba_dec" ] && [ "$lba_dec" -gt 0 ]; then
        PARTITION_NAMES[$PARTITION_COUNT]="$partition_name"
        PARTITION_LBAS[$PARTITION_COUNT]=$lba_dec
        PARTITION_COUNT=$((PARTITION_COUNT + 1))
    fi
done < "$PPT_OUTPUT"

rm "$PPT_OUTPUT"

if [ $PARTITION_COUNT -eq 0 ]; then
    echo -e "${RED}✗ No Partitions found!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ $PARTITION_COUNT Partitions found:${NC}"
i=0
while [ $i -lt $PARTITION_COUNT ]; do
    partition="${PARTITION_NAMES[$i]}"
    lba=${PARTITION_LBAS[$i]}
    printf "%3d. %-20s (LBA: 0x%08x = %d)\n" $((i+1)) "$partition" "$lba" "$lba"
    i=$((i + 1))
done
echo ""

# Step 2: Calculate length of Sectors
echo -e "${YELLOW}2. Calculate size of Partitions...${NC}"
echo ""

SECTOR_LENGTHS=()
i=0
while [ $i -lt $PARTITION_COUNT ]; do
    current_lba=${PARTITION_LBAS[$i]}
    
    if [ $((i + 1)) -lt $PARTITION_COUNT ]; then
        next_lba=${PARTITION_LBAS[$((i + 1))]}
        sector_len=$((next_lba - current_lba))
    else
        sector_len=$((262144))  # ~128 GB
    fi
    
    SECTOR_LENGTHS[$i]=$sector_len
    i=$((i + 1))
done

# Step 3: Backup
echo -e "${YELLOW}3. Starting Backup-Process...${NC}"
echo ""

FAILED_COUNT=0
i=0

while [ $i -lt $PARTITION_COUNT ]; do
    partition="${PARTITION_NAMES[$i]}"
    BEGIN_SEC=${PARTITION_LBAS[$i]}
    SECTOR_LEN=${SECTOR_LENGTHS[$i]}
    TEMP_FILE="${partition}.img"
    OUTPUT_FILE="$BACKUP_DIR/${partition}.img"
    
    BEGIN_HEX=$(printf "0x%x" $BEGIN_SEC)
    CURRENT=$((i + 1))
    
    printf "${YELLOW}[%d/%d]${NC} Backups ${YELLOW}%-20s${NC} " "$CURRENT" "$PARTITION_COUNT" "$partition"
    printf "(${BEGIN_HEX}, %d sektoren)..." "$SECTOR_LEN"
    
    # rl <BeginSec> <SectorLen> <File>
    if timeout 300 rkdeveloptool rl $BEGIN_SEC $SECTOR_LEN "$TEMP_FILE" 2>&1 | grep -q "100%"; then
        if [ -f "$TEMP_FILE" ]; then
            mv "$TEMP_FILE" "$OUTPUT_FILE" 2>/dev/null
            if [ -f "$OUTPUT_FILE" ]; then
                SIZE=$(du -h "$OUTPUT_FILE" 2>/dev/null | awk '{print $1}')
                printf " ${GREEN}✓${NC} (%s)\n" "$SIZE"
            else
                printf " ${RED}✗${NC} (Error, can't move)\n"
                FAILED_COUNT=$((FAILED_COUNT + 1))
            fi
        else
            printf " ${RED}✗${NC} (Error, file not created)\n"
            FAILED_COUNT=$((FAILED_COUNT + 1))
        fi
    else
        printf " ${RED}✗${NC} (Fehler)\n"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        [ -f "$TEMP_FILE" ] && rm -f "$TEMP_FILE"
    fi
    
    i=$((i + 1))
done

echo ""
echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Backup Summary${NC}"
echo -e "${YELLOW}========================================${NC}"

if [ -d "$BACKUP_DIR" ]; then
    TOTAL_SIZE=$(du -sh "$BACKUP_DIR" 2>/dev/null | awk '{print $1}')
else
    TOTAL_SIZE="0B"
fi

echo -e "Backup-Directory: ${GREEN}$BACKUP_DIR${NC}"
echo -e "Full size:        ${GREEN}$TOTAL_SIZE${NC}"
echo -e "Partitions:       ${GREEN}$PARTITION_COUNT${NC}"
echo ""

echo -e "${YELLOW}Stored files:${NC}"
if [ -d "$BACKUP_DIR" ]; then
    ls -lh "$BACKUP_DIR" | tail -n +2 | awk '{printf "  %-20s %8s\n", $9, $5}'
else
    echo "  (no files found)"
fi
echo ""

if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "${RED}✗ $FAILED_COUNT Partitions failed!${NC}"
else
    echo -e "${GREEN}✓ All partitions successfully backed up!${NC}"
fi

echo ""
echo -e "${YELLOW}Backup finished!${NC}"
