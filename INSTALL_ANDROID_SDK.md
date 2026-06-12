# Android SDK 安装指南

## 方法1：安装 Android Studio（最简单）

### 步骤1：下载 Android Studio
访问：https://developer.android.com/studio
下载最新版本的 Android Studio

### 步骤2：安装 Android Studio
1. 运行下载的安装程序
2. 按照向导完成安装
3. 首次启动时，选择 "Standard" 安装类型
4. 等待 Android SDK 组件下载完成

### 步骤3：配置环境变量
安装完成后，Android SDK 通常位于：
```
C:\Users\你的用户名\AppData\Local\Android\Sdk
```

设置环境变量：
1. 打开 "系统属性" -> "高级" -> "环境变量"
2. 添加新的系统变量：
   - 变量名：`ANDROID_HOME`
   - 变量值：`C:\Users\你的用户名\AppData\Local\Android\Sdk`
3. 编辑 Path 变量，添加：
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\tools`

### 步骤4：验证安装
打开新的命令行窗口，运行：
```bash
flutter doctor
```

应该看到：
```
[✓] Android toolchain - develop for Android devices
```

---

## 方法2：仅安装 Android SDK（不安装 Android Studio）

### 步骤1：下载 Android SDK 命令行工具
访问：https://developer.android.com/studio#command-line-tools-only
下载 "Command line tools only"

### 步骤2：解压到目录
创建目录结构：
```
C:\Android\Sdk\cmdline-tools\latest\
```

将下载的文件解压到 `latest` 目录

### 步骤3：安装必要的 SDK 组件
打开命令行，运行：
```bash
cd C:\Android\Sdk\cmdline-tools\latest\bin
sdkmanager --install "platform-tools"
sdkmanager --install "platforms;android-33"
sdkmanager --install "build-tools;33.0.0"
```

### 步骤4：接受许可协议
```bash
sdkmanager --licenses
```
输入 `y` 接受所有许可

### 步骤5：设置环境变量
1. 添加系统变量：
   - `ANDROID_HOME` = `C:\Android\Sdk`
2. 编辑 Path 变量，添加：
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\cmdline-tools\latest\bin`

### 步骤6：告诉 Flutter SDK 位置
```bash
flutter config --android-sdk C:\Android\Sdk
```

---

## 验证安装

运行以下命令验证：
```bash
flutter doctor -v
```

应该看到类似输出：
```
[✓] Android toolchain - develop for Android devices
    • Android SDK at C:\Users\你的用户名\AppData\Local\Android\Sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: C:\Program Files\Java\jdk-17\bin\java
    • Java version Java(TM) SE Runtime Environment (build 17.0.9)
```

---

## 构建 APK

安装完成后，在项目目录运行：
```bash
flutter build apk --release
```

APK 文件将生成在：
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 常见问题

### 问题1：找不到 Java
确保安装了 JDK 17 或更高版本，并设置了 JAVA_HOME 环境变量

### 问题2：许可协议未接受
运行：`flutter doctor --android-licenses`
然后输入 `y` 接受所有许可

### 问题3：SDK 版本不匹配
运行：`flutter doctor -v` 查看需要的 SDK 版本
然后使用 sdkmanager 安装对应版本

---

## 快速检查清单

- [ ] Android SDK 已安装
- [ ] ANDROID_HOME 环境变量已设置
- [ ] JAVA_HOME 环境变量已设置
- [ ] Path 中包含 platform-tools
- [ ] `flutter doctor` 显示 [✓] Android toolchain
- [ ] 许可协议已接受

完成以上步骤后，就可以构建 APK 了！
