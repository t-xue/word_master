/// 用户进度模型
class UserProgress {
  final String userName;
  final int age;
  final String avatarEmoji;
  final int wordsLearned;
  final int wordsMastered;
  final int streakDays;
  final DateTime lastStudyDate;
  final int totalPoints;
  final int level;
  final int experience;
  final List<String> unlockedBadges;
  final Map<String, int> wordMastery;

  const UserProgress({
    this.userName = '',
    this.age = 0,
    this.avatarEmoji = '🦁',
    this.wordsLearned = 0,
    this.wordsMastered = 0,
    this.streakDays = 0,
    required this.lastStudyDate,
    this.totalPoints = 0,
    this.level = 1,
    this.experience = 0,
    this.unlockedBadges = const [],
    this.wordMastery = const {},
  });

  /// 创建新用户
  factory UserProgress.create(String name, int age) {
    return UserProgress(
      userName: name,
      age: age,
      avatarEmoji: '🦁',
      lastStudyDate: DateTime.now(),
      unlockedBadges: ['first_learn'],  // 首次登录徽章
    );
  }

  /// 从JSON创建
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userName: json['userName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      avatarEmoji: json['avatarEmoji'] as String? ?? '🦁',
      wordsLearned: json['wordsLearned'] as int? ?? 0,
      wordsMastered: json['wordsMastered'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      lastStudyDate: DateTime.parse(json['lastStudyDate'] as String? ?? DateTime.now().toIso8601String()),
      totalPoints: json['totalPoints'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      unlockedBadges: List<String>.from(json['unlockedBadges'] as List? ?? []),
      wordMastery: Map<String, int>.from(json['wordMastery'] as Map? ?? {}),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'age': age,
      'avatarEmoji': avatarEmoji,
      'wordsLearned': wordsLearned,
      'wordsMastered': wordsMastered,
      'streakDays': streakDays,
      'lastStudyDate': lastStudyDate.toIso8601String(),
      'totalPoints': totalPoints,
      'level': level,
      'experience': experience,
      'unlockedBadges': unlockedBadges,
      'wordMastery': wordMastery,
    };
  }

  /// 复制并更新
  UserProgress copyWith({
    String? userName,
    int? age,
    String? avatarEmoji,
    int? wordsLearned,
    int? wordsMastered,
    int? streakDays,
    DateTime? lastStudyDate,
    int? totalPoints,
    int? level,
    int? experience,
    List<String>? unlockedBadges,
    Map<String, int>? wordMastery,
  }) {
    return UserProgress(
      userName: userName ?? this.userName,
      age: age ?? this.age,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      wordsMastered: wordsMastered ?? this.wordsMastered,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      wordMastery: wordMastery ?? this.wordMastery,
    );
  }
}
