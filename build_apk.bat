@echo off
echo ========================================
echo   单词小达人 APK 构建脚本
echo ========================================
echo.

echo [1/4] 检查 Flutter 环境...
flutter --version
if errorlevel 1 (
    echo 错误：Flutter 未安装或未配置
    pause
    exit /b 1
)

echo.
echo [2/4] 检查 Android SDK...
flutter doctor --android-licenses >nul 2>&1
if errorlevel 1 (
    echo 警告：Android SDK 可能未正确配置
    echo 请先运行：flutter doctor
    pause
)

echo.
echo [3/4] 获取依赖...
flutter pub get
if errorlevel 1 (
    echo 错误：获取依赖失败
    pause
    exit /b 1
)

echo.
echo [4/4] 构建 APK...
flutter build apk --release
if errorlevel 1 (
    echo 错误：构建失败
    echo.
    echo 可能的原因：
    echo 1. Android SDK 未安装
    echo 2. Java JDK 未安装
    echo 3. 环境变量未配置
    echo.
    echo 请参考 INSTALL_ANDROID_SDK.md 安装必要的工具
    pause
    exit /b 1
)

echo.
echo ========================================
echo   构建成功！
echo ========================================
echo.
echo APK 文件位置：
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo 您可以将此文件传输到手机上安装使用
echo.
pause
