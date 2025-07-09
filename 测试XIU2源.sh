#!/data/data/com.termux/files/usr/bin/bash
# =========================================================================
# XIU2大佬GitHub加速源批量测试脚本
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
echo "🧪 XIU2大佬GitHub加速源批量测试"
echo "💕 测试最新最快的加速源"
echo "=================================================="
echo -e "${NC}"

# XIU2大佬的优质源列表
XIU2_SOURCES=(
    "https://ghproxy.net/https://raw.githubusercontent.com|英国伦敦|XIU2推荐"
    "https://ghfast.top/https://raw.githubusercontent.com|多国CDN|日韩新美德"
    "https://wget.la/https://raw.githubusercontent.com|香港台湾|ucdn.me"
    "https://hk.gh-proxy.com/https://raw.githubusercontent.com|香港专线|gh-proxy.com"
    "https://gh.h233.eu.org/https://raw.githubusercontent.com|美国CDN|XIU2自营"
    "https://gh.ddlc.top/https://raw.githubusercontent.com|美国CDN|mtr-static"
    "https://hub.gitmirror.com/https://raw.githubusercontent.com|美国CDN|GitMirror"
    "https://gh-proxy.com/https://raw.githubusercontent.com|美国CDN|gh-proxy.com"
    "https://cors.isteed.cc/raw.githubusercontent.com|美国CDN|Lufs's"
    "https://raw.kkgithub.com|香港日本|help.kkgithub.com"
)

# 测试文件
TEST_FILE="nb95276/jiuguan/master/README.md"
RESULTS=()

echo -e "${YELLOW}${BOLD}>> 🚀 开始测试 ${#XIU2_SOURCES[@]} 个XIU2大佬的加速源...${NC}"
echo ""

# 测试每个源
for i in "${!XIU2_SOURCES[@]}"; do
    IFS='|' read -r url location provider <<< "${XIU2_SOURCES[$i]}"
    
    echo -e "${CYAN}>> 测试源 $((i+1))/${#XIU2_SOURCES[@]}: ${location}${NC}"
    echo -e "${YELLOW}   提供商: ${provider}${NC}"
    
    # 构建完整URL
    if [[ "$url" == *"/raw.githubusercontent.com" ]]; then
        full_url="${url}/${TEST_FILE}"
    else
        full_url="${url}/${TEST_FILE}"
    fi
    
    # 测试下载速度和可用性
    start_time=$(date +%s.%N)
    
    if timeout 10 curl -k -fsSL --connect-timeout 5 --max-time 10 \
        -o "/tmp/test_${i}.txt" "$full_url" 2>/dev/null; then
        
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        
        if [ -f "/tmp/test_${i}.txt" ] && [ $(stat -c%s "/tmp/test_${i}.txt" 2>/dev/null || echo 0) -gt 100 ]; then
            file_size=$(stat -c%s "/tmp/test_${i}.txt" 2>/dev/null || echo 0)
            speed=$(echo "scale=2; $file_size / 1024 / $duration" | bc 2>/dev/null || echo "0")
            
            echo -e "${GREEN}   ✅ 成功 - 用时: ${duration}s - 速度: ${speed}KB/s${NC}"
            RESULTS+=("✅|$((i+1))|${location}|${provider}|${duration}s|${speed}KB/s|${url}")
            rm -f "/tmp/test_${i}.txt"
        else
            echo -e "${RED}   ❌ 失败 - 文件下载不完整${NC}"
            RESULTS+=("❌|$((i+1))|${location}|${provider}|失败|0KB/s|${url}")
        fi
    else
        echo -e "${RED}   ❌ 失败 - 连接超时或错误${NC}"
        RESULTS+=("❌|$((i+1))|${location}|${provider}|超时|0KB/s|${url}")
    fi
    
    echo ""
done

# 显示测试结果
echo -e "${CYAN}${BOLD}"
echo "=================================================="
echo "📊 XIU2大佬加速源测试结果"
echo "=================================================="
echo -e "${NC}"

echo -e "${GREEN}${BOLD}🏆 可用的加速源：${NC}"
success_count=0
for result in "${RESULTS[@]}"; do
    IFS='|' read -r status num location provider time speed url <<< "$result"
    if [[ "$status" == "✅" ]]; then
        echo -e "${GREEN}$num. ${location} (${provider}) - ${time} - ${speed}${NC}"
        success_count=$((success_count + 1))
    fi
done

echo ""
echo -e "${RED}${BOLD}💔 失败的加速源：${NC}"
for result in "${RESULTS[@]}"; do
    IFS='|' read -r status num location provider time speed url <<< "$result"
    if [[ "$status" == "❌" ]]; then
        echo -e "${RED}$num. ${location} (${provider}) - ${time}${NC}"
    fi
done

echo ""
echo -e "${CYAN}${BOLD}📈 测试统计：${NC}"
echo -e "${GREEN}✅ 成功: ${success_count}/${#XIU2_SOURCES[@]}${NC}"
echo -e "${RED}❌ 失败: $((${#XIU2_SOURCES[@]} - success_count))/${#XIU2_SOURCES[@]}${NC}"

if [ $success_count -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}${BOLD}💡 推荐使用成功的源进行安装！${NC}"
    echo -e "${CYAN}${BOLD}🎯 最快的几个源可以优先尝试~${NC}"
else
    echo ""
    echo -e "${RED}${BOLD}💔 所有XIU2源都失败了，请检查网络连接${NC}"
fi

echo ""
echo -e "${BRIGHT_MAGENTA}${BOLD}🍻 测试完成！记得加群：877,957,256${NC}"
