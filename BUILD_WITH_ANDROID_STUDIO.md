# 使用 Android Studio 构建 APK

由于 Flutter 3.44.1 的 Maven 依赖尚未同步，推荐使用 Android Studio 构建 APK。

## 步骤

### 1. 打开 Android Studio

启动 Android Studio 应用程序

### 2. 打开项目

1. 点击 **"Open"** 或 **"打开"**
2. 导航到项目目录：
   ```
   C:\Users\t_xue\Claude Code Project\0611-codx\word_master
   ```
3. 选择 **`android`** 文件夹（不是整个 word_master 文件夹）
4. 点击 **"OK"**

### 3. 等待同步

Android Studio 会自动同步 Gradle 和下载依赖，这可能需要几分钟时间

### 4. 构建 APK

1. 点击菜单栏 **"Build"**
2. 选择 **"Build Bundle(s) / APK(s)"**
3. 点击 **"Build APK(s)"**

### 5. 查找 APK

构建完成后，APK 文件位于：
```
word_master\android\app\build\outputs\apk\release\app-release.apk
```

或者点击 Android Studio 右下角的通知，点击 **"locate"** 直接打开文件所在位置

---

## 如果遇到问题

### 问题1：Gradle 同步失败

**解决方案**：
1. 打开 **File -> Settings -> Build, Execution, Deployment -> Build Tools -> Gradle**
2. 勾选 **"Offline work"**
3. 重新同步

### 问题2：SDK 版本不匹配

**解决方案**：
1. 打开 **Tools -> SDK Manager**
2. 安装所需的 SDK 版本
3. 重新同步

### 问题3：构建失败

**解决方案**：
1. 点击 **File -> Invalidate Caches / Restart**
2. 重启 Android Studio
3. 重新构建

---

## 替代方案：使用命令行

如果不想使用 Android Studio，可以尝试：

```bash
cd C:\Users\t_xue\Claude Code Project\0611-codx\word_master\android
set ANDROID_HOME=C:\android-sdk
gradlew.bat assembleRelease
```

---

## 构建成功后

1. 找到 APK 文件
2. 传输到手机（USB、微信、邮件等）
3. 在手机上安装
4. 开始使用单词小达人 App！
