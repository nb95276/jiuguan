# 🌸 SillyTavern-Termux VPN精简版 - 安装命令

> 💕 专为有VPN的小红书姐妹们设计，直连GitHub官方，无需加速源

---

## 🚀 一键安装命令

### 📱 **推荐安装方式**（VPN用户专用）

```bash
curl -fsSL -o install_精简版.sh https://github.com/nb95276/jiuguan/raw/main/install_精简版.sh && bash install_精简版.sh
```

> 💡 **使用说明**：复制上面的命令，在Termux中粘贴并回车即可！

---

## 🌐 备用安装命令

如果上面的命令网络不好，可以尝试以下方式：

### 🥇 **方法1：分步下载**

```bash
# 先下载脚本
curl -fsSL -o install_精简版.sh https://github.com/nb95276/jiuguan/raw/main/install_精简版.sh

# 再执行安装
bash install_精简版.sh
```

### 🥈 **方法2：使用wget**

```bash
wget -O install_精简版.sh https://github.com/nb95276/jiuguan/raw/main/install_精简版.sh && bash install_精简版.sh
```

### 🥉 **方法3：手动下载**

如果命令行下载失败，可以：
1. 在浏览器中访问：`https://github.com/nb95276/jiuguan/raw/main/install_精简版.sh`
2. 保存文件到手机
3. 复制到Termux目录
4. 运行：`bash install_精简版.sh`

---

## ⚠️ 使用前提

### 🌐 网络要求
- ✅ **必须有稳定的VPN连接**
- ✅ **可以正常访问GitHub**
- ✅ **网络连接稳定**

### 📱 设备要求
- ✅ Android手机
- ✅ 已安装Termux应用
- ✅ 有足够的存储空间（至少1GB）

---

## 🎯 精简版特色

### ✨ 与标准版的区别

| 特性 | 标准版 | VPN精简版 |
|------|--------|-----------|
| GitHub访问 | 🔄 11个加速源轮询 | 🌐 直连官方仓库 |
| 安装复杂度 | 📊 复杂（多源测试） | 🎯 简洁（直接下载） |
| 适用用户 | 👥 所有用户 | 🌐 VPN用户 |
| npm源 | 🇨🇳 国内镜像 | 🇨🇳 国内镜像 |
| 代码量 | 📄 576行 | 📄 365行 |

### 💕 保留的优势
- 🎀 可爱的小红书专版界面
- 📊 彩色进度条显示
- 🔧 npm国内镜像加速
- 🚀 自动启动和浏览器打开
- 📱 完整的菜单管理系统

---

## 📋 安装流程预览

```
🌸 安装进度：[██████████] 100%
💕 安装步骤预览

步骤 1/8: 环境检测 ✅
步骤 2/8: 切换镜像源 ✅  
步骤 3/8: 更新系统 ✅
步骤 4/8: 安装依赖 ✅
步骤 5/8: 克隆仓库 ✅ (直连GitHub官方)
步骤 6/8: 创建菜单 ✅
步骤 7/8: 配置启动 ✅
步骤 8/8: 安装依赖 ✅ (npm国内镜像)
```

---

## 🔧 故障排除

### 常见问题解决

#### ❌ 问题1：无法下载脚本
```bash
# 解决方案：检查VPN连接
curl -I https://github.com
# 应该返回200状态码
```

#### ❌ 问题2：GitHub克隆失败
```bash
# 解决方案：测试GitHub连接
git ls-remote https://github.com/SillyTavern/SillyTavern
# 应该显示仓库信息
```

#### ❌ 问题3：菜单下载失败
```bash
# 解决方案：手动下载菜单
curl -fsSL -o ~/menu.sh https://github.com/nb95276/jiuguan/raw/main/menu.sh
chmod +x ~/menu.sh
```

### 🆘 求助渠道
- **QQ群**：877,957,256（免费API福利互助群）
- **原作者群**：807134015
- **邮箱**：print.yuhuan@gmail.com

---

## 🌟 使用建议

### 💡 最佳实践
1. **网络环境**：使用稳定的WiFi + VPN
2. **时间选择**：避开网络高峰期
3. **耐心等待**：依赖安装需要5-10分钟
4. **保持连接**：安装过程中不要断开VPN

### ⚠️ 注意事项
- 确保VPN稳定，避免安装中断
- 如果安装失败，可以重新运行脚本
- 建议在电量充足时进行安装
- 安装完成后记得加群交流

---

## 🍻 社群推广

### 💕 免费API福利互助群

**QQ群号：877,957,256**

加群理由：
- 🎀 获取SillyTavern使用技巧
- 💝 分享优质角色卡资源  
- 🌸 和姐妹们交流聊天心得
- 🆘 遇到问题及时求助

### 📢 群内福利
- 免费API接口分享
- 角色卡制作教程
- 使用技巧分享
- 问题解答互助

---

## 🎉 安装完成后

### 🚀 启动方式
```bash
# 方法1：直接启动菜单
bash ~/menu.sh

# 方法2：进入SillyTavern目录启动
cd ~/SillyTavern
npm start
```

### 🌐 访问地址
- **本地访问**：http://127.0.0.1:8000
- **手机浏览器**：自动打开
- **其他设备**：需要配置网络监听

---

## 💖 特别提醒

**VPN精简版适合：**
- ✅ 有稳定VPN的用户
- ✅ 可以访问GitHub的用户
- ✅ 希望简洁安装流程的用户

**如果你没有VPN或网络不稳定，请使用标准版：**
```bash
curl -sL https://github.com/nb95276/jiuguan/raw/master/install.sh | bash
```

---

## 🌸 结语

VPN精简版让有网络优势的姐妹们享受更直接、更快速的安装体验！

记住安装完成后一定要加群哦~ 💕

**🍻 免费API福利互助群：877,957,256**
