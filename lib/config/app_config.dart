/// 全局配置 - TTS API地址和密钥可配置
class AppConfig {
  // TTS API配置 - 小米 mimo-v2.5-tts 模型
  static String ttsApiUrl = const String.fromEnvironment(
    'TTS_API_URL',
    defaultValue: 'https://token-plan-cn.xiaomimimo.com/v1',
  );
  
  static String ttsApiKey = const String.fromEnvironment(
    'TTS_API_KEY',
    defaultValue: '', // 请在环境变量中设置您的 API Key
  );
  
  static String ttsModel = const String.fromEnvironment(
    'TTS_MODEL',
    defaultValue: 'mimo-v2.5-tts',
  );
  
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
  static const String userBoxKey = 'user_progress';
  static const String settingsBoxKey = 'settings';
  static const String wordProgressKey = 'word_progress';
  
  /// 从本地加载配置（用于运行时修改）
  static Future<void> loadFromStorage(Map<String, dynamic> config) async {
    if (config.containsKey('ttsApiUrl')) {
      ttsApiUrl = config['ttsApiUrl'] as String;
    }
    if (config.containsKey('ttsApiKey')) {
      ttsApiKey = config['ttsApiKey'] as String;
    }
  }
  
  /// 获取当前配置
  static Map<String, dynamic> getCurrentConfig() {
    return {
      'ttsApiUrl': ttsApiUrl,
      'ttsApiKey': ttsApiKey,
      'ttsModel': ttsModel,
      'ttsVoice': ttsVoice,
      'ttsSpeed': ttsSpeed,
      'appName': appName,
      'appVersion': appVersion,
    };
  }
}
