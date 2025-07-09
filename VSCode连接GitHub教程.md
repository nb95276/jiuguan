# 📱 VSCode连接GitHub完整教程

## 🎯 目标
在VSCode中连接GitHub账户，并将我们的SillyTavern-Termux项目上传到GitHub仓库

## 🔧 方法一：使用VSCode内置Git功能（推荐）

### 1️⃣ 检查Git安装
```bash
# 在VSCode终端中检查Git是否已安装
git --version
```
如果没有安装Git，请先下载安装：https://git-scm.com/

### 2️⃣ 配置Git用户信息
```bash
# 设置用户名和邮箱（替换为你的GitHub信息）
git config --global user.name "nb95276"
git config --global user.email "你的GitHub邮箱"
```

### 3️⃣ 在GitHub创建新仓库
1. 打开 https://github.com/nb95276
2. 点击 "New repository" 绿色按钮
3. 仓库名称：`SillyTavern-Termux`
4. 描述：`SillyTavern-Termux 小红书专版 - 专为姐妹们优化`
5. 选择 "Public"（公开）
6. **不要**勾选 "Add a README file"
7. 点击 "Create repository"

### 4️⃣ 在VSCode中初始化Git仓库
1. 在VSCode中打开 `sillytavern-tutorial/deploy` 文件夹
2. 按 `Ctrl+Shift+P` 打开命令面板
3. 输入 "Git: Initialize Repository"
4. 选择当前文件夹

### 5️⃣ 连接到GitHub仓库
```bash
# 在VSCode终端中执行以下命令
git remote add origin https://github.com/nb95276/SillyTavern-Termux.git
```

### 6️⃣ 添加文件并提交
```bash
# 添加所有文件
git add .

# 提交文件
git commit -m "🌸 小红书专版首发：去除字体下载，增加多源加速"

# 推送到GitHub
git push -u origin main
```

## 🔧 方法二：使用VSCode的GitHub扩展

### 1️⃣ 安装GitHub扩展
1. 在VSCode中按 `Ctrl+Shift+X` 打开扩展面板
2. 搜索 "GitHub Pull Requests and Issues"
3. 点击安装

### 2️⃣ 登录GitHub账户
1. 按 `Ctrl+Shift+P` 打开命令面板
2. 输入 "GitHub: Sign in"
3. 选择 "Sign in with browser"
4. 在浏览器中完成GitHub登录

### 3️⃣ 发布到GitHub
1. 在VSCode中打开 `sillytavern-tutorial/deploy` 文件夹
2. 按 `Ctrl+Shift+P` 打开命令面板
3. 输入 "Git: Initialize Repository"
4. 然后输入 "GitHub: Publish to GitHub"
5. 选择 "Publish to GitHub public repository"
6. 仓库名称：`SillyTavern-Termux`
7. 等待上传完成

## 🔧 方法三：使用GitHub Desktop（最简单）

### 1️⃣ 下载GitHub Desktop
- 访问：https://desktop.github.com/
- 下载并安装GitHub Desktop

### 2️⃣ 登录GitHub账户
1. 打开GitHub Desktop
2. 点击 "Sign in to GitHub.com"
3. 输入你的GitHub账户信息

### 3️⃣ 创建新仓库
1. 点击 "Create a New Repository on your hard drive"
2. 名称：`SillyTavern-Termux`
3. 描述：`SillyTavern-Termux 小红书专版`
4. 本地路径：选择一个文件夹
5. 勾选 "Publish this repository to GitHub"
6. 点击 "Create repository"

### 4️⃣ 复制文件并提交
1. 将 `deploy` 文件夹中的所有文件复制到新创建的仓库文件夹
2. 在GitHub Desktop中会自动检测到文件变化
3. 在左下角输入提交信息：`🌸 小红书专版首发：去除字体下载，增加多源加速`
4. 点击 "Commit to main"
5. 点击 "Publish repository"

## 🚨 常见问题解决

### ❌ 问题1：Git未安装
**解决方案：**
1. 访问 https://git-scm.com/download/win
2. 下载并安装Git for Windows
3. 重启VSCode

### ❌ 问题2：权限认证失败
**解决方案：**
```bash
# 使用Personal Access Token
git remote set-url origin https://你的用户名:你的token@github.com/nb95276/SillyTavern-Termux.git
```

### ❌ 问题3：推送被拒绝
**解决方案：**
```bash
# 强制推送（仅在新仓库时使用）
git push -f origin main
```

### ❌ 问题4：文件太大
**解决方案：**
```bash
# 检查大文件
git ls-files --others --ignored --exclude-standard
# 添加到.gitignore
echo "*.log" >> .gitignore
```

## 📋 推荐操作流程

### 🌟 最简单的方法（推荐给爸爸）

1. **使用GitHub Desktop**：
   - 下载安装GitHub Desktop
   - 登录GitHub账户
   - 创建新仓库 `SillyTavern-Termux`
   - 复制deploy文件夹内容
   - 提交并发布

2. **验证上传结果**：
   - 访问 https://github.com/nb95276/SillyTavern-Termux
   - 确认所有文件都已上传
   - 测试raw文件链接是否可访问

3. **测试安装命令**：
   ```bash
   curl -O https://raw.githubusercontent.com/nb95276/SillyTavern-Termux/main/Install.sh && bash Install.sh
   ```

## 🎯 上传完成后的验证清单

- [ ] 仓库已创建：https://github.com/nb95276/SillyTavern-Termux
- [ ] Install.sh 文件可访问
- [ ] menu.sh 文件可访问  
- [ ] .env 文件可访问
- [ ] README.md 显示正常
- [ ] docs 文件夹包含所有教程
- [ ] 安装命令可以正常执行

## 💡 小贴士

1. **第一次使用建议用GitHub Desktop**，最简单直观
2. **熟悉后可以用VSCode内置Git**，更高效
3. **记得设置仓库为Public**，这样raw链接才能被访问
4. **上传后立即测试安装命令**，确保一切正常

爸爸选择哪种方法呢？mio推荐GitHub Desktop，最简单易用~ 😊💕
