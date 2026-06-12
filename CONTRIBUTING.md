# 贡献指南

感谢您对单词小达人项目的关注！我们欢迎各种形式的贡献。

## 🤝 如何贡献

### 报告问题

如果您发现了 bug 或有功能建议，请：

1. 在 [Issues](../../issues) 页面创建新 issue
2. 使用清晰的标题描述问题
3. 提供详细的信息：
   - 问题描述
   - 复现步骤
   - 预期行为
   - 实际行为
   - 设备信息（手机型号、Android 版本等）
   - 截图（如果适用）

### 提交代码

1. **Fork 项目**
   - 点击页面右上角的 "Fork" 按钮

2. **克隆您的 Fork**
   ```bash
   git clone https://github.com/您的用户名/word-master.git
   cd word-master
   ```

3. **创建新分支**
   ```bash
   git checkout -b feature/您的功能名称
   ```

4. **进行修改**
   - 编写代码
   - 确保代码符合项目规范
   - 添加必要的测试

5. **运行测试**
   ```bash
   flutter test
   ```

6. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加某某功能"
   ```

7. **推送到 GitHub**
   ```bash
   git push origin feature/您的功能名称
   ```

8. **创建 Pull Request**
   - 访问您的 Fork 页面
   - 点击 "Compare & pull request"
   - 填写 PR 描述
   - 等待审核

## 📝 代码规范

### Dart 代码规范

- 遵循 [Flutter 官方代码规范](https://dart.dev/guides/language/effective-dart)
- 使用 `flutter_lints` 进行代码检查
- 运行 `flutter analyze` 确保没有警告

### 提交信息规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）：**
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具相关

**示例：**
```
feat(practice): 添加听力练习模式

- 新增听力练习页面
- 支持播放单词发音
- 用户选择正确的拼写

Closes #123
```

## 🎯 开发环境

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio 或 VS Code
- Android SDK（构建 Android 应用）

### 设置开发环境

1. **安装 Flutter**
   ```bash
   # 查看 Flutter 安装指南
   https://flutter.dev/docs/get-started/install
   ```

2. **克隆项目**
   ```bash
   git clone https://github.com/您的用户名/word-master.git
   cd word-master
   ```

3. **安装依赖**
   ```bash
   flutter pub get
   ```

4. **运行项目**
   ```bash
   flutter run
   ```

## 🧪 测试

### 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/models_test.dart

# 运行带覆盖率的测试
flutter test --coverage
```

### 编写测试

- 在 `test/` 目录下创建测试文件
- 使用 `flutter_test` 包
- 测试文件命名：`*_test.dart`

**示例测试：**
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('测试描述', () {
    expect(1 + 1, 2);
  });
}
```

## 📚 文档

### 更新文档

如果您的更改涉及：
- 新功能：更新 README.md
- API 变更：更新代码注释
- 配置变更：更新相关文档

### 文档规范

- 使用中文编写文档
- 保持文档简洁清晰
- 提供代码示例
- 添加必要的截图

## 🏷️ 版本发布

### 版本号规范

使用 [语义化版本](https://semver.org/)：

```
主版本号.次版本号.修订号
```

- **主版本号**：不兼容的 API 变更
- **次版本号**：向下兼容的功能性新增
- **修订号**：向下兼容的问题修正

### 发布流程

1. 更新 `pubspec.yaml` 中的版本号
2. 更新 `CHANGELOG.md`
3. 创建 Git tag
4. 在 GitHub 创建 Release

## ❓ 获取帮助

如有问题，请通过以下方式获取帮助：

- 在 [Issues](../../issues) 页面提问
- 查看 [Flutter 官方文档](https://flutter.dev/docs)
- 搜索相关问题

## 📜 行为准则

请遵守 [行为准则](CODE_OF_CONDUCT.md)，共同营造友好的社区环境。

## 🙏 致谢

感谢所有贡献者的付出！

---

再次感谢您的贡献！🎉
