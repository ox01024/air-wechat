#!/bin/bash
# 这个脚本将放在 /custom-cont-init.d/ 下，每次容器启动前运行

CONFIG_FILE="/config/.config/openbox/rc.xml"

# 检查文件是否存在，不存在则由系统生成默认值，我们稍后修改
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found yet, skipping injection."
    exit 0
fi

# 检查是否已经注入过
if grep -q "WeChat-Kiosk-Mode" "$CONFIG_FILE"; then
    echo "Rules already injected."
    exit 0
fi

# 注入 XML 规则：去边框、最大化
# 插入到 <applications> 标签之后
sed -i '/<applications>/a \
  \
  <application class="*"> \
    <decorations>no</decorations> \
    <maximized>yes</maximized> \
    <layer>normal</layer> \
  </application> \
  ' "$CONFIG_FILE"

echo "Openbox rules injected successfully."

