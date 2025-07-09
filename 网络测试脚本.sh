#!/bin/bash
# =========================================================================
# GitHub加速源网络连接测试脚本
# 测试各个加速源的可用性和响应速度
# =========================================================================

# 彩色输出定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

# GitHub加速源列表
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

# 测试用的GitHub文件路径
TEST_FILE="octocat/Hello-World/raw/master/README"

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "🌐 GitHub加速源网络连接测试"
echo "=================================================="
echo -e "${NC}"

echo -e "${YELLOW}${BOLD}💕 正在测试各个加速源的连接速度...${NC}\n"

working_sources=0
total_sources=${#GITHUB_MIRRORS[@]}

for i in "${!GITHUB_MIRRORS[@]}"; do
    mirror="${GITHUB_MIRRORS[$i]}"
    domain=$(echo "$mirror" | sed 's|https://||' | cut -d'/' -f1)
    test_url="$mirror/$TEST_FILE"
    
    echo -e "${CYAN}${BOLD}测试源 $((i+1))/$total_sources: $domain${NC}"
    
    # 测试连接速度和可用性
    start_time=$(date +%s.%N)
    
    if timeout 10 curl -fsSL --connect-timeout 5 --max-time 10 \
        "$test_url" >/dev/null 2>&1; then
        
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "N/A")
        
        echo -e "${GREEN}${BOLD}  ✅ 可用 - 响应时间: ${duration}s${NC}"
        working_sources=$((working_sources + 1))
    else
        echo -e "${RED}${BOLD}  ❌ 不可用 - 连接失败或超时${NC}"
    fi
    
    echo ""
done

echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "📊 测试结果汇总"
echo "=================================================="
echo -e "${NC}"

echo -e "${CYAN}${BOLD}总加速源数: $total_sources${NC}"
echo -e "${GREEN}${BOLD}可用源数: $working_sources${NC}"
echo -e "${RED}${BOLD}不可用源数: $((total_sources - working_sources))${NC}"

success_rate=$((working_sources * 100 / total_sources))
echo -e "${YELLOW}${BOLD}成功率: $success_rate%${NC}"

echo ""

if [ $working_sources -ge 3 ]; then
    echo -e "${GREEN}${BOLD}🎉 测试通过！有足够的可用加速源，可以安全部署！${NC}"
    echo -e "${CYAN}${BOLD}💡 建议：即使部分源不可用，脚本的轮询机制会自动尝试其他源${NC}"
    exit 0
elif [ $working_sources -ge 1 ]; then
    echo -e "${YELLOW}${BOLD}⚠️ 警告：可用源较少，但仍可部署${NC}"
    echo -e "${CYAN}${BOLD}💡 建议：监控网络状况，必要时添加更多备用源${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}❌ 测试失败！所有加速源都不可用${NC}"
    echo -e "${YELLOW}${BOLD}💡 可能原因：${NC}"
    echo -e "${YELLOW}${BOLD}   1. 网络连接问题${NC}"
    echo -e "${YELLOW}${BOLD}   2. 防火墙限制${NC}"
    echo -e "${YELLOW}${BOLD}   3. 加速源服务异常${NC}"
    echo -e "${CYAN}${BOLD}💡 建议：检查网络连接后重新测试${NC}"
    exit 1
fi
