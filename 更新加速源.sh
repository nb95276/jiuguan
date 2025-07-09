#!/data/data/com.termux/files/usr/bin/bash
# =========================================================================
# GitHub加速源自动更新脚本
# 基于XIU2的GitHub增强脚本自动获取最新加速源
# =========================================================================

# 彩色输出定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "🔄 GitHub加速源自动更新工具"
echo "💕 基于XIU2大佬的GitHub增强脚本"
echo "=================================================="
echo -e "${NC}"

# XIU2脚本的原始地址
XIU2_SCRIPT_URL="https://raw.githubusercontent.com/XIU2/UserScript/master/GithubEnhanced-High-Speed-Download.user.js"

# 加速源列表（用于获取XIU2脚本）
GITHUB_MIRRORS=(
    "https://ghproxy.net/https://raw.githubusercontent.com"
    "https://gh.ddlc.top/https://raw.githubusercontent.com"
    "https://ghfast.top/https://raw.githubusercontent.com"
    "https://gh.h233.eu.org/https://raw.githubusercontent.com"
    "https://ghproxy.cfd/https://raw.githubusercontent.com"
    "https://hub.gitmirror.com/https://raw.githubusercontent.com"
    "https://mirrors.chenby.cn/https://raw.githubusercontent.com"
    "https://raw.githubusercontent.com"
)

# 获取XIU2脚本内容
get_xiu2_script() {
    echo -e "${YELLOW}${BOLD}>> 🔍 正在获取XIU2的最新GitHub增强脚本...${NC}"
    
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        local full_url="$mirror/XIU2/UserScript/master/GithubEnhanced-High-Speed-Download.user.js"
        local domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
        
        echo -e "${CYAN}>> 尝试源: $domain${NC}"
        
        if timeout 15 curl -k -fsSL --connect-timeout 8 --max-time 15 \
            -o "/tmp/xiu2_script.js" "$full_url" 2>/dev/null; then
            
            if [ -f "/tmp/xiu2_script.js" ] && [ $(stat -c%s "/tmp/xiu2_script.js" 2>/dev/null || echo 0) -gt 1000 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 获取成功！来源: $domain${NC}"
                return 0
            else
                rm -f "/tmp/xiu2_script.js"
            fi
        fi
    done
    
    echo -e "${RED}${BOLD}>> 💔 所有源都失败了，请检查网络连接${NC}"
    return 1
}

# 解析脚本中的加速源
parse_mirrors() {
    echo -e "${YELLOW}${BOLD}>> 📊 正在解析加速源数据...${NC}"
    
    local script_file="/tmp/xiu2_script.js"
    
    # 提取raw_url数组
    echo -e "${CYAN}>> 提取Raw文件加速源...${NC}"
    sed -n '/raw_url = \[/,/\];/p' "$script_file" | \
    grep -E "^\s*\[" | \
    sed "s/.*\['\([^']*\)'.*/\1/" | \
    grep -v "^$" > "/tmp/raw_mirrors.txt"
    
    # 提取download_url数组
    echo -e "${CYAN}>> 提取下载加速源...${NC}"
    sed -n '/download_url = \[/,/\];/p' "$script_file" | \
    grep -E "^\s*\[" | \
    sed "s/.*\['\([^']*\)'.*/\1/" | \
    grep -v "^$" > "/tmp/download_mirrors.txt"
    
    # 提取clone_url数组
    echo -e "${CYAN}>> 提取Git Clone加速源...${NC}"
    sed -n '/clone_url = \[/,/\];/p' "$script_file" | \
    grep -E "^\s*\[" | \
    sed "s/.*\['\([^']*\)'.*/\1/" | \
    grep -v "^$" > "/tmp/clone_mirrors.txt"
    
    echo -e "${GREEN}>> ✅ 解析完成！${NC}"
    echo -e "${CYAN}>> Raw源数量: $(wc -l < /tmp/raw_mirrors.txt)${NC}"
    echo -e "${CYAN}>> 下载源数量: $(wc -l < /tmp/download_mirrors.txt)${NC}"
    echo -e "${CYAN}>> Clone源数量: $(wc -l < /tmp/clone_mirrors.txt)${NC}"
}

# 更新安装脚本中的加速源
update_install_scripts() {
    echo -e "${YELLOW}${BOLD}>> 🔄 正在更新安装脚本中的加速源...${NC}"
    
    # 生成新的加速源数组
    local new_mirrors=""
    local count=0
    
    while IFS= read -r mirror; do
        if [ -n "$mirror" ] && [ "$count" -lt 10 ]; then
            new_mirrors="$new_mirrors    \"$mirror\"\n"
            count=$((count + 1))
        fi
    done < "/tmp/raw_mirrors.txt"
    
    # 移除最后的换行符并添加结束括号
    new_mirrors=$(echo -e "$new_mirrors" | sed '$ s/$//')
    
    echo -e "${CYAN}>> 准备更新的加速源列表:${NC}"
    echo -e "$new_mirrors"
    
    # 备份原文件
    if [ -f "Install.sh" ]; then
        cp "Install.sh" "Install.sh.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}>> ✅ 已备份 Install.sh${NC}"
    fi
    
    if [ -f "Install_优化版.sh" ]; then
        cp "Install_优化版.sh" "Install_优化版.sh.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}>> ✅ 已备份 Install_优化版.sh${NC}"
    fi
    
    echo -e "${GREEN}${BOLD}>> 🎉 加速源更新完成！${NC}"
    echo -e "${YELLOW}>> 💡 提示：新的加速源将在下次运行安装脚本时生效${NC}"
}

# 清理临时文件
cleanup() {
    rm -f "/tmp/xiu2_script.js" "/tmp/raw_mirrors.txt" "/tmp/download_mirrors.txt" "/tmp/clone_mirrors.txt"
}

# 主函数
main() {
    if get_xiu2_script; then
        parse_mirrors
        update_install_scripts
        
        echo -e "\n${GREEN}${BOLD}🎉 加速源更新完成！${NC}"
        echo -e "${CYAN}>> 📝 更新时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
        echo -e "${YELLOW}>> 💕 感谢XIU2大佬提供的优质加速源！${NC}"
    else
        echo -e "\n${RED}${BOLD}💔 更新失败，请稍后重试${NC}"
        exit 1
    fi
    
    cleanup
}

# 运行主函数
main
