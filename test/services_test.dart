import 'package:flutter_test/flutter_test.dart';
import 'package:word_master/services/word_service.dart';
import 'package:word_master/config/app_config.dart';

void main() {
  group('WordService Tests', () {
    late WordService wordService;

    setUp(() {
      wordService = WordService();
      // 注意：在测试环境中无法加载资产文件，所以使用默认单词
      // loadWords() 会失败，但 getAllWords() 会返回默认单词
    });

    test('getAllWords should return default words when not loaded', () {
      final words = wordService.getAllWords();

      expect(words, isNotEmpty);
      expect(words.length, 10); // 默认10个单词
      expect(words.first.english, 'apple');
    });

    test('getWordsByCategory should return empty when not loaded', () {
      // 在未加载状态下，_wordsByCategory 为 null，返回空列表
      final fruitWords = wordService.getWordsByCategory('fruit');

      expect(fruitWords, isEmpty);
    });

    test('getWordsByCategory should return empty list for invalid category', () {
      final words = wordService.getWordsByCategory('invalid_category');

      expect(words, isEmpty);
    });

    test('getWordsByGrade should return empty when not loaded', () {
      // 在未加载状态下，_wordsByGrade 为 null，返回空列表
      final grade1Words = wordService.getWordsByGrade(1);

      expect(grade1Words, isEmpty);
    });

    test('getDailyWords should return requested number of words', () {
      final words = wordService.getDailyWords(5);

      expect(words.length, 5);
    });

    test('getDailyWords should return all words if count exceeds available', () {
      final words = wordService.getDailyWords(100);

      expect(words.length, 10); // 只有10个默认单词
    });

    test('getDailyWords should return words for any grade level when not loaded', () {
      // 当未加载时，getWordsByGrade 返回空，但 getDailyWords 会使用默认单词
      final words = wordService.getDailyWords(5, gradeLevel: 1);

      expect(words.length, 5);
    });

    test('searchWords should return empty when not loaded', () {
      // 在未加载状态下，_allWords 为 null，返回空列表
      final results = wordService.searchWords('apple');

      expect(results, isEmpty);
    });

    test('searchWords should return empty for no match', () {
      final results = wordService.searchWords('xyz123');

      expect(results, isEmpty);
    });

    test('searchWords should return empty for empty query', () {
      final results = wordService.searchWords('');

      expect(results, isEmpty);
    });

    test('getWordById should return null when not loaded', () {
      // 在未加载状态下，_allWords 为 null，返回 null
      final word = wordService.getWordById('w001');

      expect(word, isNull);
    });

    test('getWordById should return null for invalid id', () {
      final word = wordService.getWordById('invalid_id');

      expect(word, isNull);
    });

    test('getAllCategories should return empty when not loaded', () {
      // 在未加载状态下，_wordsByCategory 为 null，返回空列表
      final categories = wordService.getAllCategories();

      expect(categories, isEmpty);
    });

    test('getTotalCount should return 0 when not loaded', () {
      // 在未加载状态下，_allWords 为 null，返回 0
      final count = wordService.getTotalCount();

      expect(count, 0);
    });
  });

  group('AppConfig Tests', () {
    test('AppConfig should have correct default values', () {
      expect(AppConfig.dailyWordTarget, 10);
      expect(AppConfig.masteryThreshold, 3);
      expect(AppConfig.expPerWord, 10);
      expect(AppConfig.expPerCorrect, 5);
      expect(AppConfig.streakBonusMultiplier, 2);
    });

    test('AppConfig should have TTS configuration', () {
      expect(AppConfig.ttsVoice, 'en_us');
      expect(AppConfig.ttsSpeed, 0.8);
      expect(AppConfig.ttsFormat, 'mp3');
    });

    test('AppConfig should have storage keys', () {
      expect(AppConfig.userBoxKey, 'user_progress');
      expect(AppConfig.settingsBoxKey, 'settings');
      expect(AppConfig.wordProgressKey, 'word_progress');
    });
  });
}
