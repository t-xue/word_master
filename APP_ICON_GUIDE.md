# App 图标设计指南

## 🎨 图标设计说明

### 设计理念

- **主角**：可爱的狮子吉祥物（乐乐）
- **元素**：书本、ABC字母、星星、音符
- **色调**：温暖橙黄系（与 App 主题一致）
- **风格**：卡通动漫风，适合儿童

### 颜色规范

| 元素 | 颜色 | 色值 |
|------|------|------|
| 背景渐变 | 橙色 → 黄色 | #FF8C42 → #FFD166 |
| 狮子毛发 | 浅橙色 | #FFB07C |
| 狮子脸部 | 白色 | #FFFFFF |
| 鼻子 | 橙色 | #FF8C42 |
| 书本 | 黄色渐变 | #FFD166 → #FFB07C |
| 装饰星星 | 黄色 | #FFD166 |
| 对勾 | 绿色 | #7BC96F |
| 音符 | 红色 | #FF6B6B |

---

## 📱 图标尺寸要求

### Android

| 密度 | 尺寸 | 文件名 |
|------|------|--------|
| mdpi | 48×48 | ic_launcher.png |
| hdpi | 72×72 | ic_launcher.png |
| xhdpi | 96×96 | ic_launcher.png |
| xxhdpi | 144×144 | ic_launcher.png |
| xxxhdpi | 192×192 | ic_launcher.png |

### iOS

| 用途 | 尺寸 |
|------|------|
| App Store | 1024×1024 |
| iPhone | 60×60, 120×120, 180×180 |
| iPad | 76×76, 152×152, 167×167 |
| Settings | 29×29, 58×58, 87×87 |
| Spotlight | 40×40, 80×80, 120×120 |

---

## 🔧 生成图标的方法

### 方法1：使用在线工具（推荐）

1. 访问 https://www.appicon.co/
2. 上传 `app_icon_design.svg` 或转换后的 PNG（1024×1024）
3. 自动生成所有尺寸的图标
4. 下载并替换项目中的图标文件

### 方法2：使用 Flutter 插件

```bash
# 安装 flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons

# 配置 pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#FF8C42"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"

# 生成图标
flutter pub run flutter_launcher_icons
```

### 方法3：手动替换

#### Android 图标位置
```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png
```

#### iOS 图标位置
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Icon-App-1024x1024@1x.png
├── Icon-App-20x20@1x.png
├── Icon-App-20x20@2x.png
├── Icon-App-20x20@3x.png
├── ... (其他尺寸)
└── Contents.json
```

---

## 🎯 SVG 转 PNG

### 使用命令行（需要安装 Inkscape）

```bash
inkscape app_icon_design.svg --export-filename=app_icon.png --export-width=1024 --export-height=1024
```

### 使用在线转换

1. 访问 https://convertio.co/svg-png/
2. 上传 SVG 文件
3. 设置输出尺寸为 1024×1024
4. 下载 PNG 文件

---

## 📋 图标设计预览

图标包含以下元素：

1. **圆形橙黄渐变背景** - 体现温暖活泼的氛围
2. **可爱的狮子头部** - 项目吉祥物，大眼睛，微笑表情
3. **打开的书本** - 代表学习功能
4. **ABC 字母** - 代表英语学习
5. **星星装饰** - 代表成就和奖励
6. **音符装饰** - 代表发音功能
7. **绿色对勾** - 代表学习成功

---

## 💡 设计建议

- 保持简洁，避免过多细节
- 确保在小尺寸下仍能清晰辨认
- 使用鲜艳的颜色吸引儿童注意
- 保持与 App 整体风格一致

---

## 📁 相关文件

- `assets/images/app_icon_design.svg` - 图标设计源文件
- `android/app/src/main/res/` - Android 图标目录
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` - iOS 图标目录
