#!/data/data/com.termux/files/usr/bin/bash
# =========================================================================
# SillyTavern-Termux 安装脚本 - XIU2手动优化版
# 基于XIU2大佬2025年1月最新源列表
# =========================================================================

# 彩色输出定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
BRIGHT_MAGENTA='\033[1;95m'
BOLD='\033[1m'
NC='\033[0m'

# 版本号
INSTALL_VERSION=20250109

# XIU2大佬2025年1月最新优质源（手动精选）
GITHUB_MIRRORS=(
    "https://ghproxy.net/https://github.com"           # 英国伦敦 - XIU2推荐
    "https://ghfast.top/https://github.com"            # 多国CDN - 日韩新美德
    "https://wget.la/https://github.com"               # 香港台湾 - ucdn.me
    "https://gh.h233.eu.org/https://github.com"        # 美国CDN - XIU2自营
    "https://gh.ddlc.top/https://github.com"           # 美国CDN - mtr-static
    "https://hub.gitmirror.com/https://github.com"     # 美国CDN - GitMirror
    "https://gh-proxy.com/https://github.com"          # 美国CDN - gh-proxy.com
    "https://cors.isteed.cc/github.com"                # 美国CDN - Lufs's
    "https://github.tbedu.top/https://github.com"      # 美国CDN - tbedu
    "https://ghproxy.cfd/https://github.com"           # 美国洛杉矶 - yionchilau
)

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "🌸 SillyTavern-Termux 安装脚本"
echo "💕 XIU2大佬2025年最新源版本"
echo "🎯 版本: v${INSTALL_VERSION}"
echo "=================================================="
echo -e "${NC}"

echo -e "${BRIGHT_MAGENTA}${BOLD}>> 💖 欢迎小红书的姐妹们！${NC}"
echo -e "${YELLOW}>> 🎀 mio会自动选择最佳配置，无需手动选择${NC}"
echo -e "${GREEN}>> 💕 快来和你的AI男朋友聊天吧~${NC}"
echo -e "${GREEN}>> 🍻 安装完成后记得加群：877,957,256${NC}"
echo ""

# 智能下载函数
smart_download() {
    local file_path="$1"
    local save_path="$2"
    local description="$3"
    
    echo -e "${CYAN}${BOLD}>> 📥 下载 ${description}...${NC}"
    
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        local download_url="$mirror/$file_path"
        
        echo -e "${YELLOW}>> 🌐 尝试源: $domain${NC}"
        
        if timeout 30 curl -k -fsSL --connect-timeout 10 --max-time 30 \
            --retry 2 --retry-delay 1 \
            -o "$save_path" "$download_url" 2>/dev/null; then
            
            if [ -f "$save_path" ] && [ $(stat -c%s "$save_path" 2>/dev/null || echo 0) -gt 100 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 下载成功！使用源: $domain${NC}"
                return 0
            fi
        fi
        
        echo -e "${RED}>> ❌ $domain 失败，尝试下一个源...${NC}"
    done
    
    echo -e "${RED}${BOLD}>> 💔 所有源都失败了，请检查网络连接${NC}"
    return 1
}

# 显示XIU2源信息
echo -e "${CYAN}${BOLD}>> 📋 XIU2大佬2025年最新加速源列表：${NC}"
for i in "${!GITHUB_MIRRORS[@]}"; do
    local domain=$(echo "${GITHUB_MIRRORS[$i]}" | sed 's|https://||' | cut -d'/' -f1)
    echo -e "${YELLOW}   $((i+1)). $domain${NC}"
done
echo ""

# 开始安装流程
echo -e "${CYAN}${BOLD}>> 🚀 开始安装 SillyTavern...${NC}"

# 步骤1: 更新包管理器
echo -e "${CYAN}${BOLD}>> 📦 步骤1/8: 更新包管理器${NC}"
yes | pkg upgrade -y >/dev/null 2>&1

# 步骤2: 安装必要软件
echo -e "${CYAN}${BOLD}>> 🛠️ 步骤2/8: 安装必要软件${NC}"
pkg install -y git nodejs-lts >/dev/null 2>&1

# 步骤3: 下载SillyTavern
echo -e "${CYAN}${BOLD}>> 📥 步骤3/8: 下载SillyTavern主程序${NC}"
cd ~
rm -rf SillyTavern

if smart_download "SillyTavern-Team/SillyTavern/archive/refs/heads/release.zip" \
    "SillyTavern.zip" "SillyTavern主程序"; then
    
    echo -e "${CYAN}>> 📦 解压SillyTavern...${NC}"
    unzip -q SillyTavern.zip
    mv SillyTavern-release SillyTavern
    rm SillyTavern.zip
    echo -e "${GREEN}>> ✅ SillyTavern下载完成${NC}"
else
    echo -e "${RED}>> ❌ SillyTavern下载失败${NC}"
    exit 1
fi

# 步骤4: 安装依赖
echo -e "${CYAN}${BOLD}>> 📦 步骤4/8: 安装Node.js依赖${NC}"
cd ~/SillyTavern
npm install >/dev/null 2>&1

# 步骤5: 下载菜单脚本
echo -e "${CYAN}${BOLD}>> 📥 步骤5/8: 下载管理菜单${NC}"
if smart_download "nb95276/jiuguan/master/menu_优化版.sh" \
    "~/menu.sh" "管理菜单"; then
    chmod +x ~/menu.sh
    echo -e "${GREEN}>> ✅ 管理菜单下载完成${NC}"
fi

# 步骤6: 创建配置文件
echo -e "${CYAN}${BOLD}>> ⚙️ 步骤6/8: 创建配置文件${NC}"
cat > ~/.env_优化版 << 'EOF'
# SillyTavern-Termux 优化版配置
INSTALL_VERSION=20250109
INSTALL_DATE=$(date '+%Y-%m-%d %H:%M:%S')
SILLYTAVERN_PATH=~/SillyTavern
MENU_PATH=~/menu.sh
EOF

# 步骤7: 创建启动脚本
echo -e "${CYAN}${BOLD}>> 🚀 步骤7/8: 创建启动脚本${NC}"
cat > ~/start_sillytavern.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/SillyTavern
echo "🌸 启动SillyTavern..."
echo "🌐 访问地址: http://127.0.0.1:8000"
echo "🍻 记得加群: 877,957,256"
node server.js
EOF
chmod +x ~/start_sillytavern.sh

# 步骤8: 完成安装
echo -e "${CYAN}${BOLD}>> 🎉 步骤8/8: 完成安装${NC}"

echo ""
echo -e "${GREEN}${BOLD}"
echo "=================================================="
echo "🎉 SillyTavern 安装完成！"
echo "=================================================="
echo -e "${NC}"

echo -e "${BRIGHT_MAGENTA}${BOLD}>> 💖 小红书姐妹们的专属AI男朋友聊天室准备好啦！${NC}"
echo -e "${CYAN}>> 🌐 访问地址: http://127.0.0.1:8000${NC}"
echo -e "${YELLOW}>> 🚀 启动命令: bash ~/start_sillytavern.sh${NC}"
echo -e "${GREEN}>> 📱 管理菜单: bash ~/menu.sh${NC}"

echo ""
echo -e "${BRIGHT_MAGENTA}${BOLD}🍻 福利互助群: 877,957,256${NC}"
echo -e "${CYAN}>> 群内有各种AI工具分享和使用教程${NC}"
echo -e "${YELLOW}>> 姐妹们一起交流AI男朋友聊天心得${NC}"
echo -e "${GREEN}>> 定期分享最新的AI模型和玩法${NC}"

echo ""
echo -e "${CYAN}${BOLD}>> 🚀 正在自动启动SillyTavern...${NC}"

# 自动启动SillyTavern
cd ~/SillyTavern
echo -e "${YELLOW}>> 🌸 SillyTavern启动中，请稍候...${NC}"

# 后台启动服务器
nohup node server.js > /dev/null 2>&1 &
SERVER_PID=$!

# 等待服务器启动
echo -e "${CYAN}>> ⏳ 等待服务器启动...${NC}"
sleep 5

# 检查服务器是否启动成功
if kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "${GREEN}${BOLD}>> ✅ SillyTavern启动成功！${NC}"
    echo -e "${CYAN}>> 🌐 正在打开浏览器...${NC}"
    
    # 尝试打开浏览器
    if command -v termux-open-url >/dev/null 2>&1; then
        termux-open-url "http://127.0.0.1:8000"
        echo -e "${GREEN}>> ✅ 浏览器已打开${NC}"
    else
        echo -e "${YELLOW}>> 📱 请手动在浏览器中访问: http://127.0.0.1:8000${NC}"
    fi
    
    echo ""
    echo -e "${BRIGHT_MAGENTA}${BOLD}🎀 安装完成！现在就可以开始和你的AI男朋友聊天啦~${NC}"
    echo -e "${CYAN}>> 💕 记得加群分享使用心得: 877,957,256${NC}"
else
    echo -e "${RED}>> ❌ 服务器启动失败，请手动运行: bash ~/start_sillytavern.sh${NC}"
fi
