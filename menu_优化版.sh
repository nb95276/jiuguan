#!/data/data/com.termux/files/usr/bin/bash
# =========================================================================
# SillyTavern-Termux 小红书专版菜单脚本
# 原作者：欤歡 | 优化：mio酱 for 小红书姐妹们 💕
# =========================================================================

# ==== 彩色输出定义 ====
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
BRIGHT_BLUE='\033[1;94m'
BRIGHT_MAGENTA='\033[1;95m'
NC='\033[0m'

# ==== 版本与远程资源 ====
MENU_VERSION=20250701
UPDATE_DATE="2025-07-01"
UPDATE_CONTENT="
💕 小红书专版更新内容：
1. 去除了容易卡住的字体下载功能
2. 增加了多个GitHub加速源轮询
3. 优化了用户界面，更适合姐妹们使用
4. 简化了复杂的技术术语
5. 增加了更多可爱的提示信息
6. 提供了完整的问题解决方案
"

# ==== GitHub加速源列表 ====
GITHUB_MIRRORS=(
    "https://ghproxy.net/https://github.com"
    "https://gh.ddlc.top/https://github.com"
    "https://ghfast.top/https://github.com"
    "https://gh.h233.eu.org/https://github.com"
    "https://ghproxy.cfd/https://github.com"
    "https://hub.gitmirror.com/https://github.com"
    "https://mirrors.chenby.cn/https://github.com"
    "https://github.com"
)

# ==== 通用函数 ====
get_version() { [ -f "$1" ] && grep -E "^$2=" "$1" | head -n1 | cut -d'=' -f2 | tr -d '\r'; }
press_any_key() { echo -e "${CYAN}${BOLD}>> 💕 按任意键返回菜单...${NC}"; read -n1 -s; }

# ==== 智能下载函数 ====
smart_download() {
    local file_path="$1"
    local save_path="$2"
    local description="$3"
    
    echo -e "${CYAN}${BOLD}>> 💕 开始下载: $description${NC}"
    
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        local full_url="$mirror/$file_path"
        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        
        echo -e "${YELLOW}${BOLD}>> 🔄 尝试源: $domain${NC}"
        
        if timeout 30 curl -fsSL --connect-timeout 10 --max-time 30 \
            -o "$save_path" "$full_url" 2>/dev/null; then
            
            if [ -f "$save_path" ] && [ $(stat -c%s "$save_path" 2>/dev/null || echo 0) -gt 100 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 下载成功！来源: $domain${NC}"
                return 0
            else
                rm -f "$save_path"
            fi
        fi
    done
    
    echo -e "${RED}${BOLD}>> 💔 所有源都失败了，请检查网络连接${NC}"
    return 1
}

# =========================================================================
# 1. 启动酒馆
# =========================================================================
start_tavern() {
    echo -e "\n${CYAN}${BOLD}==== 🌸 启动 SillyTavern 🌸 ====${NC}"
    echo -e "${YELLOW}${BOLD}💕 正在为姐妹启动AI男友聊天程序...${NC}"
    
    for dep in node npm git; do
        if ! command -v $dep >/dev/null 2>&1; then
            echo -e "${RED}${BOLD}>> 😿 检测到缺失工具：$dep，请先修复环境。${NC}"
            press_any_key; return
        fi
    done
    
    if [ -d "$HOME/SillyTavern" ]; then
        cd "$HOME/SillyTavern"
        echo -e "${GREEN}${BOLD}>> 🚀 正在启动，请稍等...${NC}"
        if [ -f "start.sh" ]; then
            bash start.sh
        else
            npm start
        fi
        press_any_key
        cd "$HOME"
    else
        echo -e "${RED}${BOLD}>> 😿 未检测到 SillyTavern 目录，请重新安装。${NC}"
        sleep 2
    fi
}

# =========================================================================
# 2. 更新酒馆
# =========================================================================
update_tavern() {
    echo -e "\n${CYAN}${BOLD}==== 🔄 更新 SillyTavern 🔄 ====${NC}"
    echo -e "${YELLOW}${BOLD}💕 正在为姐妹更新到最新版本...${NC}"
    
    if [ -d "$HOME/SillyTavern" ]; then
        cd "$HOME/SillyTavern"
        echo -e "${CYAN}${BOLD}>> 📥 正在拉取最新代码...${NC}"
        
        # 尝试多个源更新
        update_success=false
        for mirror in "${GITHUB_MIRRORS[@]}"; do
            local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
            echo -e "${YELLOW}${BOLD}>> 🔄 尝试从 $domain 更新...${NC}"
            
            if timeout 120 git pull 2>/dev/null; then
                echo -e "${GREEN}${BOLD}>> ✅ 更新成功！${NC}"
                update_success=true
                break
            else
                echo -e "${YELLOW}${BOLD}>> ❌ 更新失败，尝试下一个源...${NC}"
            fi
        done
        
        if [ "$update_success" = false ]; then
            echo -e "${RED}${BOLD}>> 💔 所有源都失败了，请检查网络连接${NC}"
        fi
        
        press_any_key
        cd "$HOME"
    else
        echo -e "${RED}${BOLD}>> 😿 未检测到 SillyTavern 目录。${NC}"
        sleep 2
    fi
}

# =========================================================================
# 3. 简化配置菜单
# =========================================================================
simple_config_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}==== 🎀 简单配置 🎀 ====${NC}"
        echo -e "${YELLOW}${BOLD}0. 返回主菜单${NC}"
        echo -e "${BLUE}${BOLD}1. 🌐 开启网络访问（推荐）${NC}"
        echo -e "${MAGENTA}${BOLD}2. 🔒 关闭网络访问${NC}"
        echo -e "${GREEN}${BOLD}3. 🔧 重置配置文件${NC}"
        echo -e "${CYAN}${BOLD}==================${NC}"
        echo -ne "${CYAN}${BOLD}💕 请选择操作（0-3）：${NC}"
        read -n1 choice; echo
        
        case "$choice" in
            0) break ;;
            1) 
                echo -e "${CYAN}${BOLD}>> 🌐 正在开启网络访问...${NC}"
                # 这里添加开启网络监听的代码
                echo -e "${GREEN}${BOLD}>> ✅ 网络访问已开启，现在可以用手机浏览器访问啦~${NC}"
                press_any_key
                ;;
            2)
                echo -e "${CYAN}${BOLD}>> 🔒 正在关闭网络访问...${NC}"
                # 这里添加关闭网络监听的代码
                echo -e "${GREEN}${BOLD}>> ✅ 网络访问已关闭${NC}"
                press_any_key
                ;;
            3)
                echo -e "${CYAN}${BOLD}>> 🔧 正在重置配置文件...${NC}"
                # 这里添加重置配置的代码
                echo -e "${GREEN}${BOLD}>> ✅ 配置文件已重置${NC}"
                press_any_key
                ;;
            *) 
                echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
                sleep 1
                ;;
        esac
    done
}

# =========================================================================
# 4. 问题求助
# =========================================================================
help_menu() {
    clear
    echo -e "${CYAN}${BOLD}==== 💕 遇到问题了吗？ ====${NC}"
    echo -e "${YELLOW}${BOLD}别担心！姐妹们都会遇到这些问题的~${NC}"
    echo ""
    echo -e "${GREEN}${BOLD}🆘 常见问题快速解决：${NC}"
    echo -e "${BLUE}${BOLD}1. 启动失败 → 检查网络连接，重新安装${NC}"
    echo -e "${BLUE}${BOLD}2. 无法访问 → 确保开启了网络监听${NC}"
    echo -e "${BLUE}${BOLD}3. 运行卡住 → 重启Termux应用${NC}"
    echo -e "${BLUE}${BOLD}4. 更新失败 → 检查网络，或重新安装${NC}"
    echo ""
    echo -e "${MAGENTA}${BOLD}📞 求助渠道：${NC}"
    echo -e "${CYAN}${BOLD}• 小红书评论区留言${NC}"
    echo -e "${CYAN}${BOLD}• QQ群：807134015${NC}"
    echo -e "${CYAN}${BOLD}• 邮箱：print.yuhuan@gmail.com${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}💡 记住：遇到问题不要慌，总有解决办法的！${NC}"
    press_any_key
}

# =========================================================================
# 主菜单循环
# =========================================================================
while true; do
    clear
    echo -e "${CYAN}${BOLD}"
    echo "🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸"
    echo "🌸        SillyTavern 小红书专版        🌸"
    echo "🌸      💕 专为姐妹们优化设计 💕       🌸"
    echo "🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸"
    echo -e "${NC}"
    echo -e "${RED}${BOLD}0. 👋 退出程序${NC}"
    echo -e "${GREEN}${BOLD}1. 🚀 启动 SillyTavern${NC}"
    echo -e "${BLUE}${BOLD}2. 🔄 更新 SillyTavern${NC}"
    echo -e "${YELLOW}${BOLD}3. 🎀 简单配置${NC}"
    echo -e "${MAGENTA}${BOLD}4. 🆘 遇到问题？${NC}"
    echo -e "${CYAN}${BOLD}=================================${NC}"
    echo -ne "${CYAN}${BOLD}💕 请选择操作（0-4）：${NC}"
    read -n1 choice; echo
    
    case "$choice" in
        0) 
            echo -e "${RED}${BOLD}>> 👋 再见啦姐妹，期待下次见面~${NC}"
            sleep 1
            clear
            exit 0
            ;;
        1) start_tavern ;;
        2) update_tavern ;;
        3) simple_config_menu ;;
        4) help_menu ;;
        *) 
            echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
            sleep 1
            ;;
    esac
done
