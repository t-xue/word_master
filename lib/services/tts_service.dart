import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../config/app_config.dart';
import '../models/word.dart';

/// TTS发音服务 - 支持远程API和本地TTS
class TtsService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  bool _useLocalTts = false;

  TtsService() {
    _initLocalTts();
  }

  /// 初始化本地TTS
  Future<void> _initLocalTts() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5); // 适中语速，适合儿童
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      // 监听播放完成事件
      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
      });
    } catch (e) {
      print('本地TTS初始化失败: $e');
    }
  }

  /// 发音文本
  Future<void> speak(String text, {double speed = AppConfig.ttsSpeed}) async {
    if (_isPlaying) {
      await stop();
    }

    // 如果标记使用本地TTS，直接使用
    if (_useLocalTts) {
      await _speakLocal(text);
      return;
    }

    // 检查API Key是否配置
    if (!AppConfig.isApiKeyConfigured()) {
      // API Key未配置，使用本地TTS
      await _speakLocal(text);
      return;
    }

    // 尝试调用远程API
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.ttsApiUrl}/tts'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.ttsApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': AppConfig.ttsModel,
          'input': text,
          'voice': AppConfig.ttsVoice,
          'speed': speed,
          'response_format': AppConfig.ttsFormat,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('url')) {
          _isPlaying = true;
          await _audioPlayer.play(UrlSource(data['url']));
        } else if (data.containsKey('audio')) {
          _isPlaying = true;
          final audioBytes = base64Decode(data['audio']);
          await _audioPlayer.play(BytesSource(audioBytes));
        } else if (response.headers['content-type']?.contains('audio') == true) {
          _isPlaying = true;
          await _audioPlayer.play(BytesSource(response.bodyBytes));
        } else {
          // API返回格式不对，使用本地TTS
          await _speakLocal(text);
        }
      } else {
        // API调用失败，使用本地TTS
        print('TTS API错误: ${response.statusCode}');
        await _speakLocal(text);
      }
    } catch (e) {
      // 网络错误，使用本地TTS
      print('TTS服务异常，切换到本地TTS: $e');
      _useLocalTts = true; // 标记使用本地TTS，避免后续请求失败
      await _speakLocal(text);
    }
  }

  /// 使用本地TTS发音
  Future<void> _speakLocal(String text) async {
    try {
      _isPlaying = true;
      await _flutterTts.speak(text);
    } catch (e) {
      print('本地TTS发音失败: $e');
      _isPlaying = false;
    }
  }

  /// 停止播放
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();
    } catch (e) {
      print('停止播放失败: $e');
    }
    _isPlaying = false;
  }

  /// 发音单词（含发音和例句）
  Future<void> speakWord(Word word) async {
    await speak(word.english);
    await Future.delayed(const Duration(milliseconds: 800));
    await speak(word.exampleEn);
  }

  /// 检查API是否可用
  Future<bool> checkApiAvailable() async {
    if (!AppConfig.isApiKeyConfigured()) return false;

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.ttsApiUrl}/models'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.ttsApiKey}',
        },
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 是否使用本地TTS
  bool get isUsingLocalTts => _useLocalTts || !AppConfig.isApiKeyConfigured();

  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
  }
}
