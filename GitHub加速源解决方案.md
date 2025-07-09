# 🚀 GitHub下载加速完全指南

## 💡 为什么需要GitHub加速？

姐妹们在安装SillyTavern时经常遇到的问题：
- 🐌 GitHub下载速度超级慢
- ⏰ 字体文件下载卡住5-10分钟
- 💔 下载失败导致安装中断
- 😿 网络环境限制访问GitHub

## ✨ 解决方案：多重加速源

### 🎯 推荐加速源（按速度排序）

#### 🥇 一线加速源（速度最快）
```
https://ghproxy.net/
https://gh.ddlc.top/
https://ghfast.top/
https://gh.h233.eu.org/
```

#### 🥈 二线加速源（稳定可靠）
```
https://ghproxy.cfd/
https://hub.gitmirror.com/
https://mirrors.chenby.cn/
https://dgithub.xyz/
```

#### 🥉 备用加速源（应急使用）
```
https://ghproxy.xiaopa.cc/
https://gh.ddlc.top/
https://github.moeyy.xyz/
https://fastgit.cc/
```

## 🛠️ 使用方法

### 原始GitHub链接：
```
https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf
```

### 加速后的链接：
```
https://ghproxy.net/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf
```

### 📱 手动下载字体的方法：

如果自动安装失败，姐妹们可以手动下载：

```bash
# 方法1：使用最快的加速源
curl -L -o ~/.termux/font.ttf "https://ghproxy.net/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"

# 方法2：如果方法1失败，尝试备用源
curl -L -o ~/.termux/font.ttf "https://gh.ddlc.top/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"

# 方法3：最后的备用方案
curl -L -o ~/.termux/font.ttf "https://dgithub.xyz/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
```

## 🎀 小红书姐妹专用简化版

### 🌟 一键解决字体下载问题

复制以下命令到Termux中执行：

```bash
# 创建字体目录
mkdir -p ~/.termux

# 智能多源下载（会自动尝试多个源）
for url in \
  "https://ghproxy.net/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf" \
  "https://gh.ddlc.top/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf" \
  "https://ghfast.top/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"; do
  echo "尝试下载: $(echo $url | cut -d'/' -f3)"
  if curl -L --connect-timeout 10 --max-time 30 -o ~/.termux/font.ttf "$url"; then
    echo "✅ 下载成功！"
    break
  else
    echo "❌ 失败，尝试下一个源..."
  fi
done

# 应用字体设置
termux-reload-settings 2>/dev/null || echo "请重启Termux使字体生效"
```

## 🔧 进阶技巧

### 测试加速源速度
```bash
# 测试哪个源最快
time curl -I "https://ghproxy.net/https://github.com/print-yuhuan/SillyTavern-Termux/raw/main/MapleMono.ttf"
```

### 设置默认加速源
```bash
# 在.bashrc中添加别名
echo 'alias github-dl="curl -L --connect-timeout 10 --max-time 60"' >> ~/.bashrc
```

## 🌈 常见问题解答

### Q: 为什么有些加速源也很慢？
A: 加速源的速度会根据时间和地区变化，建议多试几个

### Q: 可以同时使用多个加速源吗？
A: 可以！我们的脚本就是按顺序尝试多个源

### Q: 哪个加速源最稳定？
A: `ghproxy.net` 和 `gh.ddlc.top` 通常比较稳定

### Q: 如果所有加速源都失败怎么办？
A: 可以跳过字体安装，不影响SillyTavern使用

## 💕 贴心提醒

1. **网络环境**：WiFi通常比移动数据更稳定
2. **时间选择**：避开网络高峰期（晚上8-10点）
3. **耐心等待**：即使用了加速源，也可能需要1-3分钟
4. **备用方案**：准备好跳过字体安装的方法

记住：字体只是让界面更美观，不是必需的！
姐妹们不要因为这一步就放弃整个安装过程哦~ 💖✨
