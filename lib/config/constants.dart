import 'package:flutter/material.dart';

// 颜色系统 - 温暖橙黄系
class AppColors {
  static const Color primary = Color(0xFFFF8C42);
  static const Color primaryLight = Color(0xFFFFB07C);
  static const Color primaryDark = Color(0xFFE67635);
  static const Color secondary = Color(0xFFFFD166);
  static const Color secondaryLight = Color(0xFFFFE299);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF7BC96F);
  static const Color background = Color(0xFFFFF8F0);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF4A3728);
  static const Color textLight = Color(0xFF8B7355);
  static const Color textMuted = Color(0xFFB8A088);
  static const Color border = Color(0xFFF0E6DA);
}

// 尺寸常量
class AppSizes {
  // 手机端尺寸
  static const double mobileCardWidth = 280.0;
  static const double mobileCardHeight = 150.0;
  static const double mobileLionSize = 90.0;
  static const double mobileFontSize = 16.0;
  static const double mobileButtonHeight = 50.0;
  
  // 平板端尺寸
  static const double tabletCardWidth = 400.0;
  static const double tabletCardHeight = 220.0;
  static const double tabletLionSize = 150.0;
  static const double tabletFontSize = 20.0;
  static const double tabletButtonHeight = 60.0;
  
  // 间距
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXL = 32.0;
  
  // 圆角
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXL = 30.0;
}

// 等级系统
class LevelSystem {
  static const List<Map<String, dynamic>> levels = [
    {'level': 1, 'name': '单词新手', 'expRequired': 0, 'emoji': '🌱'},
    {'level': 2, 'name': '单词学徒', 'expRequired': 100, 'emoji': '📖'},
    {'level': 3, 'name': '单词达人', 'expRequired': 200, 'emoji': '⭐'},
    {'level': 4, 'name': '单词高手', 'expRequired': 400, 'emoji': '🌟'},
    {'level': 5, 'name': '单词大师', 'expRequired': 600, 'emoji': '👑'},
    {'level': 6, 'name': '单词专家', 'expRequired': 900, 'emoji': '🏆'},
    {'level': 7, 'name': '单词精英', 'expRequired': 1200, 'emoji': '💎'},
    {'level': 8, 'name': '单词王者', 'expRequired': 1600, 'emoji': '🔥'},
    {'level': 9, 'name': '单词传奇', 'expRequired': 2000, 'emoji': '💫'},
    {'level': 10, 'name': '单词巨星', 'expRequired': 2500, 'emoji': '✨'},
  ];
  
  static String getLevelName(int level) {
    if (level < 1 || level > levels.length) return '单词新手';
    return levels[level - 1]['name'] as String;
  }
  
  static String getLevelEmoji(int level) {
    if (level < 1 || level > levels.length) return '🌱';
    return levels[level - 1]['emoji'] as String;
  }
  
  static int getExpRequired(int level) {
    if (level < 1 || level > levels.length) return 0;
    return levels[level - 1]['expRequired'] as int;
  }
}

// 徽章系统
class BadgeSystem {
  static const List<Map<String, dynamic>> badges = [
    {'id': 'streak_3', 'name': '坚持小能手', 'emoji': '🔥', 'description': '连续学习3天', 'requirement': 3},
    {'id': 'streak_7', 'name': '周周达人', 'emoji': '📅', 'description': '连续学习7天', 'requirement': 7},
    {'id': 'streak_15', 'name': '坚持大师', 'emoji': '💪', 'description': '连续学习15天', 'requirement': 15},
    {'id': 'streak_30', 'name': '月月之星', 'emoji': '🌟', 'description': '连续学习30天', 'requirement': 30},
    {'id': 'words_50', 'name': '词汇新手', 'emoji': '📚', 'description': '学习50个单词', 'requirement': 50},
    {'id': 'words_100', 'name': '词汇达人', 'emoji': '📖', 'description': '学习100个单词', 'requirement': 100},
    {'id': 'words_200', 'name': '词汇大师', 'emoji': '🎓', 'description': '学习200个单词', 'requirement': 200},
    {'id': 'words_500', 'name': '词汇专家', 'emoji': '👑', 'description': '学习500个单词', 'requirement': 500},
    {'id': 'perfect_10', 'name': '完美十连', 'emoji': '✨', 'description': '连续正确10题', 'requirement': 10},
    {'id': 'perfect_20', 'name': '完美二十连', 'emoji': '🏆', 'description': '连续正确20题', 'requirement': 20},
    {'id': 'speed_fast', 'name': '闪电手', 'emoji': '⚡', 'description': '10秒内答对5题', 'requirement': 5},
    {'id': 'first_learn', 'name': '初次启程', 'emoji': '🎉', 'description': '第一次学习', 'requirement': 1},
  ];
}

// 小狮子表情
class LionExpressions {
  static const Map<String, String> expressions = {
    'happy': '◠‿◠',
    'excited': '★‿★',
    'proud': '◕‿◕',
    'thinking': '•ᴗ•',
    'celebrating': '≧◡≦',
    'sad': '◕︵◕',
    'sleepy': '-‿-',
  };
}
