/// 单词数据模型
class Word {
  final String id;
  final String english;
  final String phonetic;
  final String chinese;
  final String emoji;
  final String? imageUrl;
  final String exampleEn;
  final String exampleCn;
  final int difficulty;
  final String category;
  final int gradeLevel;

  const Word({
    required this.id,
    required this.english,
    required this.phonetic,
    required this.chinese,
    required this.emoji,
    this.imageUrl,
    required this.exampleEn,
    required this.exampleCn,
    required this.difficulty,
    required this.category,
    required this.gradeLevel,
  });

  /// 从JSON创建
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String,
      english: json['english'] as String,
      phonetic: json['phonetic'] as String,
      chinese: json['chinese'] as String,
      emoji: json['emoji'] as String,
      imageUrl: json['imageUrl'] as String?,
      exampleEn: json['exampleEn'] as String,
      exampleCn: json['exampleCn'] as String,
      difficulty: json['difficulty'] as int,
      category: json['category'] as String,
      gradeLevel: json['gradeLevel'] as int,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'phonetic': phonetic,
      'chinese': chinese,
      'emoji': emoji,
      'imageUrl': imageUrl,
      'exampleEn': exampleEn,
      'exampleCn': exampleCn,
      'difficulty': difficulty,
      'category': category,
      'gradeLevel': gradeLevel,
    };
  }
}

/// 单词类别
class WordCategory {
  final String id;
  final String name;
  final String nameEn;

  const WordCategory({
    required this.id,
    required this.name,
    required this.nameEn,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
    );
  }
}
