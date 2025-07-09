#!/bin/bash
# SillyTavern-Termux 紧急回退脚本
# 用于快速回退到v1.0稳定版

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}🚨 SillyTavern-Termux 紧急回退工具 🚨${NC}"
echo -e "${YELLOW}此工具将帮助你回退到v1.0稳定版${NC}"
echo ""

# 检查当前版本
if [ -f "$HOME/menu.sh" ]; then
    current_version=$(grep "MENU_VERSION=" "$HOME/menu.sh" | head -n1 | cut -d'=' -f2 2>/dev/null || echo "unknown")
    echo -e "${CYAN}当前版本：${current_version}${NC}"
else
    echo -e "${YELLOW}未检测到已安装的版本${NC}"
fi

echo ""
echo -e "${YELLOW}回退选项：${NC}"
echo "1. 🔄 回退菜单脚本到v1.0"
echo "2. 🔄 回退安装脚本到v1.0"  
echo "3. 🔄 完全重新安装v1.0版本"
echo "0. ❌ 取消操作"
echo ""
read -p "请选择操作 (0-3): " choice

case "$choice" in
    1)
        echo -e "${CYAN}正在回退菜单脚本...${NC}"
        # 备份当前版本
        [ -f "$HOME/menu.sh" ] && cp "$HOME/menu.sh" "$HOME/menu.sh.v2.bak"
        
        # 下载v1.0菜单
        if curl -k -fsSL -o "$HOME/menu.sh" "https://gh.ddlc.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/menu.sh"; then
            chmod +x "$HOME/menu.sh"
            echo -e "${GREEN}✅ 菜单脚本已回退到v1.0${NC}"
        else
            echo -e "${RED}❌ 回退失败${NC}"
        fi
        ;;
    2)
        echo -e "${CYAN}正在下载v1.0安装脚本...${NC}"
        if curl -k -fsSL -o "Install-v1.0.sh" "https://gh.ddlc.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/Install.sh"; then
            chmod +x "Install-v1.0.sh"
            echo -e "${GREEN}✅ v1.0安装脚本已下载为 Install-v1.0.sh${NC}"
            echo -e "${YELLOW}运行: bash Install-v1.0.sh${NC}"
        else
            echo -e "${RED}❌ 下载失败${NC}"
        fi
        ;;
    3)
        echo -e "${CYAN}正在完全重新安装v1.0版本...${NC}"
        echo -e "${YELLOW}⚠️ 这将删除当前安装并重新开始${NC}"
        read -p "确定继续？(y/N): " confirm
        if [[ "$confirm" =~ [yY] ]]; then
            # 备份重要文件
            [ -d "$HOME/SillyTavern" ] && mv "$HOME/SillyTavern" "$HOME/SillyTavern.v2.bak"
            [ -f "$HOME/menu.sh" ] && mv "$HOME/menu.sh" "$HOME/menu.sh.v2.bak"
            
            # 下载并运行v1.0安装脚本
            if curl -k -fsSL -o "Install-v1.0.sh" "https://gh.ddlc.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/Install.sh"; then
                chmod +x "Install-v1.0.sh"
                echo -e "${GREEN}✅ 开始安装v1.0版本...${NC}"
                bash "Install-v1.0.sh"
            else
                echo -e "${RED}❌ 下载失败${NC}"
            fi
        else
            echo -e "${YELLOW}操作已取消${NC}"
        fi
        ;;
    0)
        echo -e "${YELLOW}操作已取消${NC}"
        ;;
    *)
        echo -e "${RED}无效选择${NC}"
        ;;
esac

echo ""
echo -e "${CYAN}回退操作完成${NC}"
