import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import '../models/word.dart';
import '../services/storage_service.dart';
import '../services/word_service.dart';
import '../config/constants.dart';
import '../config/app_config.dart';

/// 存储服务Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// 单词服务Provider
final wordServiceProvider = Provider<WordService>((ref) {
  return WordService();
});

/// 用户进度Provider
final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgress?>((ref) {
  return UserProgressNotifier(ref.watch(storageServiceProvider));
});

class UserProgressNotifier extends StateNotifier<UserProgress?> {
  final StorageService _storageService;

  UserProgressNotifier(this._storageService) : super(null) {
    _loadProgress();
  }

  /// 加载用户进度
  Future<void> _loadProgress() async {
    state = _storageService.getUserProgress();
  }

  /// 创建新用户
  Future<void> createUser(String name, int age) async {
    final progress = UserProgress.create(name, age);
    await _storageService.saveUserProgress(progress);
    state = progress;
  }

  /// 更新学习进度
  Future<void> updateLearningProgress({
    int? wordsLearnedDelta,
    int? experienceDelta,
    String? wordId,
    bool? isCorrect,
  }) async {
    if (state == null) return;

    final now = DateTime.now();
    final lastStudy = state!.lastStudyDate;
    
    // 计算连续天数
    int streakDays = state!.streakDays;
    final daysSinceLastStudy = now.difference(lastStudy).inDays;
    
    if (daysSinceLastStudy == 1) {
      streakDays++;
    } else if (daysSinceLastStudy > 1) {
      streakDays = 1;
    } else if (daysSinceLastStudy == 0) {
      // 同一天学习，保持不变
    }

    // 更新单词掌握度
    Map<String, int> wordMastery = Map.from(state!.wordMastery);
    if (wordId != null && isCorrect != null) {
      final currentMastery = wordMastery[wordId] ?? 0;
      if (isCorrect) {
        wordMastery[wordId] = currentMastery + 1;
      } else {
        wordMastery[wordId] = 0;
      }
    }

    // 计算掌握的单词数量（连续正确3次以上）
    int wordsMastered = wordMastery.values.where((v) => v >= AppConfig.masteryThreshold).length;

    // 计算新等级
    final newExp = state!.experience + (experienceDelta ?? 0);
    int newLevel = state!.level;
    for (int i = LevelSystem.levels.length - 1; i >= 0; i--) {
      if (newExp >= LevelSystem.getExpRequired(i + 1)) {
        newLevel = i + 1;
        break;
      }
    }

    // 检查新徽章
    List<String> newBadges = List.from(state!.unlockedBadges);
    _checkBadges(
      streakDays, 
      state!.wordsLearned + (wordsLearnedDelta ?? 0),
      wordsMastered,
      newBadges
    );

    final updated = state!.copyWith(
      wordsLearned: state!.wordsLearned + (wordsLearnedDelta ?? 0),
      wordsMastered: wordsMastered,
      experience: newExp,
      level: newLevel,
      streakDays: streakDays,
      lastStudyDate: now,
      totalPoints: state!.totalPoints + (experienceDelta ?? 0),
      wordMastery: wordMastery,
      unlockedBadges: newBadges,
    );

    await _storageService.saveUserProgress(updated);
    state = updated;
  }

  /// 检查并解锁徽章
  void _checkBadges(int streakDays, int wordsLearned, int wordsMastered, List<String> badges) {
    // 连续学习徽章
    if (streakDays >= 3 && !badges.contains('streak_3')) badges.add('streak_3');
    if (streakDays >= 7 && !badges.contains('streak_7')) badges.add('streak_7');
    if (streakDays >= 15 && !badges.contains('streak_15')) badges.add('streak_15');
    if (streakDays >= 30 && !badges.contains('streak_30')) badges.add('streak_30');
    
    // 单词学习徽章
    if (wordsLearned >= 50 && !badges.contains('words_50')) badges.add('words_50');
    if (wordsLearned >= 100 && !badges.contains('words_100')) badges.add('words_100');
    if (wordsLearned >= 200 && !badges.contains('words_200')) badges.add('words_200');
    if (wordsLearned >= 500 && !badges.contains('words_500')) badges.add('words_500');
    
    // 掌握徽章
    if (wordsMastered >= 10 && !badges.contains('master_10')) badges.add('master_10');
  }

  /// 更新用户信息
  Future<void> updateUserInfo({String? name, String? avatar}) async {
    if (state == null) return;
    
    final updated = state!.copyWith(
      userName: name ?? state!.userName,
      avatarEmoji: avatar ?? state!.avatarEmoji,
    );
    
    await _storageService.saveUserProgress(updated);
    state = updated;
  }

  /// 清除用户数据
  Future<void> clearUserData() async {
    await _storageService.clearAll();
    state = null;
  }
  
  /// 是否有用户
  bool hasUser() {
    return state != null && state!.userName.isNotEmpty;
  }
}

/// 当前学习单词列表Provider
final currentWordsProvider = StateProvider<List<Word>>((ref) {
  return [];
});

/// 当前学习单词索引Provider
final currentWordIndexProvider = StateProvider<int>((ref) => 0);

/// 练习模式Provider
final practiceModeProvider = StateProvider<String>((ref) => 'flashcard');

/// 练习得分Provider
final practiceScoreProvider = StateProvider<int>((ref) => 0);

/// 连续正确次数Provider
final correctStreakProvider = StateProvider<int>((ref) => 0);
