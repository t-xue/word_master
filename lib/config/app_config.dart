import 'package:shared_preferences/shared_preferences.dart';

/// 全局配置 - TTS API地址和密钥可配置
class AppConfig {
  // TTS API配置 - 小米 mimo-v2.5-tts 模型
  static String ttsApiUrl = 'https://token-plan-cn.xiaomimimo.com/v1';
  static String ttsApiKey = '';
  static String ttsModel = 'mimo-v2.5-tts';

  // TTS配置参数
  static const String ttsVoice = 'en_us';  // 英语发音
  static const double ttsSpeed = 0.8;      // 语速（儿童友好）
  static const String ttsFormat = 'mp3';   // 音频格式

  // 应用配置
  static const String appName = '单词小达人';
  static const String appVersion = '1.0.0';

  // 学习配置
  static const int dailyWordTarget = 10;      // 每日学习目标
  static const int masteryThreshold = 3;      // 掌握阈值（连续正确次数）
  static const int expPerWord = 10;           // 每个单词获得经验值
  static const int expPerCorrect = 5;         // 每次正确答题获得经验值
  static const int streakBonusMultiplier = 2; // 连续学习奖励倍数

  // 存储键名
  static const String _keyApiUrl = 'tts_api_url';
  static const String _keyApiKey = 'tts_api_key';
  static const String _keyModel = 'tts_model';
  static const String userBoxKey = 'user_progress';
  static const String settingsBoxKey = 'settings';
  static const String wordProgressKey = 'word_progress';

  /// 初始化配置（从本地存储加载）
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    ttsApiUrl = prefs.getString(_keyApiUrl) ?? ttsApiUrl;
    ttsApiKey = prefs.getString(_keyApiKey) ?? ttsApiKey;
    ttsModel = prefs.getString(_keyModel) ?? ttsModel;
  }

  /// 保存 API 配置
  static Future<void> saveApiConfig({
    String? apiUrl,
    String? apiKey,
    String? model,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (apiUrl != null) {
      ttsApiUrl = apiUrl;
      await prefs.setString(_keyApiUrl, apiUrl);
    }

    if (apiKey != null) {
      ttsApiKey = apiKey;
      await prefs.setString(_keyApiKey, apiKey);
    }

    if (model != null) {
      ttsModel = model;
      await prefs.setString(_keyModel, model);
    }
  }

  /// 清除 API 配置
  static Future<void> clearApiConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyApiUrl);
    await prefs.remove(_keyApiKey);
    await prefs.remove(_keyModel);

    // 恢复默认值
    ttsApiUrl = 'https://token-plan-cn.xiaomimimo.com/v1';
    ttsApiKey = '';
    ttsModel = 'mimo-v2.5-tts';
  }

  /// 检查 API Key 是否已配置
  static bool isApiKeyConfigured() {
    return ttsApiKey.isNotEmpty;
  }

  /// 获取当前配置
  static Map<String, dynamic> getCurrentConfig() {
    return {
      'ttsApiUrl': ttsApiUrl,
      'ttsApiKey': ttsApiKey.isNotEmpty ? '***已配置***' : '未配置',
      'ttsModel': ttsModel,
      'ttsVoice': ttsVoice,
      'ttsSpeed': ttsSpeed,
      'appName': appName,
      'appVersion': appVersion,
    };
  }
}
