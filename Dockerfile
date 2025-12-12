# Dockerfile
FROM linuxserver/webtop:ubuntu-openbox

# 避免交互式前端的报错
ENV DEBIAN_FRONTEND=noninteractive

# 1. 替换国内源 (可选，根据服务器网络情况决定是否保留)
# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 2. 安装基础依赖、字体、输入法、音频支持
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    xz-utils \
    fonts-noto-cjk \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    fcitx \
    fcitx-googlepinyin \
    fcitx-config-gtk \
    dbus-x11 \
    # --- Ubuntu 24.04 核心 GUI 依赖 ---
    libgbm1 \
    libnss3 \
    libatomic1 \
    libxkbcommon-x11-0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxi6 \
    libxcursor1 \
    libgtk-3-0t64 \
    libasound2t64 \
    # --- Qt XCB 插件依赖 (解决 libxcb-icccm 等报错) ---
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xfixes0 \
    # ---------------------------------
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 3. 下载并安装微信 (使用官方最新 x86_64 deb 包)
# 注意：URL 可能会变，若失效请替换为最新的下载链接
RUN wget -O /tmp/wechat.deb "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb" \
    && apt-get install -y /tmp/wechat.deb \
    && rm /tmp/wechat.deb

# 4. 设置环境变量以支持中文输入法
ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8
ENV GTK_IM_MODULE=fcitx
ENV QT_IM_MODULE=fcitx
ENV XMODIFIERS=@im=fcitx
ENV WECHAT_PID_FILE=/tmp/wechat.pid

# 5. 清理图层
RUN apt-get autoremove -y && apt-get clean