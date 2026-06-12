import 'package:flutter_test/flutter_test.dart';
import 'package:word_master/config/constants.dart';

void main() {
  group('LevelSystem Tests', () {
    test('LevelSystem should have 10 levels', () {
      expect(LevelSystem.levels.length, 10);
    });

    test('LevelSystem.getLevelName should return correct name for valid level', () {
      expect(LevelSystem.getLevelName(1), '单词新手');
      expect(LevelSystem.getLevelName(2), '单词学徒');
      expect(LevelSystem.getLevelName(3), '单词达人');
      expect(LevelSystem.getLevelName(10), '单词巨星');
    });

    test('LevelSystem.getLevelName should return default for invalid level', () {
      expect(LevelSystem.getLevelName(0), '单词新手');
      expect(LevelSystem.getLevelName(11), '单词新手');
      expect(LevelSystem.getLevelName(-1), '单词新手');
    });

    test('LevelSystem.getLevelEmoji should return correct emoji for valid level', () {
      expect(LevelSystem.getLevelEmoji(1), '🌱');
      expect(LevelSystem.getLevelEmoji(2), '📖');
      expect(LevelSystem.getLevelEmoji(10), '✨');
    });

    test('LevelSystem.getLevelEmoji should return default for invalid level', () {
      expect(LevelSystem.getLevelEmoji(0), '🌱');
      expect(LevelSystem.getLevelEmoji(11), '🌱');
    });

    test('LevelSystem.getExpRequired should return correct exp for valid level', () {
      expect(LevelSystem.getExpRequired(1), 0);
      expect(LevelSystem.getExpRequired(2), 100);
      expect(LevelSystem.getExpRequired(3), 200);
      expect(LevelSystem.getExpRequired(10), 2500);
    });

    test('LevelSystem.getExpRequired should return 0 for invalid level', () {
      expect(LevelSystem.getExpRequired(0), 0);
      expect(LevelSystem.getExpRequired(11), 0);
    });

    test('LevelSystem levels should have increasing exp requirements', () {
      for (int i = 1; i < LevelSystem.levels.length; i++) {
        final currentExp = LevelSystem.getExpRequired(i);
        final nextExp = LevelSystem.getExpRequired(i + 1);
        expect(nextExp, greaterThan(currentExp));
      }
    });
  });

  group('BadgeSystem Tests', () {
    test('BadgeSystem should have 12 badges', () {
      expect(BadgeSystem.badges.length, 12);
    });

    test('BadgeSystem should have streak badges', () {
      final streakBadges = BadgeSystem.badges
          .where((b) => (b['id'] as String).contains('streak'))
          .toList();

      expect(streakBadges.length, 4);
      expect(streakBadges.any((b) => b['id'] == 'streak_3'), true);
      expect(streakBadges.any((b) => b['id'] == 'streak_7'), true);
      expect(streakBadges.any((b) => b['id'] == 'streak_15'), true);
      expect(streakBadges.any((b) => b['id'] == 'streak_30'), true);
    });

    test('BadgeSystem should have word count badges', () {
      final wordBadges = BadgeSystem.badges
          .where((b) => (b['id'] as String).contains('words'))
          .toList();

      expect(wordBadges.length, 4);
      expect(wordBadges.any((b) => b['id'] == 'words_50'), true);
      expect(wordBadges.any((b) => b['id'] == 'words_100'), true);
      expect(wordBadges.any((b) => b['id'] == 'words_200'), true);
      expect(wordBadges.any((b) => b['id'] == 'words_500'), true);
    });

    test('BadgeSystem should have perfect streak badges', () {
      final perfectBadges = BadgeSystem.badges
          .where((b) => (b['id'] as String).contains('perfect'))
          .toList();

      expect(perfectBadges.length, 2);
      expect(perfectBadges.any((b) => b['id'] == 'perfect_10'), true);
      expect(perfectBadges.any((b) => b['id'] == 'perfect_20'), true);
    });

    test('BadgeSystem should have special badges', () {
      expect(BadgeSystem.badges.any((b) => b['id'] == 'speed_fast'), true);
      expect(BadgeSystem.badges.any((b) => b['id'] == 'first_learn'), true);
    });

    test('Each badge should have required fields', () {
      for (final badge in BadgeSystem.badges) {
        expect(badge.containsKey('id'), true);
        expect(badge.containsKey('name'), true);
        expect(badge.containsKey('emoji'), true);
        expect(badge.containsKey('description'), true);
        expect(badge.containsKey('requirement'), true);
      }
    });
  });

  group('LionExpressions Tests', () {
    test('LionExpressions should have 7 expressions', () {
      expect(LionExpressions.expressions.length, 7);
    });

    test('LionExpressions should have all required moods', () {
      expect(LionExpressions.expressions.containsKey('happy'), true);
      expect(LionExpressions.expressions.containsKey('excited'), true);
      expect(LionExpressions.expressions.containsKey('proud'), true);
      expect(LionExpressions.expressions.containsKey('thinking'), true);
      expect(LionExpressions.expressions.containsKey('celebrating'), true);
      expect(LionExpressions.expressions.containsKey('sad'), true);
      expect(LionExpressions.expressions.containsKey('sleepy'), true);
    });

    test('Each expression should have non-empty value', () {
      LionExpressions.expressions.forEach((key, value) {
        expect(value, isNotEmpty);
      });
    });
  });

  group('AppColors Tests', () {
    test('AppColors should have primary color', () {
      expect(AppColors.primary, isNotNull);
    });

    test('AppColors should have all required colors', () {
      expect(AppColors.primary, isNotNull);
      expect(AppColors.primaryLight, isNotNull);
      expect(AppColors.primaryDark, isNotNull);
      expect(AppColors.secondary, isNotNull);
      expect(AppColors.secondaryLight, isNotNull);
      expect(AppColors.accent, isNotNull);
      expect(AppColors.success, isNotNull);
      expect(AppColors.background, isNotNull);
      expect(AppColors.cardBg, isNotNull);
      expect(AppColors.text, isNotNull);
      expect(AppColors.textLight, isNotNull);
      expect(AppColors.textMuted, isNotNull);
      expect(AppColors.border, isNotNull);
    });
  });

  group('AppSizes Tests', () {
    test('AppSizes should have mobile sizes', () {
      expect(AppSizes.mobileCardWidth, 280.0);
      expect(AppSizes.mobileCardHeight, 150.0);
      expect(AppSizes.mobileLionSize, 90.0);
      expect(AppSizes.mobileFontSize, 16.0);
      expect(AppSizes.mobileButtonHeight, 50.0);
    });

    test('AppSizes should have tablet sizes', () {
      expect(AppSizes.tabletCardWidth, 400.0);
      expect(AppSizes.tabletCardHeight, 220.0);
      expect(AppSizes.tabletLionSize, 150.0);
      expect(AppSizes.tabletFontSize, 20.0);
      expect(AppSizes.tabletButtonHeight, 60.0);
    });

    test('AppSizes should have padding values', () {
      expect(AppSizes.paddingSmall, 8.0);
      expect(AppSizes.paddingMedium, 16.0);
      expect(AppSizes.paddingLarge, 24.0);
      expect(AppSizes.paddingXL, 32.0);
    });

    test('AppSizes should have radius values', () {
      expect(AppSizes.radiusSmall, 12.0);
      expect(AppSizes.radiusMedium, 16.0);
      expect(AppSizes.radiusLarge, 20.0);
      expect(AppSizes.radiusXL, 30.0);
    });

    test('Tablet sizes should be larger than mobile sizes', () {
      expect(AppSizes.tabletCardWidth, greaterThan(AppSizes.mobileCardWidth));
      expect(AppSizes.tabletCardHeight, greaterThan(AppSizes.mobileCardHeight));
      expect(AppSizes.tabletLionSize, greaterThan(AppSizes.mobileLionSize));
      expect(AppSizes.tabletFontSize, greaterThan(AppSizes.mobileFontSize));
    });
  });
}
