#!/data/data/com.termux/files/usr/bin/bash
# =========================================================================
# SillyTavern-Termux VPN用户精简版安装脚本（小红书专版）
# 原作者：欤歡 | 优化：mio酱 for 小红书姐妹们 💕
# 专为有VPN的用户设计，无需GitHub加速，直连官方仓库
# =========================================================================

# 设置全局非交互模式，避免用户选择困扰
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
export NEEDRESTART_MODE=a
set -o pipefail

# ==== 彩色输出定义 ====
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
BRIGHT_MAGENTA='\033[1;95m'
NC='\033[0m'

# ==== 进度显示函数 ====
show_progress() {
    local step=$1
    local total=$2
    local message=$3
    local percent=$((step * 100 / total))
    local filled=$((percent / 10))
    local empty=$((10 - filled))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done

    echo -e "${BRIGHT_MAGENTA}${BOLD}🌸 安装进度：[${bar}] ${percent}%${NC}"
    echo -e "${CYAN}${BOLD}💕 ${message}${NC}"
    echo ""
}

# ==== 版本号 ====
INSTALL_VERSION=20250710_VPN_v2

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "🌸 SillyTavern-Termux VPN精简版 V2 🌸"
echo "💕 专为有VPN的小红书姐妹们优化"
echo "💖 直连GitHub官方，无需加速源"
echo "✨ 保留npm国内镜像，安装更快速"
echo "🔧 V2版本：优化网络连接和错误处理"
echo "=================================================="
echo -e "${NC}"

# =========================================================================
# 步骤 1/8：环境检测
# =========================================================================
show_progress 1 8 "正在检查你的手机环境，确保一切准备就绪~"
echo -e "\n${CYAN}${BOLD}==== 步骤 1/8：环境检测 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在检查运行环境，请稍等...${NC}"

if [ -z "$PREFIX" ] || [[ "$PREFIX" != "/data/data/com.termux/files/usr" ]]; then
    echo -e "${RED}${BOLD}>> 😿 本脚本仅适用于 Termux 环境，请在 Termux 中运行！${NC}"
    exit 1
fi

STORAGE_DIR="$HOME/storage/shared"
if [ ! -d "$STORAGE_DIR" ]; then
    echo -e "${YELLOW}${BOLD}>> 🔑 未检测到存储权限，尝试自动获取...${NC}"
    if ! command -v termux-setup-storage >/dev/null 2>&1; then
        echo -e "${YELLOW}${BOLD}>> ⚠️ 警告：'termux-setup-storage' 命令不存在，部分功能可能无法访问存储。${NC}"
    else
        termux-setup-storage
        echo -e "${CYAN}${BOLD}>> 📱 请在弹出的窗口中点击"允许"授权，正在等待授权结果...${NC}"
        max_wait_time=15
        for ((i=0; i<max_wait_time; i++)); do
            [ -d "$STORAGE_DIR" ] && break
            sleep 1
        done
        if [ ! -d "$STORAGE_DIR" ]; then
            echo -e "${YELLOW}${BOLD}>> ⚠️ 警告：存储权限获取超时或被拒绝，部分功能可能受限。${NC}"
        else
            echo -e "${GREEN}${BOLD}>> ✅ 存储权限已成功获取。${NC}"
        fi
    fi
else
    echo -e "${GREEN}${BOLD}>> ✅ 存储权限已配置。${NC}"
fi
echo -e "${GREEN}${BOLD}>> 🎉 步骤 1/8 完成：环境检测通过。${NC}"

# =========================================================================
# 步骤 2/8：切换 Termux 镜像源为清华源
# =========================================================================
show_progress 2 8 "正在优化下载源，让后续安装更快更稳定~"
echo -e "\n${CYAN}${BOLD}==== 步骤 2/8：切换 Termux 镜像源为清华源 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在切换到国内镜像源，提升下载速度...${NC}"

ln -sf /data/data/com.termux/files/usr/etc/termux/mirrors/chinese_mainland/mirrors.tuna.tsinghua.edu.cn /data/data/com.termux/files/usr/etc/termux/chosen_mirrors
pkg --check-mirror update
echo -e "${GREEN}${BOLD}>> 🚀 步骤 2/8 完成：已切换为清华镜像源。${NC}"

# =========================================================================
# 步骤 3/8：更新包管理器
# =========================================================================
show_progress 3 8 "正在更新系统组件，为安装做准备~"
echo -e "\n${CYAN}${BOLD}==== 步骤 3/8：更新包管理器 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在更新系统，这可能需要几分钟...${NC}"
echo -e "${CYAN}${BOLD}>> 🤖 mio会自动处理所有选择，姐妹不用操心哦~${NC}"

OPENSSL_CNF="/data/data/com.termux/files/usr/etc/tls/openssl.cnf"
[ -f "$OPENSSL_CNF" ] && rm -f "$OPENSSL_CNF"

# 设置非交互模式，自动选择默认选项
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
export NEEDRESTART_MODE=a

pkg update && yes | pkg upgrade
echo -e "${GREEN}${BOLD}>> 🎉 步骤 3/8 完成：包管理器已更新。${NC}"

# =========================================================================
# 步骤 4/8：安装依赖
# =========================================================================
show_progress 4 8 "正在安装必要工具，马上就能开始下载AI程序啦~"
echo -e "\n${CYAN}${BOLD}==== 步骤 4/8：安装依赖 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在安装必要的工具，请耐心等待...${NC}"

for dep in git curl zip; do
    if ! command -v $dep >/dev/null 2>&1; then
        echo -e "${YELLOW}${BOLD}>> 📦 检测到未安装：$dep，正在安装...${NC}"
        pkg install -y $dep
    else
        echo -e "${CYAN}${BOLD}>> ✅ $dep 已安装，跳过。${NC}"
    fi
done

if ! command -v node >/dev/null 2>&1; then
    if pkg list-all | grep -q '^nodejs-lts/'; then
        echo -e "${YELLOW}${BOLD}>> 📦 检测到未安装：node，正在安装 nodejs-lts...${NC}"
        pkg install -y nodejs-lts || pkg install -y nodejs
    else
        echo -e "${YELLOW}${BOLD}>> 📦 检测到未安装：node，正在安装 nodejs...${NC}"
        pkg install -y nodejs
    fi
else
    echo -e "${CYAN}${BOLD}>> ✅ node 已安装，跳过。${NC}"
fi

npm config set prefix "$PREFIX"
echo -e "${GREEN}${BOLD}>> 🎉 步骤 4/8 完成：依赖已安装。${NC}"

# =========================================================================
# 步骤 5/8：克隆 SillyTavern 主仓库（直连GitHub官方）
# =========================================================================
show_progress 5 8 "正在下载AI聊天程序，VPN用户直连更稳定哦~"
echo -e "\n${CYAN}${BOLD}==== 步骤 5/8：克隆 SillyTavern 仓库 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在从GitHub官方下载 SillyTavern 主程序...${NC}"
echo -e "${CYAN}${BOLD}>> 🌐 VPN用户专享：直连官方仓库，无需加速源${NC}"

if [ -d "$HOME/SillyTavern/.git" ]; then
    echo -e "${YELLOW}${BOLD}>> ✅ SillyTavern 仓库已存在，跳过克隆。${NC}"
    echo -e "${YELLOW}${BOLD}>> 🎯 步骤 5/8 跳过：仓库已存在。${NC}"
else
    rm -rf "$HOME/SillyTavern"
    
    echo -e "${YELLOW}${BOLD}>> 🔄 正在从GitHub官方克隆...${NC}"
    echo -e "${CYAN}>> ⏳ 预计需要30-60秒，请耐心等待...${NC}"

    # 优化git clone参数：浅克隆+单分支+压缩
    if timeout 120 git clone --depth=1 --single-branch --branch=release \
        --config http.postBuffer=1048576000 \
        --config http.maxRequestBuffer=100M \
        --config core.preloadindex=true \
        --config core.fscache=true \
        --config gc.auto=0 \
        "https://github.com/SillyTavern/SillyTavern" "$HOME/SillyTavern" 2>/dev/null; then
        echo -e "${GREEN}${BOLD}>> ✅ 克隆成功！来源: GitHub官方${NC}"
    else
        echo -e "${RED}${BOLD}>> 💔 克隆失败，请检查VPN连接或网络状态${NC}"
        echo -e "${YELLOW}${BOLD}>> 💡 提示：确保VPN正常工作，可以访问GitHub${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}${BOLD}>> 🎉 步骤 5/8 完成：SillyTavern 仓库已克隆。${NC}"
fi

# =========================================================================
# 步骤 6/8：创建菜单脚本与配置文件
# =========================================================================
show_progress 6 8 "正在创建专属菜单，让你使用更方便~"
echo -e "\n${CYAN}${BOLD}==== 步骤 6/8：创建菜单脚本与配置文件 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在创建管理脚本...${NC}"

MENU_PATH="$HOME/menu.sh"
ENV_PATH="$HOME/.env"

# 创建.env配置文件
if [ ! -f "$ENV_PATH" ]; then
    echo -e "${YELLOW}${BOLD}>> 📝 创建配置文件...${NC}"
    cat > "$ENV_PATH" << 'EOF'
INSTALL_VERSION=20250709_VPN
MENU_VERSION=20250709_VPN
# VPN用户精简版 - 直连GitHub官方，保留npm国内源
EOF
    echo -e "${GREEN}${BOLD}>> ✅ 配置文件创建成功${NC}"
else
    echo -e "${YELLOW}${BOLD}>> ✅ .env 已存在，跳过创建。${NC}"
fi

# 下载菜单脚本（直连GitHub官方）
if [ ! -f "$MENU_PATH" ]; then
    echo -e "${YELLOW}${BOLD}>> 📝 正在下载菜单脚本...${NC}"
    echo -e "${CYAN}${BOLD}>> 🌐 直连GitHub官方仓库${NC}"

    if timeout 30 curl -fsSL --connect-timeout 10 --max-time 30 \
        -o "$MENU_PATH" "https://github.com/nb95276/jiuguan/raw/main/menu.sh" 2>/dev/null; then

        if [ -f "$MENU_PATH" ] && [ $(stat -c%s "$MENU_PATH" 2>/dev/null || echo 0) -gt 100 ]; then
            echo -e "${GREEN}${BOLD}>> ✅ 菜单脚本下载成功！来源: GitHub官方${NC}"
            chmod +x "$MENU_PATH"
        else
            echo -e "${RED}${BOLD}>> ❌ 菜单下载失败，请检查VPN连接${NC}"
            rm -f "$MENU_PATH"
            exit 1
        fi
    else
        echo -e "${RED}${BOLD}>> ❌ 菜单下载失败，请检查VPN连接${NC}"
        echo -e "${YELLOW}${BOLD}>> 💡 确保VPN正常工作，可以访问GitHub${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}${BOLD}>> ✅ menu.sh 已存在，跳过创建。${NC}"
fi

source "$ENV_PATH" 2>/dev/null || true
echo -e "${GREEN}${BOLD}>> 🎉 步骤 6/8 完成：菜单脚本与配置文件已就绪。${NC}"

# =========================================================================
# 步骤 7/8：配置自动启动菜单
# =========================================================================
echo -e "\n${CYAN}${BOLD}==== 步骤 7/8：配置自动启动菜单 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在配置自动启动，以后打开Termux就能直接使用啦...${NC}"

PROFILE_FILE=""
for pf in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
    if [ -f "$pf" ]; then
        PROFILE_FILE="$pf"
        break
    fi
done
if [ -z "$PROFILE_FILE" ]; then
    PROFILE_FILE="$HOME/.bashrc"
fi
touch "$PROFILE_FILE"

if ! grep -qE 'bash[ ]+\$HOME/menu\.sh' "$PROFILE_FILE"; then
    echo 'bash $HOME/menu.sh' >> "$PROFILE_FILE"
    echo -e "${GREEN}${BOLD}>> ✅ 步骤 7/8 完成：已配置自动启动菜单。${NC}"
else
    echo -e "${YELLOW}${BOLD}>> ✅ 自动启动菜单已配置，跳过。${NC}"
    echo -e "${YELLOW}${BOLD}>> 🎯 步骤 7/8 跳过：自动启动已存在。${NC}"
fi

# =========================================================================
# 步骤 8/8：安装 SillyTavern 依赖
# =========================================================================
show_progress 7 8 "正在安装运行环境，快要完成啦~"
show_progress 8 8 "最后一步！正在安装程序依赖，马上就能和AI聊天啦~"
echo -e "\n${CYAN}${BOLD}==== 步骤 8/8：安装 SillyTavern 依赖 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 最后一步！正在安装 SillyTavern 的依赖包...${NC}"
echo -e "${CYAN}${BOLD}⏰ 这个步骤可能需要5-10分钟，请耐心等待哦~${NC}"

cd "$HOME/SillyTavern" || { echo -e "${RED}${BOLD}>> 💔 进入 SillyTavern 目录失败！${NC}"; exit 1; }
rm -rf node_modules

# 设置国内npm镜像源（阿里云，稳定快速）
echo -e "${CYAN}${BOLD}>> 🔧 配置npm镜像源...${NC}"
echo -e "${YELLOW}${BOLD}>> 💡 即使有VPN，使用国内npm镜像依然更快哦~${NC}"
npm config set registry https://registry.npmmirror.com/
export NODE_ENV=production

echo -e "${CYAN}${BOLD}>> 📦 开始安装依赖包，请不要关闭应用...${NC}"
echo -e "${YELLOW}${BOLD}>> 💡 使用阿里云镜像，国内用户下载更快~${NC}"

if ! npm install --no-audit --no-fund --loglevel=error --no-progress --omit=dev; then
    echo -e "${YELLOW}${BOLD}>> ⚠️ 首次安装失败，尝试清理缓存重试...${NC}"
    npm cache clean --force 2>/dev/null || true
    rm -rf node_modules package-lock.json 2>/dev/null

    if ! npm install --no-audit --no-fund --loglevel=error --no-progress --omit=dev; then
        echo -e "${RED}${BOLD}>> 💔 依赖安装失败，请检查网络连接或稍后重试。${NC}"
        echo -e "${CYAN}${BOLD}>> 💡 提示：可以稍后运行 'cd ~/SillyTavern && npm install' 手动安装${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}${BOLD}>> ✅ 依赖安装成功！${NC}"
echo -e "${GREEN}${BOLD}>> 🎉 步骤 8/8 完成：SillyTavern 依赖已安装。${NC}"

# =========================================================================
# 安装完成，自动启动SillyTavern
# =========================================================================
echo -e "\n${GREEN}${BOLD}"
echo "🎉🎉🎉 恭喜姐妹！VPN精简版安装完成啦！🎉🎉🎉"
echo "✨ SillyTavern 已经成功安装到你的手机上"
echo "💕 现在可以和你的AI男朋友愉快聊天啦~"
echo "🌐 VPN用户专享：直连GitHub官方，无需加速源"
echo "🚀 保留npm国内镜像，依赖安装更快速"
echo "=================================================="
echo -e "${NC}"

echo -e "\n${BRIGHT_MAGENTA}${BOLD}🍻 加入我们的福利互助群！🍻${NC}"
echo -e "${YELLOW}${BOLD}💕 免费API福利互助群：877,957,256${NC}"
echo -e "${CYAN}${BOLD}• 🎀 SillyTavern使用技巧分享${NC}"
echo -e "${CYAN}${BOLD}• 💝 优质角色卡资源${NC}"
echo -e "${CYAN}${BOLD}• 🌸 姐妹们的聊天心得${NC}"
echo -e "${CYAN}${BOLD}• 🆘 遇到问题互相帮助${NC}"
echo ""

echo -e "${CYAN}${BOLD}>> 🚀 正在自动启动SillyTavern...${NC}"
echo -e "${YELLOW}${BOLD}>> 💡 启动后会自动打开浏览器，请稍等...${NC}"
echo -e "${GREEN}${BOLD}>> 🌐 访问地址：http://127.0.0.1:8000${NC}"
echo ""

# 进入SillyTavern目录并启动
cd "$HOME/SillyTavern" || {
    echo -e "${RED}${BOLD}>> 💔 进入 SillyTavern 目录失败！${NC}"
    echo -e "${CYAN}${BOLD}>> 🎀 按任意键进入菜单手动启动...${NC}"
    read -n1 -s
    exec bash "$HOME/menu.sh"
    exit 1
}

# 后台启动SillyTavern
echo -e "${CYAN}${BOLD}>> 🎯 正在启动服务器...${NC}"
nohup node server.js > /dev/null 2>&1 &
SERVER_PID=$!

# 等待服务器启动
echo -e "${YELLOW}${BOLD}>> ⏰ 等待服务器启动（最多30秒）...${NC}"
for i in {1..30}; do
    if curl -s http://127.0.0.1:8000 > /dev/null 2>&1; then
        echo -e "${GREEN}${BOLD}>> ✅ 服务器启动成功！${NC}"
        break
    fi
    sleep 1
    if [ $i -eq 30 ]; then
        echo -e "${YELLOW}${BOLD}>> ⚠️ 服务器启动超时，但可能仍在启动中...${NC}"
    fi
done

# 尝试打开浏览器
echo -e "${CYAN}${BOLD}>> 🌐 正在打开浏览器...${NC}"
if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url "http://127.0.0.1:8000"
    echo -e "${GREEN}${BOLD}>> ✅ 浏览器已打开！${NC}"
else
    echo -e "${YELLOW}${BOLD}>> ⚠️ 无法自动打开浏览器${NC}"
    echo -e "${CYAN}${BOLD}>> 💡 请手动在浏览器中访问：http://127.0.0.1:8000${NC}"
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 SillyTavern VPN精简版已启动完成！${NC}"
echo -e "${CYAN}${BOLD}💕 如需管理服务器，请运行：bash ~/menu.sh${NC}"
echo -e "${YELLOW}${BOLD}🍻 记得加群哦：877,957,256${NC}"
echo ""
echo -e "${BRIGHT_MAGENTA}${BOLD}>> 🌸 享受和AI的愉快聊天时光吧~${NC}"
