import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_config.dart';
import '../config/constants.dart';

/// 设置页面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    _apiUrlController.text = AppConfig.ttsApiUrl;
    _apiKeyController.text = AppConfig.ttsApiKey;
    _modelController.text = AppConfig.ttsModel;
  }

  Future<void> _saveConfig() async {
    setState(() => _isLoading = true);

    try {
      await AppConfig.saveApiConfig(
        apiUrl: _apiUrlController.text.trim(),
        apiKey: _apiKeyController.text.trim(),
        model: _modelController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('配置已保存'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testConnection() async {
    setState(() => _isLoading = true);

    try {
      // 先保存配置
      await _saveConfig();

      // 测试连接
      final url = _apiUrlController.text.trim();
      final key = _apiKeyController.text.trim();

      if (key.isEmpty) {
        _showResult('请先输入 API Key', false);
        return;
      }

      // 这里可以添加实际的连接测试逻辑
      _showResult('配置已保存，请在学习页面测试发音功能', true);
    } catch (e) {
      _showResult('测试失败: $e', false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showResult(String message, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? '✅ 成功' : '❌ 失败'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API 设置'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明卡片
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '配置说明',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '本应用使用 TTS (文字转语音) API 进行英语发音。\n'
                    '您需要配置 API 地址和密钥才能使用发音功能。',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // API 地址
            Text(
              'API 地址',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiUrlController,
              decoration: InputDecoration(
                hintText: 'https://api.example.com/v1',
                prefixIcon: Icon(Icons.link, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // API Key
            Text(
              'API Key',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                hintText: '请输入您的 API Key',
                prefixIcon: Icon(Icons.key, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () {
                    setState(() => _isObscured = !_isObscured);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 模型名称
            Text(
              '模型名称',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                hintText: 'mimo-v2.5-tts',
                prefixIcon: Icon(Icons.smart_toy, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveConfig,
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.save),
                    label: Text('保存配置'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _testConnection,
                    icon: Icon(Icons.wifi_tethering),
                    label: Text('测试连接'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 当前状态
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前配置状态',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(
                    'API 地址',
                    AppConfig.ttsApiUrl,
                    AppConfig.ttsApiUrl.isNotEmpty,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusRow(
                    'API Key',
                    AppConfig.isApiKeyConfigured() ? '已配置' : '未配置',
                    AppConfig.isApiKeyConfigured(),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusRow(
                    '模型',
                    AppConfig.ttsModel,
                    AppConfig.ttsModel.isNotEmpty,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 获取 API Key 的帮助
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('🔑', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        '如何获取 API Key？',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. 访问小米 mimo-v2.5-tts 官网\n'
                    '2. 注册并登录账号\n'
                    '3. 在控制台获取 API Key\n'
                    '4. 将 Key 粘贴到上方输入框',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.error_outline,
          size: 18,
          color: isValid ? AppColors.success : AppColors.textMuted,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textLight,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: isValid ? AppColors.text : AppColors.textMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
