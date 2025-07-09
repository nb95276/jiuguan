# 🌸 SillyTavern-Termux 小红书专版

> 💕 专为小红书姐妹们优化的安卓 SillyTavern 一键安装脚本

## 🎯 专版特色

### ✨ 解决了原版的痛点
- **❌ 去除字体下载**：原版字体文件不存在，会卡住5-10分钟
- **🚀 多源加速下载**：8个GitHub加速源轮询，告别下载慢
- **💕 用户友好界面**：可爱的提示信息，零基础也能懂
- **🛠️ 简化菜单操作**：去掉复杂功能，保留核心需求
- **🆘 完整问题解决**：提供详细的故障排除指南

### 🌟 新增功能
- **智能多源下载**：自动尝试多个加速源
- **友好错误提示**：用可爱的语言解释技术问题
- **快速求助通道**：集成多种求助方式
- **简化配置选项**：只保留必要的设置项

## 📱 一键安装命令

### 🌟 **版本选择**
- **🎀 v2.0 小白友好版**（推荐）：进度条显示、友好提示、简化菜单
- **🛡️ v1.0 稳定版**（应急备用）：经典版本，稳定可靠

### 🚀 v2.0 小白友好版（推荐）

```bash
# 🌟 方法1：gitproxy.click（最快 788ms）
curl -k -fsSL -o Install.sh https://gitproxy.click/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# ⚡ 方法2：github.tbedu.top（快速 1058ms）
curl -k -fsSL -o Install.sh https://github.tbedu.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🔥 方法3：gh.llkk.cc（稳定 1247ms）
curl -k -fsSL -o Install.sh https://gh.llkk.cc/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 💎 方法4：gh.ddlc.top（经典推荐）
curl -k -fsSL -o Install.sh https://gh.ddlc.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🛡️ 方法5：ghfast.top
curl -k -fsSL -o Install.sh https://ghfast.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🌐 方法6：gh.h233.eu.org
curl -k -fsSL -o Install.sh https://gh.h233.eu.org/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🔗 方法7：ghproxy.cfd
curl -k -fsSL -o Install.sh https://ghproxy.cfd/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🌸 方法8：hub.gitmirror.com
curl -k -fsSL -o Install.sh https://hub.gitmirror.com/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🎀 方法9：mirrors.chenby.cn
curl -k -fsSL -o Install.sh https://mirrors.chenby.cn/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 🌍 方法10：原始GitHub（海外用户）
curl -k -fsSL -o Install.sh https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# ⚠️ 方法11：ghproxy.net（最后选择）
curl -k -fsSL -o Install.sh https://ghproxy.net/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh
```

> 💡 **使用建议**：从方法1开始尝试，如果失败就试下一个！

### 🛡️ v1.0 稳定版（应急备用）

```bash
# 🌟 方法1：gh.ddlc.top（稳定版主力推荐）
curl -k -fsSL -o Install.sh https://gh.ddlc.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/Install.sh && bash Install.sh

# ⚡ 方法2：ghfast.top
curl -k -fsSL -o Install.sh https://ghfast.top/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/Install.sh && bash Install.sh

# 🛡️ 方法3：gh.h233.eu.org
curl -k -fsSL -o Install.sh https://gh.h233.eu.org/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/Install.sh && bash Install.sh

# 🌍 方法4：原始GitHub（海外用户）
curl -k -fsSL -o Install.sh https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/v1.0-stable/Install.sh && bash Install.sh
```

> ⚠️ **何时使用v1.0**：如果v2.0版本遇到问题，可以使用v1.0稳定版

## 🚨 **还是下载失败？**

### 💡 **问题分析**
国内用户的主要问题是**GitHub连接困难**，npm源一般都没问题！

### 🛠️ **GitHub连接解决方案**
```bash
# 方法1：使用wget替代curl
wget --no-check-certificate -O Install.sh https://gitproxy.click/https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh

# 方法2：检查DNS设置
echo "nameserver 8.8.8.8" > $PREFIX/etc/resolv.conf
echo "nameserver 114.114.114.114" >> $PREFIX/etc/resolv.conf

# 方法3：测试网络连通性
ping -c 3 gitproxy.click
```

### 🔧 **如果安装到一半失败**
```bash
# 重新运行安装脚本，会自动跳过已完成的步骤
bash Install.sh

# 或者手动安装依赖（如果只是最后一步失败）
cd ~/SillyTavern && npm install
```

### 🆘 **实在不行就求助**
- **酒馆福利互助群**：877957256（推荐）
- **原作者QQ群**：807134015
- **小红书评论区**：留言描述问题

## 🔧 与原版的区别

| 功能 | 原版 | 小红书专版 |
|------|------|------------|
| 字体下载 | ❌ 会卡住5-10分钟 | ✅ 完全跳过 |
| 下载源 | ❌ 单一源，容易失败 | ✅ 8个加速源轮询 |
| 用户界面 | ❌ 技术性语言 | ✅ 可爱友好提示 |
| 错误处理 | ❌ 英文错误信息 | ✅ 中文友好解释 |
| 菜单复杂度 | ❌ 功能过多 | ✅ 简化核心功能 |
| 问题解决 | ❌ 需要自己找答案 | ✅ 内置求助指南 |

## 🎀 安装步骤优化

### 原版9步 → 专版8步
1. **环境检测** - 增加友好提示
2. **切换镜像源** - 保持不变
3. **更新包管理器** - 增加进度说明
4. **安装依赖** - 优化错误处理
5. ~~字体下载~~ - **完全移除**
6. **克隆仓库** - **多源轮询下载**
7. **下载脚本** - **智能多源下载**
8. **配置自启** - 简化说明
9. **安装依赖** - 增加耐心提醒

## 💕 用户体验优化

### 🌸 语言风格
```bash
# 原版
echo ">> 检测到未安装：node，正在安装..."

# 专版  
echo ">> 📦 检测到未安装：node，正在为姐妹安装..."
```

### 🎯 错误处理
```bash
# 原版
echo ">> 仓库克隆失败，请检查网络连接。"

# 专版
echo ">> 💔 下载失败了，别担心！试试这些解决方法..."
```

### 🆘 求助支持
```bash
# 新增求助菜单
echo "🆘 遇到问题了吗？"
echo "• 小红书评论区留言"  
echo "• QQ群：807134015（原作者群）"
echo "• 小红书姐妹专版QQ群：877957256"
echo "• 邮箱求助"
```

## 🚀 GitHub加速源列表

我们使用以下8个加速源轮询下载：

1. `https://ghproxy.net/` - 主力加速源
2. `https://gh.ddlc.top/` - 备用源1
3. `https://ghfast.top/` - 备用源2
4. `https://gh.h233.eu.org/` - 备用源3
5. `https://ghproxy.cfd/` - 备用源4
6. `https://hub.gitmirror.com/` - 备用源5
7. `https://mirrors.chenby.cn/` - 备用源6
8. `https://github.com/` - 原始源

## 📋 文件说明

```
SillyTavern-Termux-小红书专版/
├── Install_优化版.sh     # 主安装脚本（去除字体，多源下载）
├── menu_优化版.sh        # 简化菜单脚本（用户友好）
├── .env_优化版           # 版本配置文件
├── README_小红书专版.md  # 本说明文件
└── 教程文档/
    ├── 字体安装问题解决方案.md
    ├── GitHub加速源解决方案.md
    ├── 实际问题案例分析.md
    └── 快速问题解决卡片.md
```

## 🌟 适用人群

### ✅ 完美适合
- 🎀 小红书的姐妹们
- 💕 热爱AI角色扮演的女性用户
- 📱 零技术基础的新手
- 🌸 想要简单易用体验的用户

### ⚠️ 可能不适合
- 🔧 需要高级功能的技术用户
- 💻 习惯复杂配置的开发者
- 🎯 需要自定义字体的用户

## 💡 使用建议

### 🎯 安装前准备
1. **下载正确的Termux**：GitHub或F-Droid版本
2. **确保网络稳定**：WiFi环境最佳
3. **预留充足时间**：整个过程30-60分钟
4. **保持耐心**：遇到问题不要慌张

### 🌸 安装过程中
1. **不要关闭应用**：即使看起来没反应
2. **耐心等待**：某些步骤需要几分钟
3. **注意提示**：按照屏幕提示操作
4. **遇到问题**：查看内置求助指南

### 💕 安装完成后
1. **测试启动**：确保能正常运行
2. **配置网络**：开启网络监听功能
3. **导入角色**：开始和AI聊天
4. **加入社群**：获得持续支持

## 🤝 社区支持

### 📞 求助渠道
- **小红书**：在相关教程下评论求助
- **QQ群**：807134015（原作者群）
- **小红书姐妹专版QQ群**：877957256
- **邮箱**：print.yuhuan@gmail.com

### 💖 贡献方式
- 🐛 报告问题和bug
- 💡 提出改进建议  
- 📝 分享使用心得
- 🎀 帮助其他姐妹解决问题

## 📄 协议说明

本专版基于原作者欤歡的SillyTavern-Termux项目优化而来，遵循原项目的非商业协议。

- ✅ 个人使用完全免费
- ✅ 可以分享给朋友
- ✅ 可以提出改进建议
- ❌ 禁止商业用途
- ❌ 禁止去除作者信息

## 🌈 更新日志

### v20250701 - 小红书专版首发
- 🎉 完全去除字体下载功能
- 🚀 增加8个GitHub加速源轮询
- 💕 优化用户界面和提示信息
- 🛠️ 简化菜单操作流程
- 🆘 增加完整的问题解决方案
- 📚 提供详细的教程文档

---

💕 **感谢原作者欤歡的优秀工作！**  
🌸 **感谢所有小红书姐妹们的支持！**  
✨ **让我们一起享受AI聊天的乐趣吧~**
