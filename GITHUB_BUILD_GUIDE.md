# 使用 GitHub Actions 自动构建 APK

由于 Flutter 3.44.1 的 Maven 依赖尚未同步，推荐使用 GitHub Actions 自动构建。

## 🚀 快速开始

### 步骤 1：创建 GitHub 账号

如果还没有 GitHub 账号，请访问 https://github.com/signup 注册

### 步骤 2：创建新仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `word-master` (或任意名称)
   - **Description**: 单词小达人 - 儿童英语学习App
   - **Public** 或 **Private** 都可以
3. 点击 **"Create repository"**

### 步骤 3：上传代码

在项目目录（`C:\Users\t_xue\Claude Code Project\0611-codx\word_master`）打开命令行，运行：

```bash
# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/word-master.git

# 推送代码
git push -u origin master
```

### 步骤 4：触发构建

1. 访问你的仓库页面：`https://github.com/YOUR_USERNAME/word-master`
2. 点击 **"Actions"** 标签
3. 如果看到提示，点击 **"I understand my workflows, go ahead and enable them"**
4. 构建会自动开始（或者点击 **"Build Android APK"** -> **"Run workflow"**）

### 步骤 5：下载 APK

1. 等待构建完成（通常 5-10 分钟，绿色 ✓ 表示成功）
2. 点击最新的构建记录
3. 在 **"Artifacts"** 部分，点击 **"word-master-apk"** 下载
4. 解压下载的文件，得到 `app-release.apk`

### 步骤 6：安装到手机

1. 将 `app-release.apk` 传输到手机（USB、微信、QQ 等）
2. 在手机上打开文件管理器
3. 找到并点击 APK 文件
4. 允许安装未知来源应用
5. 完成安装，开始使用！

---

## 📋 常见问题

### Q1: 推送代码时提示认证失败

**解决方案**：
1. 访问 https://github.com/settings/tokens
2. 点击 **"Generate new token"** -> **"Generate new token (classic)"**
3. 勾选 **"repo"** 权限
4. 生成 token 并复制
5. 推送时使用 token 作为密码

### Q2: Actions 页面没有看到构建

**解决方案**：
1. 确认代码已推送成功
2. 点击 **"Actions"** 标签
3. 点击 **"Build Android APK"** 工作流
4. 点击 **"Run workflow"** 手动触发

### Q3: 构建失败

**解决方案**：
1. 点击失败的构建记录查看错误日志
2. 常见原因：
   - 代码语法错误
   - 依赖版本冲突
3. 修复后重新推送代码

### Q4: 下载的 APK 无法安装

**解决方案**：
1. 确保手机 Android 版本 >= 5.0
2. 开启 **"允许安装未知来源应用"**
3. 检查手机存储空间是否充足

---

## 🔧 高级选项

### 修改 Flutter 版本

编辑 `.github/workflows/build-apk.yml`，修改：
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.5'  # 修改为需要的版本
    channel: 'stable'
```

### 自动发布

如需在每次推送时自动发布，可以添加 release 步骤到工作流文件。

---

## 📞 获取帮助

- GitHub Actions 文档：https://docs.github.com/en/actions
- Flutter 官方文档：https://flutter.dev
- 问题反馈：在仓库中创建 Issue

---

## ✅ 构建成功后

您将获得：
- `app-release.apk` - 可安装的 APK 文件
- 文件大小：约 20-30 MB
- 支持设备：Android 5.0 及以上

安装后即可使用单词小达人 App 学习英语单词！🎉
