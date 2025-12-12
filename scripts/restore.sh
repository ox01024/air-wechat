#!/bin/bash

# 配置
BACKUP_DIR="../backups"
DATA_DIR="../wechat_data"

echo "========================================"
echo "      AirWeChat Time Machine - Restore"
echo "========================================"

# 检查备份目录
if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR")" ]; then
    echo "❌ No backups found in '$BACKUP_DIR'."
    exit 1
fi

echo "Available Time Points:"
# 列出备份文件
options=($(ls "$BACKUP_DIR"/*.tar.gz))
for i in "${!options[@]}"; do 
    echo "[$i] $(basename "${options[$i]}")"
done

echo "----------------------------------------"
read -p "Select a backup to restore (enter number): " choice

if [[ -z "${options[$choice]}" ]]; then
    echo "❌ Invalid selection."
    exit 1
fi

SELECTED_FILE="${options[$choice]}"

echo "⚠️  WARNING: This will OVERWRITE current WeChat data."
read -p "Are you sure? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo "Stopping containers..."
docker-compose down

echo "Restoring from snapshot..."
# 确保父目录存在
mkdir -p "$(dirname "$DATA_DIR")"
# 解压覆盖
tar -xzf "$SELECTED_FILE" -C "$(dirname "$DATA_DIR")"

echo "Restarting containers..."
docker-compose up -d

echo "✅ Restore complete! You have traveled back in time."
