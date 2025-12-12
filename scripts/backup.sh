#!/bin/bash

# 配置
DATA_DIR="../wechat_data"
BACKUP_DIR="../backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/wechat_backup_$TIMESTAMP.tar.gz"

# 确保备份目录存在
mkdir -p "$BACKUP_DIR"

echo "========================================"
echo "      AirWeChat Time Machine - Backup"
echo "========================================"
echo "Creating snapshot of your WeChat data..."

# 检查数据目录是否存在
if [ ! -d "$DATA_DIR" ]; then
    echo "Error: Data directory '$DATA_DIR' not found!"
    exit 1
fi

# 执行打包
tar -czf "$BACKUP_FILE" -C "$(dirname "$DATA_DIR")" "$(basename "$DATA_DIR")"

if [ $? -eq 0 ]; then
    echo "✅ Success! Backup created at:"
    echo "   $BACKUP_FILE"
    echo "   Size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    echo "❌ Backup failed."
    exit 1
fi
