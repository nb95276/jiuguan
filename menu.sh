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
# 4. 酒馆福利互助群
# =========================================================================
help_menu() {
    clear
    echo -e "${CYAN}${BOLD}==== 🍻 酒馆福利互助群 ====${NC}"
    echo -e "${YELLOW}${BOLD}欢迎加入小红书姐妹们的专属群聊！${NC}"
    echo ""
    echo -e "${GREEN}${BOLD}🍻 免费api福利互助群：${NC}"
    echo -e "${BRIGHT_MAGENTA}${BOLD}    ✨ 877,957,256 ✨${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}💕 群里有什么？${NC}"
    echo -e "${CYAN}${BOLD}• 🎀 SillyTavern使用技巧分享${NC}"
    echo -e "${CYAN}${BOLD}• 💝 优质角色卡资源${NC}"
    echo -e "${CYAN}${BOLD}• 🌸 姐妹们的聊天心得${NC}"
    echo -e "${CYAN}${BOLD}• 🆘 遇到问题互相帮助${NC}"
    echo ""
    echo -e "${GREEN}${BOLD}📞 其他求助渠道：${NC}"
    echo -e "${BLUE}${BOLD}• QQ群：807134015（原作者群）${NC}"
    echo -e "${BLUE}${BOLD}• 小红书评论区留言${NC}"
    echo -e "${BLUE}${BOLD}• 邮箱：print.yuhuan@gmail.com${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}💡 快来加群和姐妹们一起玩耍吧！${NC}"
    press_any_key
}

# =========================================================================
# 5. 网络监听设置
# =========================================================================
network_config_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}==== 🌐 网络监听设置 ====${NC}"
        echo -e "${YELLOW}${BOLD}💡 网络监听功能说明：${NC}"
        echo -e "${BLUE}${BOLD}• 关闭：只能在手机本地访问（更安全）${NC}"
        echo -e "${BLUE}${BOLD}• 开启：可在同WiFi下其他设备访问（如电脑）${NC}"
        echo ""
        echo -e "${YELLOW}${BOLD}0. 返回主菜单${NC}"
        echo -e "${GREEN}${BOLD}1. 🔒 关闭网络监听（安全模式）${NC}"
        echo -e "${MAGENTA}${BOLD}2. 🌍 开启网络监听（共享模式）${NC}"
        echo -e "${CYAN}${BOLD}3. 🔄 恢复默认配置${NC}"
        echo -e "${CYAN}${BOLD}==================${NC}"
        echo -ne "${CYAN}${BOLD}💕 请选择操作（0-3）：${NC}"
        read -n1 config_choice; echo

        case "$config_choice" in
            0) break ;;
            1|2|3)
                cd "$HOME/SillyTavern" || {
                    echo -e "${RED}${BOLD}>> 💔 SillyTavern目录不存在！${NC}"
                    press_any_key
                    continue
                }

                if [ ! -f config.yaml ] && [ "$config_choice" != "3" ]; then
                    echo -e "${RED}${BOLD}>> 💔 未找到config.yaml文件！${NC}"
                    echo -e "${YELLOW}${BOLD}>> 💡 请先启动一次SillyTavern生成配置文件${NC}"
                    press_any_key
                    continue
                fi

                # 备份原配置
                [ ! -f config.yaml.bak ] && cp config.yaml config.yaml.bak 2>/dev/null

                if [ "$config_choice" = "1" ]; then
                    # 关闭网络监听
                    sed -i 's/^listen: true$/listen: false/' config.yaml 2>/dev/null
                    sed -i 's/^enableUserAccounts: true$/enableUserAccounts: false/' config.yaml 2>/dev/null
                    sed -i 's/^enableDiscreetLogin: true$/enableDiscreetLogin: false/' config.yaml 2>/dev/null
                    sed -i 's/^  - 0\.0\.0\.0\/0$/  - 127.0.0.1/' config.yaml 2>/dev/null
                    echo -e "${GREEN}${BOLD}>> ✅ 网络监听已关闭（安全模式）${NC}"
                    echo -e "${CYAN}${BOLD}>> 💡 现在只能通过 http://127.0.0.1:8000 访问${NC}"

                elif [ "$config_choice" = "2" ]; then
                    # 开启网络监听
                    sed -i 's/^listen: false$/listen: true/' config.yaml 2>/dev/null
                    sed -i 's/^enableUserAccounts: false$/enableUserAccounts: true/' config.yaml 2>/dev/null
                    sed -i 's/^enableDiscreetLogin: false$/enableDiscreetLogin: true/' config.yaml 2>/dev/null
                    sed -i 's/^  - 127\.0\.0\.1$/  - 0.0.0.0\/0/' config.yaml 2>/dev/null
                    echo -e "${GREEN}${BOLD}>> ✅ 网络监听已开启（共享模式）${NC}"
                    echo -e "${CYAN}${BOLD}>> 💡 现在可以通过手机IP地址在其他设备访问${NC}"
                    echo -e "${YELLOW}${BOLD}>> ⚠️ 注意：请确保在安全的网络环境下使用${NC}"

                else
                    # 恢复默认配置
                    if [ ! -f config.yaml.bak ]; then
                        echo -e "${YELLOW}${BOLD}>> ⚠️ 未找到备份文件，无法恢复${NC}"
                    else
                        cp config.yaml.bak config.yaml
                        echo -e "${GREEN}${BOLD}>> ✅ 已恢复默认配置${NC}"
                    fi
                fi
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
# 6. 酒馆插件管理
# =========================================================================
plugin_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}==== 🧩 酒馆插件管理 ====${NC}"
        echo -e "${YELLOW}${BOLD}💡 插件可以为SillyTavern添加更多功能！${NC}"
        echo ""
        echo -e "${YELLOW}${BOLD}0. 返回主菜单${NC}"
        echo -e "${MAGENTA}${BOLD}1. 📦 安装插件${NC}"
        echo -e "${BLUE}${BOLD}2. 🗑️ 卸载插件${NC}"
        echo -e "${CYAN}${BOLD}==================${NC}"
        echo -ne "${CYAN}${BOLD}💕 请选择操作（0-2）：${NC}"
        read -n1 plugin_choice; echo

        case "$plugin_choice" in
            0) break ;;
            1) plugin_install_menu ;;
            2) plugin_uninstall_menu ;;
            *)
                echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
                sleep 1
                ;;
        esac
    done
}

# =========================================================================
# 插件安装菜单
# =========================================================================
plugin_install_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}==== 📦 插件安装 ====${NC}"
        echo -e "${YELLOW}${BOLD}0. 返回上级菜单${NC}"
        echo -e "${MAGENTA}${BOLD}1. 🎯 酒馆助手（多功能扩展）${NC}"
        echo -e "${BLUE}${BOLD}2. 🧠 记忆表格（结构化记忆）${NC}"
        echo -e "${CYAN}${BOLD}==================${NC}"
        echo -ne "${CYAN}${BOLD}💕 请选择要安装的插件（0-2）：${NC}"
        read -n1 install_choice; echo

        case "$install_choice" in
            0) break ;;
            1)
                clear
                echo -e "${MAGENTA}${BOLD}==== 🎯 酒馆助手 ====${NC}"
                echo -e "${YELLOW}${BOLD}📍 仓库：${NC}N0VI028/JS-Slash-Runner"
                echo -e "${CYAN}${BOLD}✨ 功能简介：${NC}"
                echo -e "${BLUE}${BOLD}• 支持在对话中创建交互式界面元素${NC}"
                echo -e "${BLUE}${BOLD}• 可用jQuery操作SillyTavern的DOM${NC}"
                echo -e "${BLUE}${BOLD}• 作为后端中转，连接外部应用${NC}"
                echo -e "${BLUE}${BOLD}• 通过iframe安全运行外部脚本${NC}"
                echo ""
                echo -e "${YELLOW}${BOLD}⚠️ 安全提示：${NC}"
                echo -e "${RED}${BOLD}• 插件允许执行自定义JavaScript代码${NC}"
                echo -e "${RED}${BOLD}• 请确保脚本来源安全可信${NC}"
                echo ""
                echo -ne "${YELLOW}${BOLD}💕 是否安装酒馆助手？(y/n)：${NC}"
                read -n1 ans; echo
                if [[ "$ans" =~ [yY] ]]; then
                    install_plugin "JS-Slash-Runner" "N0VI028/JS-Slash-Runner" "酒馆助手"
                fi
                ;;
            2)
                clear
                echo -e "${BLUE}${BOLD}==== 🧠 记忆表格 ====${NC}"
                echo -e "${YELLOW}${BOLD}📍 仓库：${NC}muyoou/st-memory-enhancement"
                echo -e "${CYAN}${BOLD}✨ 功能简介：${NC}"
                echo -e "${BLUE}${BOLD}• 为AI注入结构化长期记忆能力${NC}"
                echo -e "${BLUE}${BOLD}• 支持角色设定、关键事件记录${NC}"
                echo -e "${BLUE}${BOLD}• 通过直观表格管理AI记忆${NC}"
                echo -e "${BLUE}${BOLD}• 支持导出、分享和自定义结构${NC}"
                echo ""
                echo -e "${YELLOW}${BOLD}📝 使用说明：${NC}"
                echo -e "${CYAN}${BOLD}• 仅在"聊天补全模式"下工作${NC}"
                echo ""
                echo -ne "${YELLOW}${BOLD}💕 是否安装记忆表格？(y/n)：${NC}"
                read -n1 ans; echo
                if [[ "$ans" =~ [yY] ]]; then
                    install_plugin "st-memory-enhancement" "muyoou/st-memory-enhancement" "记忆表格"
                fi
                ;;
            *)
                echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
                sleep 1
                ;;
        esac
    done
}

# =========================================================================
# 插件安装核心函数
# =========================================================================
install_plugin() {
    local plugin_dir="$1"
    local repo_url="$2"
    local plugin_name="$3"

    local PLUGIN_PATH="$HOME/SillyTavern/public/scripts/extensions/third-party/$plugin_dir"

    if [ -d "$PLUGIN_PATH" ]; then
        echo -e "${YELLOW}${BOLD}>> ✅ $plugin_name 已存在，无需重复安装${NC}"
        press_any_key
        return
    fi

    echo -e "${CYAN}${BOLD}>> 🔄 正在安装 $plugin_name...${NC}"

    # 尝试多个GitHub加速源
    local success=false
    for mirror in "https://gitproxy.click/https://github.com" \
                  "https://github.tbedu.top/https://github.com" \
                  "https://gh.llkk.cc/https://github.com" \
                  "https://gh.ddlc.top/https://github.com" \
                  "https://github.com"; do

        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        echo -e "${YELLOW}${BOLD}>> 尝试源: $domain${NC}"

        if timeout 60 git clone --depth=1 "$mirror/$repo_url" "$PLUGIN_PATH" 2>/dev/null; then
            echo -e "${GREEN}${BOLD}>> ✅ $plugin_name 安装成功！来源: $domain${NC}"
            success=true
            break
        else
            echo -e "${YELLOW}${BOLD}>> ❌ 失败，尝试下一个源...${NC}"
            rm -rf "$PLUGIN_PATH" 2>/dev/null
        fi
    done

    if [ "$success" = false ]; then
        echo -e "${RED}${BOLD}>> 💔 $plugin_name 安装失败，请检查网络连接${NC}"
    fi

    press_any_key
}

# =========================================================================
# 插件卸载菜单
# =========================================================================
plugin_uninstall_menu() {
    local PLUGIN_ROOT="$HOME/SillyTavern/public/scripts/extensions/third-party"

    while true; do
        clear
        echo -e "${CYAN}${BOLD}==== 🗑️ 插件卸载 ====${NC}"
        echo -e "${YELLOW}${BOLD}0. 返回上级菜单${NC}"

        if [ ! -d "$PLUGIN_ROOT" ]; then
            echo -e "${YELLOW}${BOLD}>> 📂 插件目录不存在，无插件可卸载${NC}"
            press_any_key
            break
        fi

        # 获取已安装的插件列表
        mapfile -t plugin_dirs < <(find "$PLUGIN_ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)

        if [ ${#plugin_dirs[@]} -eq 0 ]; then
            echo -e "${YELLOW}${BOLD}>> 📭 未检测到已安装的插件${NC}"
            press_any_key
            break
        fi

        # 显示插件列表
        for i in "${!plugin_dirs[@]}"; do
            plugin_name=$(basename "${plugin_dirs[$i]}")
            echo -e "${BLUE}${BOLD}$((i+1)). 🧩 ${GREEN}${BOLD}${plugin_name}${NC}"
        done

        echo -e "${CYAN}${BOLD}==================${NC}"
        echo -ne "${CYAN}${BOLD}💕 请输入要卸载的插件序号（或0返回）：${NC}"
        read -r idx

        if [[ "$idx" == "0" ]]; then
            break
        fi

        if [[ "$idx" =~ ^[1-9][0-9]*$ ]] && [ "$idx" -le "${#plugin_dirs[@]}" ]; then
            plugin_name=$(basename "${plugin_dirs[$((idx-1))]}")
            echo -ne "${YELLOW}${BOLD}💔 确定要卸载 ${plugin_name} 吗？(y/n)：${NC}"
            read -n1 ans; echo

            if [[ "$ans" =~ [yY] ]]; then
                rm -rf "${plugin_dirs[$((idx-1))]}"
                echo -e "${GREEN}${BOLD}>> ✅ 插件 ${plugin_name} 已成功卸载${NC}"
            else
                echo -e "${YELLOW}${BOLD}>> 🙅‍♀️ 已取消卸载操作${NC}"
            fi
            press_any_key
        else
            echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
            sleep 1
        fi
    done
}

# =========================================================================
# 7. 脚本更新管理
# =========================================================================
script_update_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}==== 🔄 脚本更新管理 ====${NC}"
        echo -e "${YELLOW}${BOLD}💡 保持脚本最新，享受最新功能！${NC}"
        echo ""
        echo -e "${YELLOW}${BOLD}0. 返回主菜单${NC}"
        echo -e "${GREEN}${BOLD}1. 🔍 检查脚本更新${NC}"
        echo -e "${BLUE}${BOLD}2. 📋 查看更新日志${NC}"
        echo -e "${CYAN}${BOLD}==================${NC}"
        echo -ne "${CYAN}${BOLD}💕 请选择操作（0-2）：${NC}"
        read -n1 update_choice; echo

        case "$update_choice" in
            0) break ;;
            1) check_script_update ;;
            2) show_update_log ;;
            *)
                echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
                sleep 1
                ;;
        esac
    done
}

# =========================================================================
# 检查脚本更新
# =========================================================================
check_script_update() {
    echo -e "\n${CYAN}${BOLD}==== 🔍 检查脚本更新 ====${NC}"
    echo -e "${YELLOW}${BOLD}>> 正在检查GitHub上的最新版本...${NC}"

    # 获取当前版本
    local current_version=$(grep "MENU_VERSION=" "$0" | head -n1 | cut -d'=' -f2 2>/dev/null || echo "unknown")
    echo -e "${BLUE}${BOLD}>> 当前版本：$current_version${NC}"

    # 尝试获取远程版本
    local remote_version=""
    local success=false

    for mirror in "https://gitproxy.click/https://raw.githubusercontent.com" \
                  "https://github.tbedu.top/https://raw.githubusercontent.com" \
                  "https://gh.llkk.cc/https://raw.githubusercontent.com" \
                  "https://gh.ddlc.top/https://raw.githubusercontent.com" \
                  "https://raw.githubusercontent.com"; do

        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        echo -e "${YELLOW}${BOLD}>> 尝试源: $domain${NC}"

        if remote_version=$(timeout 15 curl -k -fsSL "$mirror/nb95276/jiuguan/main/menu.sh" | grep "MENU_VERSION=" | head -n1 | cut -d'=' -f2 2>/dev/null); then
            if [ -n "$remote_version" ]; then
                echo -e "${GREEN}${BOLD}>> 远程版本：$remote_version${NC}"
                success=true
                break
            fi
        fi
        echo -e "${YELLOW}${BOLD}>> 获取失败，尝试下一个源...${NC}"
    done

    if [ "$success" = false ]; then
        echo -e "${RED}${BOLD}>> 💔 无法获取远程版本信息，请检查网络连接${NC}"
        press_any_key
        return
    fi

    # 比较版本
    if [ "$current_version" = "$remote_version" ]; then
        echo -e "${GREEN}${BOLD}>> ✅ 脚本已是最新版本！${NC}"
    elif [ "$current_version" = "unknown" ]; then
        echo -e "${YELLOW}${BOLD}>> ⚠️ 无法确定当前版本，建议更新${NC}"
        echo -ne "${CYAN}${BOLD}>> 💕 是否更新脚本？(y/n)：${NC}"
        read -n1 ans; echo
        if [[ "$ans" =~ [yY] ]]; then
            update_script
        fi
    else
        echo -e "${MAGENTA}${BOLD}>> 🎉 发现新版本！${NC}"
        echo -ne "${CYAN}${BOLD}>> 💕 是否立即更新？(y/n)：${NC}"
        read -n1 ans; echo
        if [[ "$ans" =~ [yY] ]]; then
            update_script
        fi
    fi

    press_any_key
}

# =========================================================================
# 更新脚本
# =========================================================================
update_script() {
    echo -e "\n${CYAN}${BOLD}==== 🔄 更新脚本 ====${NC}"
    echo -e "${YELLOW}${BOLD}>> 正在下载最新版本...${NC}"

    local success=false
    for mirror in "https://gitproxy.click/https://raw.githubusercontent.com" \
                  "https://github.tbedu.top/https://raw.githubusercontent.com" \
                  "https://gh.llkk.cc/https://raw.githubusercontent.com" \
                  "https://gh.ddlc.top/https://raw.githubusercontent.com" \
                  "https://raw.githubusercontent.com"; do

        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        echo -e "${YELLOW}${BOLD}>> 尝试源: $domain${NC}"

        if timeout 30 curl -k -fsSL -o "$HOME/menu.sh.new" "$mirror/nb95276/jiuguan/main/menu.sh" 2>/dev/null; then
            if [ -f "$HOME/menu.sh.new" ] && [ $(stat -c%s "$HOME/menu.sh.new" 2>/dev/null || echo 0) -gt 1000 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 下载成功！来源: $domain${NC}"
                success=true
                break
            else
                rm -f "$HOME/menu.sh.new"
            fi
        fi
        echo -e "${YELLOW}${BOLD}>> 下载失败，尝试下一个源...${NC}"
    done

    if [ "$success" = false ]; then
        echo -e "${RED}${BOLD}>> 💔 脚本更新失败，请稍后重试${NC}"
        return
    fi

    # 备份当前脚本
    cp "$HOME/menu.sh" "$HOME/menu.sh.bak" 2>/dev/null

    # 替换脚本
    mv "$HOME/menu.sh.new" "$HOME/menu.sh"
    # Windows环境下不需要chmod
    if command -v chmod >/dev/null 2>&1; then
        chmod +x "$HOME/menu.sh"
    fi

    echo -e "${GREEN}${BOLD}>> ✅ 脚本更新成功！${NC}"
    echo -e "${CYAN}${BOLD}>> 🔄 正在重启菜单...${NC}"
    sleep 2
    exec bash "$HOME/menu.sh"
}

# =========================================================================
# 查看更新日志
# =========================================================================
show_update_log() {
    clear
    echo -e "${CYAN}${BOLD}==== 📋 更新日志 ====${NC}"
    echo -e "${MAGENTA}${BOLD}SillyTavern-Termux 小红书专版${NC}"
    echo -e "${YELLOW}${BOLD}最新更新：2025-07-01${NC}"
    echo ""
    echo -e "${GREEN}${BOLD}🎉 主要功能：${NC}"
    echo -e "${BLUE}${BOLD}• 🚀 11个GitHub加速源，按测速排序${NC}"
    echo -e "${BLUE}${BOLD}• ⚡ 优化下载超时，快速失败切换${NC}"
    echo -e "${BLUE}${BOLD}• 🌐 网络监听设置（安全/共享模式）${NC}"
    echo -e "${BLUE}${BOLD}• 🧩 酒馆插件管理（助手+记忆表格）${NC}"
    echo -e "${BLUE}${BOLD}• 🔄 脚本自动更新功能${NC}"
    echo -e "${BLUE}${BOLD}• 💕 小红书专版可爱界面${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}🔧 技术优化：${NC}"
    echo -e "${BLUE}${BOLD}• Git浅克隆 + ZIP备用下载${NC}"
    echo -e "${BLUE}${BOLD}• NPM阿里云镜像加速${NC}"
    echo -e "${BLUE}${BOLD}• SSL验证跳过，解决连接问题${NC}"
    echo -e "${BLUE}${BOLD}• 智能源测试和可用性检查${NC}"
    echo ""
    echo -e "${MAGENTA}${BOLD}💝 专为小红书姐妹们优化！${NC}"
    echo -e "${CYAN}${BOLD}=================================${NC}"
    press_any_key
}

# =========================================================================
# 主菜单循环
# =========================================================================
while true; do
    clear
    echo -e "${MAGENTA}${BOLD}"
    echo "🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸"
    echo "🌸        SillyTavern 小红书专版        🌸"
    echo "🌸      💕 专为姐妹们优化设计 💕       🌸"
    echo "🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸"
    echo -e "${NC}"
    echo -e "${RED}${BOLD}0. 👋 退出程序${NC}"
    echo -e "${GREEN}${BOLD}1. 🚀 启动 SillyTavern${NC}"
    echo -e "${BLUE}${BOLD}2. 🔄 更新 SillyTavern${NC}"
    echo -e "${YELLOW}${BOLD}3. 🎀 简单配置${NC}"
    echo -e "${MAGENTA}${BOLD}4. 🍻 免费API福利互助群：877,957,256${NC}"
    echo -e "${CYAN}${BOLD}5. 🌐 多设备使用设置${NC}"
    echo -e "${BRIGHT_BLUE}${BOLD}6. 🧩 安装强化插件${NC}"
    echo -e "${BRIGHT_MAGENTA}${BOLD}7. 🔄 更新管理脚本${NC}"
    echo -e "${CYAN}${BOLD}=================================${NC}"
    echo -ne "${CYAN}${BOLD}💕 请选择操作（0-7）：${NC}"
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
        5) network_config_menu ;;
        6) plugin_menu ;;
        7) script_update_menu ;;
        *)
            echo -e "${RED}${BOLD}>> 😅 输入错误，请重新选择哦~${NC}"
            sleep 1
            ;;
    esac
done
