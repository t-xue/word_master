import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../config/app_config.dart';
import '../models/word.dart';

/// TTS发音服务 - 使用小米 mimo-v2.5-tts 模型
class TtsService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  /// 发音文本
  Future<void> speak(String text, {double speed = AppConfig.ttsSpeed}) async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    }

    try {
      // 调用小米TTS API
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
      );

      if (response.statusCode == 200) {
        // 处理返回的音频数据
        final data = jsonDecode(response.body);
        
        if (data.containsKey('url')) {
          // 从URL播放
          _isPlaying = true;
          await _audioPlayer.play(UrlSource(data['url']));
        } else if (data.containsKey('audio')) {
          // 如果返回base64编码的音频数据
          _isPlaying = true;
          final audioBytes = base64Decode(data['audio']);
          await _audioPlayer.play(BytesSource(audioBytes));
        } else if (response.headers['content-type']?.contains('audio') == true) {
          // 直接返回音频数据
          _isPlaying = true;
          await _audioPlayer.play(BytesSource(response.bodyBytes));
        }
      } else {
        print('TTS API错误: ${response.statusCode} - ${response.reasonPhrase}');
        await _playFallback(text);
      }
    } catch (e) {
      print('TTS服务异常: $e');
      await _playFallback(text);
    }
  }

  /// 备用发音方案
  Future<void> _playFallback(String text) async {
    print('备用TTS: $text');
  }

  /// 停止播放
  Future<void> stop() async {
    await _audioPlayer.stop();
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
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.ttsApiUrl}/models'),
        headers: {
          'Authorization': 'Bearer ${AppConfig.ttsApiKey}',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
