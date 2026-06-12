# 构建 Android APK 指南

## 📱 单词小达人 App

### 项目信息
- **应用名称**: 单词小达人
- **版本**: 1.0.0+1
- **目标平台**: Android
- **最低 SDK**: Android 5.0 (API 21)

---

## 🚀 快速开始

### 方案1：本地构建（推荐）

#### 前提条件
1. **Flutter SDK** ✅ 已安装
2. **Java JDK 17** ✅ 已安装
3. **Android SDK** ❌ 需要安装

#### 安装步骤

**第一步：安装 Android Studio**

1. 下载 Android Studio：
   - 官网：https://developer.android.com/studio
   - 或使用国内镜像：https://developer.android.google.cn/studio

2. 运行安装程序，按向导完成安装

3. 首次启动时选择 "Standard" 安装，等待 SDK 下载完成

**第二步：配置环境变量**

安装完成后，设置环境变量：
```
ANDROID_HOME = C:\Users\你的用户名\AppData\Local\Android\Sdk
```

Path 中添加：
```
%ANDROID_HOME%\platform-tools
```

**第三步：接受许可协议**

打开命令行运行：
```bash
flutter doctor --android-licenses
```
输入 `y` 接受所有许可

**第四步：验证安装**

```bash
flutter doctor
```

确保看到：
```
[✓] Android toolchain - develop for Android devices
```

**第五步：构建 APK**

在项目目录运行：
```bash
# 方法1：使用构建脚本
build_apk.bat

# 方法2：直接运行命令
flutter build apk --release
```

**第六步：获取 APK**

构建成功后，APK 文件位于：
```
build\app\outputs\flutter-apk\app-release.apk
```

将此文件传输到手机即可安装使用！

---

### 方案2：使用 GitHub Actions（无需安装 SDK）

#### 步骤1：创建 GitHub 仓库
1. 访问 https://github.com/new
2. 创建新仓库（如：word-master）

#### 步骤2：上传代码
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/你的用户名/word-master.git
git push -u origin main
```

#### 步骤3：触发构建
1. 访问仓库的 Actions 页面
2. 选择 "Build Android APK" 工作流
3. 点击 "Run workflow"

#### 步骤4：下载 APK
1. 等待构建完成（约5-10分钟）
2. 在 Actions 页面点击最新的构建
3. 下载 "Artifacts" 中的 `word-master-apk`

---

## 📲 安装到手机

### 方法1：USB 安装
1. 手机开启 USB 调试（设置 -> 开发者选项 -> USB调试）
2. 连接电脑
3. 运行：`flutter install`

### 方法2：文件传输
1. 将 APK 文件复制到手机
2. 在手机上打开文件管理器
3. 找到并点击 APK 文件
4. 允许安装未知来源应用
5. 完成安装

### 方法3：二维码分享
1. 上传 APK 到云存储（如 Google Drive、腾讯微云等）
2. 生成分享链接
3. 使用二维码生成器创建二维码
4. 手机扫描二维码下载安装

---

## ❓ 常见问题

### Q1: 构建失败，提示找不到 Android SDK
**解决方案**：
1. 确保已安装 Android Studio
2. 运行 `flutter config --android-sdk "SDK路径"`
3. 运行 `flutter doctor` 检查配置

### Q2: 构建失败，提示 Java 版本错误
**解决方案**：
1. 安装 JDK 17：https://adoptium.net/
2. 设置 JAVA_HOME 环境变量
3. 运行 `flutter doctor -v` 验证

### Q3: 手机无法安装 APK
**解决方案**：
1. 开启 "允许安装未知来源应用"
2. 检查手机存储空间是否充足
3. 确保 APK 文件完整（未损坏）

### Q4: 安装后闪退
**解决方案**：
1. 检查手机 Android 版本（需要 5.0 以上）
2. 清除应用缓存后重试
3. 重新安装 APK

---

## 📁 相关文件

- `INSTALL_ANDROID_SDK.md` - Android SDK 详细安装指南
- `build_apk.bat` - Windows 构建脚本
- `.github/workflows/build-apk.yml` - GitHub Actions 配置
- `TEST_REPORT.md` - 测试报告

---

## 🔧 开发环境

当前环境信息：
- **Flutter**: 3.44.1 ✅
- **Java**: JDK 17.0.9 ✅
- **Android SDK**: ❌ 未安装

---

## 📞 获取帮助

如果遇到问题：
1. 运行 `flutter doctor -v` 查看详细诊断
2. 参考 Flutter 官方文档：https://flutter.dev/docs
3. 搜索错误信息 + "Flutter"

---

## 🎉 构建成功后

您将获得：
- `app-release.apk` - 可安装的 APK 文件
- 文件大小：约 20-30 MB
- 支持设备：Android 5.0 及以上

安装后即可使用单词小达人 App 学习英语单词！
