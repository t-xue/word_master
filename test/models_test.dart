import 'package:flutter_test/flutter_test.dart';
import 'package:word_master/models/word.dart';
import 'package:word_master/models/user_progress.dart';
import 'package:word_master/models/badge.dart';

void main() {
  group('Word Model Tests', () {
    test('Word.fromJson should create Word correctly', () {
      final json = {
        'id': 'w001',
        'english': 'apple',
        'phonetic': '/ˈæpəl/',
        'chinese': '苹果',
        'emoji': '🍎',
        'exampleEn': 'I eat an apple every day.',
        'exampleCn': '我每天吃一个苹果。',
        'difficulty': 1,
        'category': 'fruit',
        'gradeLevel': 1,
      };

      final word = Word.fromJson(json);

      expect(word.id, 'w001');
      expect(word.english, 'apple');
      expect(word.phonetic, '/ˈæpəl/');
      expect(word.chinese, '苹果');
      expect(word.emoji, '🍎');
      expect(word.exampleEn, 'I eat an apple every day.');
      expect(word.exampleCn, '我每天吃一个苹果。');
      expect(word.difficulty, 1);
      expect(word.category, 'fruit');
      expect(word.gradeLevel, 1);
    });

    test('Word.toJson should convert to JSON correctly', () {
      final word = Word(
        id: 'w001',
        english: 'apple',
        phonetic: '/ˈæpəl/',
        chinese: '苹果',
        emoji: '🍎',
        exampleEn: 'I eat an apple every day.',
        exampleCn: '我每天吃一个苹果。',
        difficulty: 1,
        category: 'fruit',
        gradeLevel: 1,
      );

      final json = word.toJson();

      expect(json['id'], 'w001');
      expect(json['english'], 'apple');
      expect(json['phonetic'], '/ˈæpəl/');
      expect(json['chinese'], '苹果');
      expect(json['emoji'], '🍎');
      expect(json['difficulty'], 1);
      expect(json['category'], 'fruit');
      expect(json['gradeLevel'], 1);
    });

    test('Word.fromJson should handle optional imageUrl', () {
      final json = {
        'id': 'w001',
        'english': 'apple',
        'phonetic': '/ˈæpəl/',
        'chinese': '苹果',
        'emoji': '🍎',
        'imageUrl': 'https://example.com/apple.png',
        'exampleEn': 'I eat an apple every day.',
        'exampleCn': '我每天吃一个苹果。',
        'difficulty': 1,
        'category': 'fruit',
        'gradeLevel': 1,
      };

      final word = Word.fromJson(json);

      expect(word.imageUrl, 'https://example.com/apple.png');
    });
  });

  group('UserProgress Model Tests', () {
    test('UserProgress.create should create new user correctly', () {
      final progress = UserProgress.create('小明', 8);

      expect(progress.userName, '小明');
      expect(progress.age, 8);
      expect(progress.avatarEmoji, '🦁');
      expect(progress.wordsLearned, 0);
      expect(progress.wordsMastered, 0);
      expect(progress.streakDays, 0);
      expect(progress.totalPoints, 0);
      expect(progress.level, 1);
      expect(progress.experience, 0);
      expect(progress.unlockedBadges, contains('first_learn'));
      expect(progress.wordMastery, isEmpty);
    });

    test('UserProgress.copyWith should update fields correctly', () {
      final progress = UserProgress.create('小明', 8);
      final updated = progress.copyWith(
        wordsLearned: 10,
        experience: 100,
        level: 2,
      );

      expect(updated.userName, '小明');
      expect(updated.age, 8);
      expect(updated.wordsLearned, 10);
      expect(updated.experience, 100);
      expect(updated.level, 2);
    });

    test('UserProgress.fromJson should create from JSON correctly', () {
      final json = {
        'userName': '小红',
        'age': 10,
        'avatarEmoji': '🐱',
        'wordsLearned': 50,
        'wordsMastered': 30,
        'streakDays': 5,
        'lastStudyDate': '2024-01-01T00:00:00.000',
        'totalPoints': 500,
        'level': 3,
        'experience': 200,
        'unlockedBadges': ['first_learn', 'streak_3'],
        'wordMastery': {'w001': 3, 'w002': 1},
      };

      final progress = UserProgress.fromJson(json);

      expect(progress.userName, '小红');
      expect(progress.age, 10);
      expect(progress.avatarEmoji, '🐱');
      expect(progress.wordsLearned, 50);
      expect(progress.wordsMastered, 30);
      expect(progress.streakDays, 5);
      expect(progress.totalPoints, 500);
      expect(progress.level, 3);
      expect(progress.experience, 200);
      expect(progress.unlockedBadges, contains('first_learn'));
      expect(progress.unlockedBadges, contains('streak_3'));
      expect(progress.wordMastery['w001'], 3);
      expect(progress.wordMastery['w002'], 1);
    });

    test('UserProgress.toJson should convert to JSON correctly', () {
      final progress = UserProgress(
        userName: '小明',
        age: 8,
        avatarEmoji: '🦁',
        wordsLearned: 10,
        wordsMastered: 5,
        streakDays: 3,
        lastStudyDate: DateTime(2024, 1, 1),
        totalPoints: 100,
        level: 2,
        experience: 50,
        unlockedBadges: ['first_learn'],
        wordMastery: {'w001': 2},
      );

      final json = progress.toJson();

      expect(json['userName'], '小明');
      expect(json['age'], 8);
      expect(json['avatarEmoji'], '🦁');
      expect(json['wordsLearned'], 10);
      expect(json['wordsMastered'], 5);
      expect(json['streakDays'], 3);
      expect(json['totalPoints'], 100);
      expect(json['level'], 2);
      expect(json['experience'], 50);
      expect(json['unlockedBadges'], contains('first_learn'));
      expect(json['wordMastery']['w001'], 2);
    });
  });

  group('Badge Model Tests', () {
    test('Badge should create correctly', () {
      final badge = Badge(
        id: 'streak_3',
        name: '坚持小能手',
        description: '连续学习3天',
        emoji: '🔥',
        requirement: 3,
      );

      expect(badge.id, 'streak_3');
      expect(badge.name, '坚持小能手');
      expect(badge.description, '连续学习3天');
      expect(badge.emoji, '🔥');
      expect(badge.requirement, 3);
      expect(badge.unlockedAt, isNull);
      expect(badge.isUnlocked, false);
    });

    test('Badge.isUnlocked should return true when unlockedAt is set', () {
      final badge = Badge(
        id: 'streak_3',
        name: '坚持小能手',
        description: '连续学习3天',
        emoji: '🔥',
        requirement: 3,
        unlockedAt: DateTime.now(),
      );

      expect(badge.isUnlocked, true);
    });

    test('Badge.unlock should create unlocked badge', () {
      final badge = Badge(
        id: 'streak_3',
        name: '坚持小能手',
        description: '连续学习3天',
        emoji: '🔥',
        requirement: 3,
      );

      final unlockedBadge = badge.unlock();

      expect(unlockedBadge.id, 'streak_3');
      expect(unlockedBadge.isUnlocked, true);
      expect(unlockedBadge.unlockedAt, isNotNull);
    });

    test('Badge.fromJson should create from JSON correctly', () {
      final json = {
        'id': 'streak_3',
        'name': '坚持小能手',
        'description': '连续学习3天',
        'emoji': '🔥',
        'requirement': 3,
        'unlockedAt': '2024-01-01T00:00:00.000',
      };

      final badge = Badge.fromJson(json);

      expect(badge.id, 'streak_3');
      expect(badge.name, '坚持小能手');
      expect(badge.isUnlocked, true);
    });

    test('Badge.toJson should convert to JSON correctly', () {
      final badge = Badge(
        id: 'streak_3',
        name: '坚持小能手',
        description: '连续学习3天',
        emoji: '🔥',
        requirement: 3,
        unlockedAt: DateTime(2024, 1, 1),
      );

      final json = badge.toJson();

      expect(json['id'], 'streak_3');
      expect(json['name'], '坚持小能手');
      expect(json['unlockedAt'], isNotNull);
    });
  });
}
