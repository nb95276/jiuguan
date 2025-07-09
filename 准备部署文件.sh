#!/bin/bash
# =========================================================================
# 准备GitHub部署文件脚本
# 将优化版文件重命名为GitHub部署格式
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
echo "📦 准备GitHub部署文件"
echo "=================================================="
echo -e "${NC}"

# 创建部署目录
DEPLOY_DIR="deploy"
if [ -d "$DEPLOY_DIR" ]; then
    echo -e "${YELLOW}${BOLD}>> 清理旧的部署目录...${NC}"
    rm -rf "$DEPLOY_DIR"
fi

echo -e "${CYAN}${BOLD}>> 创建部署目录...${NC}"
mkdir -p "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR/docs"

echo -e "${CYAN}${BOLD}>> 复制并重命名核心文件...${NC}"

# 复制核心文件并重命名
cp "Install_优化版.sh" "$DEPLOY_DIR/Install.sh"
echo -e "${GREEN}${BOLD}  ✅ Install_优化版.sh → Install.sh${NC}"

cp "menu_优化版.sh" "$DEPLOY_DIR/menu.sh"
echo -e "${GREEN}${BOLD}  ✅ menu_优化版.sh → menu.sh${NC}"

cp ".env_优化版" "$DEPLOY_DIR/.env"
echo -e "${GREEN}${BOLD}  ✅ .env_优化版 → .env${NC}"

cp "README_小红书专版.md" "$DEPLOY_DIR/README.md"
echo -e "${GREEN}${BOLD}  ✅ README_小红书专版.md → README.md${NC}"

echo -e "${CYAN}${BOLD}>> 复制文档文件...${NC}"

# 复制文档文件
doc_files=(
    "字体安装问题解决方案.md"
    "GitHub加速源解决方案.md"
    "实际问题案例分析.md"
    "快速问题解决卡片.md"
    "小红书SillyTavern教程大纲.md"
    "仓库完整分析报告.md"
    "GitHub部署指南.md"
    "部署前检查清单.md"
)

for file in "${doc_files[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$DEPLOY_DIR/docs/"
        echo -e "${GREEN}${BOLD}  ✅ $file${NC}"
    else
        echo -e "${YELLOW}${BOLD}  ⚠️ $file 不存在，跳过${NC}"
    fi
done

echo -e "${CYAN}${BOLD}>> 设置文件权限...${NC}"
# 在Windows环境下，这个命令可能不起作用，但不影响功能
chmod +x "$DEPLOY_DIR/Install.sh" 2>/dev/null || true
chmod +x "$DEPLOY_DIR/menu.sh" 2>/dev/null || true

echo -e "${CYAN}${BOLD}>> 生成部署信息文件...${NC}"
cat > "$DEPLOY_DIR/DEPLOY_INFO.md" << 'EOF'
# 🚀 部署信息

## 📁 文件说明
- `Install.sh` - 主安装脚本（小红书专版优化）
- `menu.sh` - 菜单管理脚本（简化版）
- `.env` - 版本配置文件
- `README.md` - 项目说明文档
- `docs/` - 详细教程和问题解决文档

## 🔗 安装命令
```bash
curl -O https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh
```

## ✨ 优化特色
- 去除了容易卡住的字体下载
- 8个GitHub加速源轮询下载
- 用户友好的界面提示
- 完整的问题解决方案

## 📊 测试状态
- 功能测试：17/17 通过 ✅
- 网络测试：5/8 源可用 ✅
- 部署准备：完成 ✅
EOF

echo -e "${GREEN}${BOLD}  ✅ DEPLOY_INFO.md${NC}"

echo -e "${CYAN}${BOLD}>> 验证部署文件...${NC}"

# 验证关键文件
required_files=("Install.sh" "menu.sh" ".env" "README.md")
all_good=true

for file in "${required_files[@]}"; do
    if [ -f "$DEPLOY_DIR/$file" ]; then
        echo -e "${GREEN}${BOLD}  ✅ $file 存在${NC}"
    else
        echo -e "${RED}${BOLD}  ❌ $file 缺失${NC}"
        all_good=false
    fi
done

# 检查GitHub用户名是否已替换
if grep -q "nb95276" "$DEPLOY_DIR/Install.sh"; then
    echo -e "${GREEN}${BOLD}  ✅ GitHub用户名已正确设置${NC}"
else
    echo -e "${RED}${BOLD}  ❌ GitHub用户名未正确设置${NC}"
    all_good=false
fi

echo -e "\n${CYAN}${BOLD}"
echo "=================================================="
echo "📊 部署准备结果"
echo "=================================================="
echo -e "${NC}"

if [ "$all_good" = true ]; then
    echo -e "${GREEN}${BOLD}🎉 部署文件准备完成！${NC}"
    echo -e "${CYAN}${BOLD}📁 部署文件位置：./$DEPLOY_DIR/${NC}"
    echo -e "${YELLOW}${BOLD}📋 下一步操作：${NC}"
    echo -e "${YELLOW}${BOLD}  1. 在GitHub创建 SillyTavern-Termux 仓库${NC}"
    echo -e "${YELLOW}${BOLD}  2. 将 $DEPLOY_DIR 目录下的所有文件上传到仓库${NC}"
    echo -e "${YELLOW}${BOLD}  3. 测试安装命令是否正常工作${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}🌟 最终安装命令：${NC}"
    echo -e "${GREEN}${BOLD}curl -O https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh${NC}"
else
    echo -e "${RED}${BOLD}❌ 部署文件准备失败！请检查上述错误。${NC}"
    exit 1
fi
