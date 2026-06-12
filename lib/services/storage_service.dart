import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';
import '../models/user_progress.dart';

/// 本地存储服务
class StorageService {
  late Box _userBox;
  late Box _settingsBox;
  bool _initialized = false;

  /// 初始化存储
  Future<void> init() async {
    if (_initialized) return;
    
    _userBox = await Hive.openBox(AppConfig.userBoxKey);
    _settingsBox = await Hive.openBox(AppConfig.settingsBoxKey);
    _initialized = true;
  }

  /// 保存用户进度
  Future<void> saveUserProgress(UserProgress progress) async {
    await init();
    await _userBox.put('progress', progress.toJson());
  }

  /// 获取用户进度
  UserProgress? getUserProgress() {
    if (!_initialized) return null;
    
    final data = _userBox.get('progress');
    if (data == null) return null;
    return UserProgress.fromJson(Map<String, dynamic>.from(data));
  }

  /// 保存设置
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await init();
    await _settingsBox.putAll(settings);
  }

  /// 获取设置
  Map<String, dynamic> getSettings() {
    if (!_initialized) return {};
    return Map<String, dynamic>.from(_settingsBox.toMap());
  }

  /// 保存TTS配置
  Future<void> saveTtsConfig(String apiUrl, String apiKey) async {
    await init();
    await _settingsBox.put('ttsApiUrl', apiUrl);
    await _settingsBox.put('ttsApiKey', apiKey);
  }

  /// 获取TTS配置
  Map<String, String> getTtsConfig() {
    if (!_initialized) return {};
    return {
      'ttsApiUrl': _settingsBox.get('ttsApiUrl', defaultValue: ''),
      'ttsApiKey': _settingsBox.get('ttsApiKey', defaultValue: ''),
    };
  }

  /// 保存单词掌握进度
  Future<void> saveWordMastery(String wordId, int masteryLevel) async {
    final progress = getUserProgress();
    if (progress != null) {
      final updatedMastery = Map<String, int>.from(progress.wordMastery);
      updatedMastery[wordId] = masteryLevel;
      await saveUserProgress(progress.copyWith(wordMastery: updatedMastery));
    }
  }

  /// 获取单词掌握进度
  int getWordMastery(String wordId) {
    final progress = getUserProgress();
    if (progress == null) return 0;
    return progress.wordMastery[wordId] ?? 0;
  }

  /// 清除所有数据
  Future<void> clearAll() async {
    await init();
    await _userBox.clear();
    await _settingsBox.clear();
  }
}
