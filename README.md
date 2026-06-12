# 单词小达人 - 儿童英语学习App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android-lightgrey)

**一款专为儿童设计的英语单词学习应用** 🎓

[功能特性](#-核心功能) • [快速开始](#-快速开始) • [项目结构](#-项目结构) • [贡献指南](#-贡献)

</div>

---

## 📱 应用简介

**单词小达人**是一款专为6-12岁儿童设计的英语单词学习应用，采用可爱卡通风格，让学习变得有趣！

### ✨ 核心功能

- 📚 **单词学习** - 闪卡式学习，支持发音和例句
- 🎯 **练习模式** - 选择题和闪卡两种模式
- 📖 **词库浏览** - 27个分类，527个单词
- 🏆 **成就系统** - 12个徽章，10个等级
- 🔊 **语音发音** - 真人发音，帮助记忆
- 📊 **学习统计** - 跟踪学习进度和连续天数

### 🎨 特色设计

- 🦁 可爱狮子吉祥物陪伴学习
- 🎮 游戏化激励系统
- 📱 响应式设计，支持手机和平板
- 🌙 护眼暖色调主题

---

## 🚀 快速开始

### 安装 APK（推荐）

1. 下载 `app-release.apk` 文件
2. 在手机上打开文件
3. 允许安装未知来源应用
4. 完成安装，开始学习！

### 从源码构建

详见 `BUILD_APK_README.md`

---

## 📂 项目结构

```
word_master/
├── lib/                    # 源代码
│   ├── main.dart          # 入口文件
│   ├── app.dart           # 应用配置和路由
│   ├── config/            # 配置文件
│   ├── models/            # 数据模型
│   ├── providers/         # 状态管理
│   ├── services/          # 服务层
│   ├── screens/           # 页面
│   └── widgets/           # 组件
├── data/                  # 数据文件
│   └── vocabulary.json    # 词库数据（527个单词）
├── test/                  # 测试文件
├── android/               # Android 配置
├── ios/                   # iOS 配置
└── pubspec.yaml           # 依赖配置
```

---

## 🛠️ 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart
- **状态管理**: Riverpod
- **路由**: GoRouter
- **本地存储**: Hive
- **网络**: HTTP
- **音频**: Audioplayers

---

## 📊 词库信息

- **单词总数**: 527个
- **分类数量**: 27个
- **难度等级**: 1-5级
- **年级适配**: 1-6年级

### 分类列表

🍎 水果 | 🐱 动物 | 👨‍👩‍👧 家庭 | 📚 学校 | 🍚 食物 | 👃 身体 | 🎨 颜色 | 🔢 数字 | 🏃 动作 | ☀️ 天气 | 👗 衣服 | 🚗 交通 | 🌿 自然 | ⚽ 运动 | 👨‍⚕️ 职业 | ⏰ 时间 | 🏠 地点 | 📝 形容词 | ✨ 动词 | 🧴 日用品 | 😊 情感 | 🧭 方位 | 👤 代词 | ❓ 疑问词 | 🌸 季节 | 📅 月份 | 📆 星期

---

## 🏆 成就系统

### 徽章类型

**连续学习徽章**
- 🔥 坚持小能手 - 连续3天
- 📅 周周达人 - 连续7天
- 💪 坚持大师 - 连续15天
- 🌟 月月之星 - 连续30天

**单词数量徽章**
- 📚 词汇新手 - 学习50个
- 📖 词汇达人 - 学习100个
- 🎓 词汇大师 - 学习200个
- 👑 词汇专家 - 学习500个

**完美答题徽章**
- ✨ 完美十连 - 连续答对10题
- 🏆 完美二十连 - 连续答对20题

**特殊徽章**
- ⚡ 闪电手 - 10秒内答对5题
- 🎉 初次启程 - 第一次学习

### 等级系统

| 等级 | 名称 | 所需经验 |
|------|------|----------|
| 1 | 单词新手 🌱 | 0 |
| 2 | 单词学徒 📖 | 100 |
| 3 | 单词达人 ⭐ | 200 |
| 4 | 单词高手 🌟 | 400 |
| 5 | 单词大师 👑 | 600 |
| 6 | 单词专家 🏆 | 900 |
| 7 | 单词精英 💎 | 1200 |
| 8 | 单词王者 🔥 | 1600 |
| 9 | 单词传奇 💫 | 2000 |
| 10 | 单词巨星 ✨ | 2500 |

---

## 🧪 测试

运行测试：
```bash
flutter test
```

测试覆盖：
- ✅ 数据模型测试 (12个)
- ✅ 服务层测试 (17个)
- ✅ 配置测试 (24个)

详见 `TEST_REPORT.md`

---

## 📝 开发说明

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Java JDK 17+
- Android SDK (构建APK需要)

### 运行项目

```bash
# 获取依赖
flutter pub get

# 运行调试版本
flutter run

# 构建发布版本
flutter build apk --release
```

### 代码规范

- 使用 Flutter 官方代码规范
- 启用 flutter_lints 静态分析
- 遵循 Riverpod 状态管理模式

---

## 📚 相关文档

- [CHANGELOG.md](CHANGELOG.md) - 更新日志
- [CONTRIBUTING.md](CONTRIBUTING.md) - 贡献指南
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) - 行为准则
- [BUILD_APK_README.md](BUILD_APK_README.md) - APK 构建指南
- [INSTALL_ANDROID_SDK.md](INSTALL_ANDROID_SDK.md) - Android SDK 安装指南
- [TEST_REPORT.md](TEST_REPORT.md) - 测试报告

---

## 🤝 贡献

欢迎贡献代码！请阅读 [贡献指南](CONTRIBUTING.md) 了解详情。

### 贡献方式

- 🐛 报告 Bug
- 💡 提出新功能建议
- 📝 改进文档
- 🔧 提交代码修复
- 🌟 添加新功能

### 快速贡献

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'feat: Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- Flutter 团队提供的优秀框架
- 所有开源库的贡献者
- 小米 mimo-v2.5-tts 提供的语音服务

---

## 📞 联系方式

如有问题或建议，请通过 GitHub Issues 反馈。

---

**祝学习愉快！** 🎉
