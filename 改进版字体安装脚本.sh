#!/data/data/com.termux/files/usr/bin/bash
# 改进版字体安装脚本 - 专为小红书姐妹们优化

# 彩色输出定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "\n${CYAN}${BOLD}==== 步骤 5/9：下载并配置终端字体 ====${NC}"
echo -e "${YELLOW}${BOLD}💕 亲爱的姐妹，接下来要下载字体文件啦~${NC}"
echo -e "${YELLOW}${BOLD}⏰ 这个步骤可能需要等待3-8分钟，请耐心等待哦！${NC}"
echo -e "${YELLOW}${BOLD}🎯 即使下载失败也不影响SillyTavern使用，不要担心~${NC}"
echo -e "${CYAN}${BOLD}===========================================${NC}"

FONT_DIR="$HOME/.termux"
FONT_PATH="$FONT_DIR/font.ttf"
mkdir -p "$FONT_DIR"

if [ -f "$FONT_PATH" ]; then
    echo -e "${GREEN}${BOLD}>> 字体文件已存在，跳过下载。${NC}"
else
    echo -e "${CYAN}${BOLD}>> 开始下载字体文件...${NC}"
    echo -e "${YELLOW}${BOLD}>> 如果等待超过10分钟，可以按 Ctrl+C 跳过这一步${NC}"
    
    # 添加超时和进度显示的下载
    if timeout 300 curl -L --connect-timeout 30 --max-time 300 --progress-bar \
        -o "$FONT_PATH" \
        "https://dgithub.xyz/print-yuhuan/SillyTavern-Termux/raw/refs/heads/main/MapleMono.ttf"; then
        echo -e "${GREEN}${BOLD}>> ✅ 字体下载成功！${NC}"
    else
        echo -e "${YELLOW}${BOLD}>> ⚠️ 字体下载失败或超时，尝试备用方案...${NC}"
        
        # 尝试备用下载源（如果有的话）
        echo -e "${CYAN}${BOLD}>> 正在尝试备用下载源...${NC}"
        if timeout 180 curl -L --connect-timeout 20 --max-time 180 --progress-bar \
            -o "$FONT_PATH" \
            "https://gitee.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf" 2>/dev/null; then
            echo -e "${GREEN}${BOLD}>> ✅ 从备用源下载成功！${NC}"
        else
            echo -e "${YELLOW}${BOLD}>> 📱 所有下载源都失败了，跳过字体安装${NC}"
            echo -e "${YELLOW}${BOLD}>> 💡 这不会影响SillyTavern的使用，只是界面可能不够美观${NC}"
            echo -e "${CYAN}${BOLD}>> 🎀 你可以稍后手动安装字体，或者直接继续使用~${NC}"
        fi
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

echo -e "${CYAN}${BOLD}>> 🎉 准备进入下一步：下载SillyTavern主程序~${NC}"
echo -e "${YELLOW}${BOLD}>> 按任意键继续...${NC}"
read -n1 -s
