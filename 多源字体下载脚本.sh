#!/data/data/com.termux/files/usr/bin/bash
# 多源字体下载脚本 - 使用多个GitHub加速镜像
# 专为小红书姐妹们优化，解决字体下载卡住问题

# 彩色输出定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

# 字体下载源列表（按速度和稳定性排序）
FONT_SOURCES=(
    "https://ghproxy.net/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://gh.ddlc.top/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://ghfast.top/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://gh.h233.eu.org/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://ghproxy.cfd/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://hub.gitmirror.com/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://mirrors.chenby.cn/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
    "https://dgithub.xyz/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
)

echo -e "\n${CYAN}${BOLD}==== 步骤 5/9：智能字体下载 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 姐妹们好！现在要下载漂亮的字体啦~${NC}"
echo -e "${CYAN}${BOLD}✨ 使用了多个加速源，速度会更快哦！${NC}"

FONT_DIR="$HOME/.termux"
FONT_PATH="$FONT_DIR/font.ttf"
mkdir -p "$FONT_DIR"

if [ -f "$FONT_PATH" ]; then
    echo -e "${GREEN}${BOLD}>> 字体文件已存在，跳过下载。${NC}"
else
    echo -e "${CYAN}${BOLD}>> 开始智能下载字体文件...${NC}"
    
    download_success=false
    source_count=1
    total_sources=${#FONT_SOURCES[@]}
    
    for source in "${FONT_SOURCES[@]}"; do
        echo -e "${YELLOW}${BOLD}>> 尝试源 $source_count/$total_sources...${NC}"
        
        # 显示当前使用的源（简化显示）
        domain=$(echo "$source" | sed 's|https://||' | cut -d'/' -f1)
        echo -e "${CYAN}${BOLD}>> 使用加速源: $domain${NC}"
        
        # 尝试下载，设置较短的超时时间
        if timeout 60 curl -L --connect-timeout 10 --max-time 60 --progress-bar \
            -o "$FONT_PATH" "$source" 2>/dev/null; then
            
            # 验证下载的文件是否有效（检查文件大小）
            if [ -f "$FONT_PATH" ] && [ $(stat -c%s "$FONT_PATH" 2>/dev/null || echo 0) -gt 10000 ]; then
                echo -e "${GREEN}${BOLD}>> ✅ 字体下载成功！来源: $domain${NC}"
                download_success=true
                break
            else
                echo -e "${YELLOW}${BOLD}>> ⚠️ 文件无效，尝试下一个源...${NC}"
                rm -f "$FONT_PATH"
            fi
        else
            echo -e "${YELLOW}${BOLD}>> ⚠️ 下载失败，尝试下一个源...${NC}"
            rm -f "$FONT_PATH"
        fi
        
        source_count=$((source_count + 1))
        
        # 如果不是最后一个源，给用户一个跳过的机会
        if [ $source_count -le $total_sources ]; then
            echo -e "${CYAN}${BOLD}>> 按任意键继续尝试下一个源，或按 Ctrl+C 跳过字体安装${NC}"
            read -t 3 -n1 2>/dev/null || true
        fi
    done
    
    if [ "$download_success" = false ]; then
        echo -e "${YELLOW}${BOLD}>> 📱 所有下载源都尝试过了，跳过字体安装${NC}"
        echo -e "${CYAN}${BOLD}>> 💡 这不会影响SillyTavern的使用，只是界面可能不够美观${NC}"
        echo -e "${YELLOW}${BOLD}>> 🎀 你可以稍后手动安装字体，或者直接继续使用~${NC}"
        echo -e "${GREEN}${BOLD}>> 🌟 继续安装SillyTavern主程序吧！${NC}"
    fi
fi

# 如果字体文件存在，尝试应用
if [ -f "$FONT_PATH" ]; then
    echo -e "${CYAN}${BOLD}>> 正在应用字体设置...${NC}"
    if command -v termux-reload-settings >/dev/null 2>&1; then
        if termux-reload-settings 2>/dev/null; then
            echo -e "${GREEN}${BOLD}>> ✨ 字体配置成功，界面会更美观哦~${NC}"
        else
            echo -e "${YELLOW}${BOLD}>> 字体已下载，请重启Termux使其生效${NC}"
        fi
    else
        echo -e "${YELLOW}${BOLD}>> 字体已下载，请重启Termux使其生效${NC}"
    fi
    echo -e "${GREEN}${BOLD}>> 步骤 5/9 完成：终端字体已配置。${NC}"
else
    echo -e "${YELLOW}${BOLD}>> 步骤 5/9 跳过：字体未安装，但不影响使用。${NC}"
fi

echo -e "${CYAN}${BOLD}===========================================${NC}"
echo -e "${GREEN}${BOLD}>> 🎉 准备进入下一步：下载SillyTavern主程序~${NC}"
echo -e "${YELLOW}${BOLD}>> 按任意键继续...${NC}"
read -n1 -s
