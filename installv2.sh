#!/data/data/com.termux/files/usr/bin/bash
# =========================================================================
# SillyTavern-Termux 优化安装脚本（小红书专版）
# 原作者：欤歡 | 优化：mio酱 for 小红书姐妹们 💕
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
INSTALL_VERSION=20250710_v2

# ==== 动态获取最新GitHub加速源 ====
get_latest_mirrors() {
    echo -e "${CYAN}${BOLD}>> 🔄 正在获取最新GitHub加速源...${NC}"

    # XIU2脚本地址
    local xiu2_script_urls=(
        "https://ghproxy.net/https://raw.githubusercontent.com/XIU2/UserScript/master/GithubEnhanced-High-Speed-Download.user.js"
        "https://gh.ddlc.top/https://raw.githubusercontent.com/XIU2/UserScript/master/GithubEnhanced-High-Speed-Download.user.js"
        "https://raw.githubusercontent.com/XIU2/UserScript/master/GithubEnhanced-High-Speed-Download.user.js"
    )

    for url in "${xiu2_script_urls[@]}"; do
        if timeout 10 curl -k -fsSL --connect-timeout 5 --max-time 10 \
            -o "/tmp/xiu2_script.js" "$url" 2>/dev/null; then

            if [ -f "/tmp/xiu2_script.js" ] && [ $(stat -c%s "/tmp/xiu2_script.js" 2>/dev/null || echo 0) -gt 1000 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 获取到最新加速源列表！${NC}"

                # 先尝试解析download_url数组（用于下载），再解析raw_url数组
                local new_mirrors=()

                # 提取download_url数组
                while IFS= read -r line; do
                    if [[ "$line" =~ \[\'([^\']+)\' ]]; then
                        local mirror="${BASH_REMATCH[1]}"
                        if [[ "$mirror" =~ ^https:// ]] && [ ${#new_mirrors[@]} -lt 8 ]; then
                            new_mirrors+=("$mirror")
                        fi
                    fi
                done < <(sed -n '/download_url = \[/,/\];/p' "/tmp/xiu2_script.js")

                # 如果download_url不够，再从raw_url补充并转换
                if [ ${#new_mirrors[@]} -lt 8 ]; then
                    while IFS= read -r line; do
                        if [[ "$line" =~ \[\'([^\']+)\' ]]; then
                            local mirror="${BASH_REMATCH[1]}"
                            if [[ "$mirror" =~ ^https:// ]] && [ ${#new_mirrors[@]} -lt 10 ]; then
                                # 将raw.githubusercontent.com的源转换为github.com的源
                                if [[ "$mirror" == *"raw.githubusercontent.com"* ]]; then
                                    mirror="${mirror/raw.githubusercontent.com/github.com}"
                                elif [[ "$mirror" == *"/https://raw.githubusercontent.com"* ]]; then
                                    mirror="${mirror/\/https:\/\/raw.githubusercontent.com/\/https:\/\/github.com}"
                                fi
                                new_mirrors+=("$mirror")
                            fi
                        fi
                    done < <(sed -n '/raw_url = \[/,/\];/p' "/tmp/xiu2_script.js")
                fi

                if [ ${#new_mirrors[@]} -gt 5 ]; then
                    GITHUB_MIRRORS=("${new_mirrors[@]}")
                    echo -e "${CYAN}>> 🎉 已更新到最新的 ${#GITHUB_MIRRORS[@]} 个加速源${NC}"
                    echo -e "${GREEN}>> 📋 最新源列表预览：${NC}"
                    for i in "${!GITHUB_MIRRORS[@]}"; do
                        if [ $i -lt 3 ]; then
                            local domain=$(echo "${GITHUB_MIRRORS[$i]}" | sed 's|https://||' | cut -d'/' -f1)
                            echo -e "${YELLOW}   $((i+1)). $domain${NC}"
                        fi
                    done
                    [ ${#GITHUB_MIRRORS[@]} -gt 3 ] && echo -e "${CYAN}   ... 还有 $((${#GITHUB_MIRRORS[@]} - 3)) 个源${NC}"
                    rm -f "/tmp/xiu2_script.js"
                    return 0
                fi
            fi
            rm -f "/tmp/xiu2_script.js"
        fi
    done

    echo -e "${YELLOW}${BOLD}>> ⚠️ 获取最新源失败，使用内置备用源${NC}"
    return 1
}

# ==== XIU2大佬2025年最新GitHub加速源（实测稳定优先） ====
GITHUB_MIRRORS=(
    # 🌟 实测最稳定源（优先使用）
    "https://ghproxy.net/https://github.com"            # 🇯🇵 日本大阪 - 最稳定
    "https://gh.h233.eu.org/https://github.com"         # 🇺🇸 XIU2自营 - 稳定可靠
    "https://gh.ddlc.top/https://github.com"            # 🇺🇸 美国CDN - 速度快
    "https://kkgithub.com"                              # 🇭🇰 香港、日本、新加坡
    "https://ghfast.top/https://github.com"             # 🇯🇵🇰🇷🇸🇬 日韩新等多国CDN
    "https://githubfast.com"                            # 🇰🇷 韩国 - Github Fast
    "https://gh.catmak.name/https://github.com"         # 🇰🇷 韩国首尔
    "https://github.3x25.com/https://github.com"        # 🇸🇬 新加坡

    # 🌍 其他备用源
    "https://gh-proxy.com/https://github.com"           # 🇺🇸 美国CDN - gh-proxy.com
    "https://hub.gitmirror.com/https://github.com"      # 🇺🇸 美国CDN - GitMirror
    "https://cors.isteed.cc/github.com"                 # 🇺🇸 美国CDN - Lufs's
    "https://github.tbedu.top/https://github.com"       # 🇺🇸 美国CDN - tbedu
    "https://ghproxy.cfd/https://github.com"            # 🇺🇸 美国洛杉矶

    # ⚠️ 问题源（最后使用）
    "https://hk.gh-proxy.com/https://github.com"        # ⚠️ HTTP/2协议问题
    "https://wget.la/https://github.com"                # ⚠️ 下载不完整问题
    "https://github.com"                                # 🌐 GitHub官方
    "https://gitclone.com"                              # 🇨🇳 中国国内 - GitClone（较慢）
)

# 尝试获取最新加速源
get_latest_mirrors

# ==== 快速测试加速源可用性 ====
test_mirrors_speed() {
    echo -e "${CYAN}${BOLD}>> 🚀 快速测试加速源可用性...${NC}"
    local test_file="nb95276/jiuguan/raw/main/README.md"

    for mirror in "${GITHUB_MIRRORS[@]}"; do
        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        local test_url="$mirror/$test_file"

        # 快速测试（5秒超时）
        if timeout 5 curl -k -fsSL --connect-timeout 3 --max-time 5 \
            -o /dev/null "$test_url" 2>/dev/null; then
            echo -e "${GREEN}${BOLD}>> ✅ $domain 可用${NC}"
        else
            echo -e "${RED}${BOLD}>> ❌ $domain 不可用${NC}"
        fi
    done
    echo ""
}

# ==== 智能下载函数 ====
smart_download() {
    local file_path="$1"
    local save_path="$2"
    local description="$3"
    
    echo -e "${CYAN}${BOLD}>> 💕 开始下载: $description${NC}"
    
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        local full_url="$mirror/$file_path"
        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        
        echo -e "${YELLOW}${BOLD}>> 尝试源: $domain${NC}"
        
        if timeout 15 curl -k -fsSL --connect-timeout 8 --max-time 15 \
            -o "$save_path" "$full_url" 2>/dev/null; then
            
            # 验证下载文件
            if [ -f "$save_path" ] && [ $(stat -c%s "$save_path" 2>/dev/null || echo 0) -gt 100 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 下载成功！来源: $domain${NC}"
                return 0
            else
                echo -e "${YELLOW}${BOLD}>> 🤔 这个源有点问题，换一个试试~${NC}"
                rm -f "$save_path"
            fi
        else
            echo -e "${YELLOW}${BOLD}>> 😅 网络有点慢呢，mio帮你试试下一个源~${NC}"
        fi
    done
    
    echo -e "${RED}${BOLD}>> 💔 所有源都失败了，请检查网络连接${NC}"
    return 1
}

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "🌸 SillyTavern-Termux 小红书专版 V2 🌸"
echo "💕 专为小红书姐妹们优化，零基础也能轻松安装"
echo "💖 快来和你的AI男朋友聊天吧~"
echo "✨ V2版本：修复menu.sh下载问题，增加重试机制"
echo "🔧 确保小白用户一键安装成功，无需手动重试"
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
# 步骤 5/8：克隆 SillyTavern 主仓库（使用智能下载）
# =========================================================================
show_progress 5 8 "正在下载AI聊天程序，这是最重要的一步哦~"
echo -e "\n${CYAN}${BOLD}==== 步骤 5/8：克隆 SillyTavern 仓库 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 正在下载 SillyTavern 主程序，这是最重要的一步...${NC}"

if [ -d "$HOME/SillyTavern/.git" ]; then
    echo -e "${YELLOW}${BOLD}>> ✅ SillyTavern 仓库已存在，跳过克隆。${NC}"
    echo -e "${YELLOW}${BOLD}>> 🎯 步骤 5/8 跳过：仓库已存在。${NC}"
else
    rm -rf "$HOME/SillyTavern"
    
    # 尝试多个镜像源克隆
    clone_success=false
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        echo -e "${YELLOW}${BOLD}>> 🔄 尝试从 $domain 克隆...${NC}"
        echo -e "${CYAN}>> ⏳ 预计需要30-60秒，请耐心等待...${NC}"

        # 优化git clone参数：浅克隆+单分支+压缩
        if timeout 60 git clone --depth=1 --single-branch --branch=release \
            --config http.postBuffer=1048576000 \
            --config http.maxRequestBuffer=100M \
            --config core.preloadindex=true \
            --config core.fscache=true \
            --config gc.auto=0 \
            "$mirror/SillyTavern/SillyTavern" "$HOME/SillyTavern" 2>/dev/null; then
            echo -e "${GREEN}${BOLD}>> ✅ 克隆成功！来源: $domain${NC}"
            clone_success=true
            break
        else
            echo -e "${YELLOW}${BOLD}>> ❌ 克隆失败（60秒超时），尝试下一个源...${NC}"
            rm -rf "$HOME/SillyTavern"
        fi
    done
    
    if [ "$clone_success" = false ]; then
        echo -e "${YELLOW}${BOLD}>> ⚠️ Git克隆失败，尝试备用方案：下载ZIP包...${NC}"

        # 备用方案：下载ZIP包
        for mirror in "${GITHUB_MIRRORS[@]}"; do
            domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
            echo -e "${YELLOW}${BOLD}>> 🔄 尝试从 $domain 下载ZIP...${NC}"

            zip_url="$mirror/SillyTavern/SillyTavern/archive/refs/heads/release.zip"
            if timeout 60 curl -k -fsSL --connect-timeout 10 --max-time 60 \
                -o "/tmp/sillytavern.zip" "$zip_url" 2>/dev/null; then

                echo -e "${CYAN}${BOLD}>> 📦 正在解压ZIP包...${NC}"
                cd "$HOME" || exit 1

                if unzip -q "/tmp/sillytavern.zip" 2>/dev/null; then
                    mv "SillyTavern-release" "SillyTavern" 2>/dev/null || true
                    rm -f "/tmp/sillytavern.zip"

                    if [ -d "$HOME/SillyTavern" ]; then
                        echo -e "${GREEN}${BOLD}>> ✅ ZIP下载成功！来源: $domain${NC}"
                        clone_success=true
                        break
                    fi
                fi
                rm -f "/tmp/sillytavern.zip"
            fi
            echo -e "${YELLOW}${BOLD}>> ❌ ZIP下载失败，尝试下一个源...${NC}"
        done

        if [ "$clone_success" = false ]; then
            echo -e "${RED}${BOLD}>> 💔 所有下载方式都失败了，请检查网络连接。${NC}"
            exit 1
        fi
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
INSTALL_VERSION=20250701
MENU_VERSION=20250701
# 小红书专版 - 优化版本，去除字体下载，增加多源支持
EOF
    echo -e "${GREEN}${BOLD}>> ✅ 配置文件创建成功${NC}"
else
    echo -e "${YELLOW}${BOLD}>> ✅ .env 已存在，跳过创建。${NC}"
fi

# 尝试下载菜单脚本，如果失败则创建简化版本
if [ ! -f "$MENU_PATH" ]; then
    echo -e "${YELLOW}${BOLD}>> 📝 尝试下载菜单脚本...${NC}"

    # 尝试下载（增加重试机制）
    download_success=false
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        echo -e "${YELLOW}${BOLD}>> 尝试源: $domain${NC}"

        # 对每个源重试3次
        for retry in {1..3}; do
            echo -e "${CYAN}${BOLD}>> 第 $retry 次尝试...${NC}"

            if timeout 15 curl -k -fsSL --connect-timeout 8 --max-time 15 \
                -o "$MENU_PATH" "$mirror/nb95276/jiuguan/raw/main/menu.sh" 2>/dev/null; then

                if [ -f "$MENU_PATH" ] && [ $(stat -c%s "$MENU_PATH" 2>/dev/null || echo 0) -gt 100 ]; then
                    echo -e "${GREEN}${BOLD}>> ✅ 菜单脚本下载成功！来源: $domain (第 $retry 次尝试)${NC}"
                    chmod +x "$MENU_PATH"
                    download_success=true
                    break 2  # 跳出两层循环
                else
                    rm -f "$MENU_PATH"
                fi
            fi

            # 如果不是最后一次重试，等待1秒再试
            if [ $retry -lt 3 ]; then
                echo -e "${YELLOW}${BOLD}>> 等待1秒后重试...${NC}"
                sleep 1
            fi
        done

        # 如果这个源的3次重试都失败，尝试下一个源
        if [ "$download_success" = true ]; then
            break
        else
            echo -e "${YELLOW}${BOLD}>> ❌ $domain 重试3次均失败，尝试下一个源...${NC}"
        fi
    done

    # 如果所有源都失败，创建简化菜单而不是退出
    if [ "$download_success" = false ]; then
        echo -e "${YELLOW}${BOLD}>> ⚠️ 菜单下载失败，创建简化版菜单...${NC}"
        cat > "$MENU_PATH" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# 简化版菜单脚本
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

while true; do
    clear
    echo -e "${CYAN}${BOLD}🌸 SillyTavern 简化菜单 🌸${NC}"
    echo -e "${YELLOW}${BOLD}0. 👋 退出程序${NC}"
    echo -e "${GREEN}${BOLD}1. 🚀 启动 SillyTavern${NC}"
    echo -e "${CYAN}${BOLD}=================================${NC}"
    echo -ne "${CYAN}${BOLD}💕 请选择操作（0-1）：${NC}"
    read -n1 choice; echo

    case "$choice" in
        0) echo -e "${RED}${BOLD}>> 👋 再见啦~${NC}"; exit 0 ;;
        1)
            if [ -d "$HOME/SillyTavern" ]; then
                cd "$HOME/SillyTavern"
                echo -e "${GREEN}${BOLD}>> 🚀 正在启动 SillyTavern...${NC}"
                npm start
            else
                echo -e "${RED}${BOLD}>> 😿 未找到 SillyTavern 目录${NC}"
                sleep 2
            fi
            ;;
        *) echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择${NC}"; sleep 1 ;;
    esac
done
EOF
        chmod +x "$MENU_PATH"
        echo -e "${GREEN}${BOLD}>> ✅ 简化版菜单创建成功${NC}"
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
# 测试加速源可用性
# =========================================================================
echo -e "\n${CYAN}${BOLD}==== 🔍 测试加速源可用性 ====${NC}"
echo -e "${YELLOW}${BOLD}💡 为了以后更新更顺畅，让我们测试一下各个加速源...${NC}"
test_mirrors_speed

# =========================================================================
# 安装完成，自动启动SillyTavern
# =========================================================================
echo -e "\n${GREEN}${BOLD}"
echo "🎉🎉🎉 恭喜姐妹！安装完成啦！🎉🎉🎉"
echo "✨ SillyTavern 已经成功安装到你的手机上"
echo "💕 现在可以和你的AI男朋友愉快聊天啦~"
echo "🌸 感谢使用小红书专版安装脚本"
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
echo -e "${GREEN}${BOLD}🎉 SillyTavern 已启动完成！${NC}"
echo -e "${CYAN}${BOLD}💕 如需管理服务器，请运行：bash ~/menu.sh${NC}"
echo -e "${YELLOW}${BOLD}🍻 记得加群哦：877,957,256${NC}"
echo ""
echo -e "${BRIGHT_MAGENTA}${BOLD}>> 🌸 享受和AI的愉快聊天时光吧~${NC}"
