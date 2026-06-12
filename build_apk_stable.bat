@echo off
echo ========================================
echo   单词小达人 APK 构建脚本 (稳定版)
echo ========================================
echo.

echo [1/5] 切换到 Flutter 稳定版本...
flutter channel stable
flutter upgrade

echo.
echo [2/5] 清理旧的构建文件...
flutter clean

echo.
echo [3/5] 获取依赖...
flutter pub get

echo.
echo [4/5] 构建 APK (使用稳定版本)...
flutter build apk --release --no-tree-shake-icons

if errorlevel 1 (
    echo.
    echo 构建失败！
    echo.
    echo 尝试使用 GitHub Actions 构建：
    echo 1. 将代码上传到 GitHub
    echo 2. 推送代码会自动触发构建
    echo 3. 在 Actions 页面下载 APK
    echo.
    echo 或者使用 Android Studio 构建：
    echo 1. 打开 Android Studio
    echo 2. 打开项目 android 目录
    echo 3. 点击 Build -> Build Bundle(s) / APK(s) -> Build APK(s)
    pause
    exit /b 1
)

echo.
echo [5/5] 构建完成！
echo.
echo APK 文件位置：
echo build\app\outputs\flutter-apk\app-release.apk
echo.
pause
