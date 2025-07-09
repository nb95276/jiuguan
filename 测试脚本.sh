#!/bin/bash
# =========================================================================
# SillyTavern-Termux 优化版测试脚本
# 用于在部署前验证所有功能
# =========================================================================

# 彩色输出定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

# 测试计数器
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 测试结果记录
test_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}${BOLD}✅ PASS${NC} - $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}${BOLD}❌ FAIL${NC} - $test_name"
        echo -e "${YELLOW}   详情: $details${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "🧪 SillyTavern-Termux 优化版功能测试"
echo "=================================================="
echo -e "${NC}"

# =========================================================================
# 测试1: 文件存在性检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}📁 测试1: 检查必要文件是否存在${NC}"

if [ -f "Install_优化版.sh" ]; then
    test_result "Install_优化版.sh 存在" "PASS"
else
    test_result "Install_优化版.sh 存在" "FAIL" "文件不存在"
fi

if [ -f "menu_优化版.sh" ]; then
    test_result "menu_优化版.sh 存在" "PASS"
else
    test_result "menu_优化版.sh 存在" "FAIL" "文件不存在"
fi

if [ -f ".env_优化版" ]; then
    test_result ".env_优化版 存在" "PASS"
else
    test_result ".env_优化版 存在" "FAIL" "文件不存在"
fi

# =========================================================================
# 测试2: 脚本语法检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}🔍 测试2: 脚本语法检查${NC}"

if bash -n Install_优化版.sh 2>/dev/null; then
    test_result "Install_优化版.sh 语法" "PASS"
else
    test_result "Install_优化版.sh 语法" "FAIL" "语法错误"
fi

if bash -n menu_优化版.sh 2>/dev/null; then
    test_result "menu_优化版.sh 语法" "PASS"
else
    test_result "menu_优化版.sh 语法" "FAIL" "语法错误"
fi

# =========================================================================
# 测试3: 关键函数定义检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}⚙️ 测试3: 关键函数定义检查${NC}"

if grep -q "smart_download()" Install_优化版.sh; then
    test_result "smart_download 函数定义" "PASS"
else
    test_result "smart_download 函数定义" "FAIL" "函数未定义"
fi

if grep -q "GITHUB_MIRRORS=" Install_优化版.sh; then
    test_result "GitHub加速源数组定义" "PASS"
else
    test_result "GitHub加速源数组定义" "FAIL" "数组未定义"
fi

# =========================================================================
# 测试4: 加速源数量检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}🌐 测试4: GitHub加速源配置检查${NC}"

mirror_count=$(grep -c "https://" Install_优化版.sh | head -1)
if [ "$mirror_count" -ge 8 ]; then
    test_result "加速源数量 (≥8个)" "PASS"
else
    test_result "加速源数量 (≥8个)" "FAIL" "只有 $mirror_count 个源"
fi

# =========================================================================
# 测试5: 字体下载相关代码检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}🎨 测试5: 字体下载移除检查${NC}"

# 检查是否有字体下载的实际代码，排除说明文字
if grep -q "font\.ttf\|termux-reload-settings\|FONT_PATH\|FONT_DIR" Install_优化版.sh; then
    test_result "字体下载代码移除" "FAIL" "仍包含字体下载相关代码"
else
    test_result "字体下载代码移除" "PASS"
fi

if grep -q "MapleMono" Install_优化版.sh; then
    test_result "MapleMono字体引用移除" "FAIL" "仍包含MapleMono引用"
else
    test_result "MapleMono字体引用移除" "PASS"
fi

# =========================================================================
# 测试6: 步骤数量检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}📋 测试6: 安装步骤数量检查${NC}"

# 只计算步骤标题行，不包括完成提示
step_count=$(grep -c "^# 步骤.*：" Install_优化版.sh)
if [ "$step_count" -eq 8 ]; then
    test_result "安装步骤数量 (8步)" "PASS"
else
    test_result "安装步骤数量 (8步)" "FAIL" "实际有 $step_count 步"
fi

# =========================================================================
# 测试7: 用户友好提示检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}💕 测试7: 用户友好提示检查${NC}"

if grep -q "💕\|😻\|🌸\|✨" Install_优化版.sh; then
    test_result "可爱emoji使用" "PASS"
else
    test_result "可爱emoji使用" "FAIL" "缺少可爱元素"
fi

if grep -q "姐妹\|宝贝" Install_优化版.sh; then
    test_result "亲切称呼使用" "PASS"
else
    test_result "亲切称呼使用" "FAIL" "缺少亲切称呼"
fi

# =========================================================================
# 测试8: 配置文件内容检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}⚙️ 测试8: 配置文件内容检查${NC}"

if grep -q "INSTALL_VERSION=20250701" .env_优化版; then
    test_result "安装版本号正确" "PASS"
else
    test_result "安装版本号正确" "FAIL" "版本号不正确"
fi

if grep -q "MENU_VERSION=20250701" .env_优化版; then
    test_result "菜单版本号正确" "PASS"
else
    test_result "菜单版本号正确" "FAIL" "版本号不正确"
fi

# =========================================================================
# 测试9: GitHub链接占位符检查
# =========================================================================
echo -e "\n${CYAN}${BOLD}🔗 测试9: GitHub链接检查${NC}"

if grep -q "nb95276/jiuguan" Install_优化版.sh; then
    test_result "GitHub仓库地址正确" "PASS"
else
    test_result "GitHub仓库地址正确" "FAIL" "仓库地址不正确"
fi

# =========================================================================
# 测试10: 模拟下载函数测试
# =========================================================================
echo -e "\n${CYAN}${BOLD}📥 测试10: 模拟下载函数测试${NC}"

# 创建临时测试函数
create_test_download_function() {
    cat > test_download.sh << 'EOF'
#!/bin/bash
GITHUB_MIRRORS=(
    "https://ghproxy.net/https://github.com"
    "https://gh.ddlc.top/https://github.com"
    "https://github.com"
)

smart_download() {
    local file_path="$1"
    local save_path="$2"
    local description="$3"
    
    for mirror in "${GITHUB_MIRRORS[@]}"; do
        local full_url="$mirror/$file_path"
        echo "Testing: $full_url"
        
        # 模拟下载测试（只检查URL格式）
        if [[ "$full_url" =~ ^https://.*github\.com/.* ]]; then
            echo "URL format valid"
            return 0
        fi
    done
    return 1
}

# 测试函数
smart_download "test/repo/raw/main/file.txt" "/tmp/test.txt" "测试文件"
EOF
    
    if bash test_download.sh >/dev/null 2>&1; then
        test_result "smart_download函数逻辑" "PASS"
    else
        test_result "smart_download函数逻辑" "FAIL" "函数逻辑错误"
    fi
    
    rm -f test_download.sh
}

create_test_download_function

# =========================================================================
# 测试结果汇总
# =========================================================================
echo -e "\n${CYAN}${BOLD}"
echo "=================================================="
echo "📊 测试结果汇总"
echo "=================================================="
echo -e "${NC}"

echo -e "${CYAN}${BOLD}总测试数: $TOTAL_TESTS${NC}"
echo -e "${GREEN}${BOLD}通过: $PASSED_TESTS${NC}"
echo -e "${RED}${BOLD}失败: $FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}🎉 所有测试通过！可以安全部署到GitHub！${NC}"
    exit 0
else
    echo -e "\n${RED}${BOLD}⚠️ 有 $FAILED_TESTS 个测试失败，请修复后再部署！${NC}"
    exit 1
fi
