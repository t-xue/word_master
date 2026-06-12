/// 徽章模型
class Badge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int requirement;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.requirement,
    this.unlockedAt,
  });

  /// 是否已解锁
  bool get isUnlocked => unlockedAt != null;

  /// 从JSON创建
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      requirement: json['requirement'] as int,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt'] as String) 
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'requirement': requirement,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// 复制并解锁
  Badge unlock() {
    return Badge(
      id: id,
      name: name,
      description: description,
      emoji: emoji,
      requirement: requirement,
      unlockedAt: DateTime.now(),
    );
  }
}
