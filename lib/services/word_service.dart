import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

/// 单词数据服务
class WordService {
  List<Word>? _allWords;
  Map<String, List<Word>>? _wordsByCategory;
  Map<int, List<Word>>? _wordsByGrade;
  bool _isLoaded = false;

  /// 加载词库数据
  Future<void> loadWords() async {
    if (_isLoaded) return;
    
    try {
      // 从assets加载词库JSON
      final jsonString = await rootBundle.loadString('data/vocabulary.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final wordsList = jsonData['words'] as List;
      _allWords = wordsList.map((w) => Word.fromJson(w as Map<String, dynamic>)).toList();
      
      // 按类别分组
      _wordsByCategory = {};
      for (final word in _allWords!) {
        if (!_wordsByCategory!.containsKey(word.category)) {
          _wordsByCategory![word.category] = [];
        }
        _wordsByCategory![word.category]!.add(word);
      }
      
      // 按年级分组
      _wordsByGrade = {};
      for (final word in _allWords!) {
        if (!_wordsByGrade!.containsKey(word.gradeLevel)) {
          _wordsByGrade![word.gradeLevel] = [];
        }
        _wordsByGrade![word.gradeLevel]!.add(word);
      }
      
      _isLoaded = true;
    } catch (e) {
      // 加载失败时使用内置数据
      _allWords = _getDefaultWords();

      // 初始化分类和年级映射
      _wordsByCategory = {};
      for (final word in _allWords!) {
        if (!_wordsByCategory!.containsKey(word.category)) {
          _wordsByCategory![word.category] = [];
        }
        _wordsByCategory![word.category]!.add(word);
      }

      _wordsByGrade = {};
      for (final word in _allWords!) {
        if (!_wordsByGrade!.containsKey(word.gradeLevel)) {
          _wordsByGrade![word.gradeLevel] = [];
        }
        _wordsByGrade![word.gradeLevel]!.add(word);
      }

      _isLoaded = true;
    }
  }

  /// 获取所有单词
  List<Word> getAllWords() {
    return _allWords ?? _getDefaultWords();
  }

  /// 获取某类别的单词
  List<Word> getWordsByCategory(String category) {
    return _wordsByCategory?[category] ?? [];
  }

  /// 获取某年级的单词
  List<Word> getWordsByGrade(int gradeLevel) {
    return _wordsByGrade?[gradeLevel] ?? [];
  }

  /// 获取某难度的单词
  List<Word> getWordsByDifficulty(int difficulty) {
    return _allWords?.where((w) => w.difficulty == difficulty).toList() ?? [];
  }

  /// 获取每日学习单词
  List<Word> getDailyWords(int count, {int? gradeLevel}) {
    List<Word> sourceWords;
    
    if (gradeLevel != null) {
      sourceWords = getWordsByGrade(gradeLevel);
    } else {
      sourceWords = getAllWords();
    }
    
    if (sourceWords.isEmpty) {
      sourceWords = _getDefaultWords();
    }
    
    // 随机选择单词
    final shuffled = List<Word>.from(sourceWords);
    shuffled.shuffle();
    return shuffled.take(count).toList();
  }

  /// 搜索单词
  List<Word> searchWords(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _allWords?.where((w) => 
        w.english.toLowerCase().contains(lowerQuery) ||
        w.chinese.contains(query)).toList() ?? [];
  }

  /// 获取单个单词
  Word? getWordById(String id) {
    try {
      return _allWords?.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取所有类别
  List<String> getAllCategories() {
    return _wordsByCategory?.keys.toList() ?? [];
  }

  /// 获取单词总数
  int getTotalCount() {
    return _allWords?.length ?? 0;
  }

  /// 默认单词（备用）
  List<Word> _getDefaultWords() {
    return [
      Word(
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
      ),
      Word(
        id: 'w002',
        english: 'banana',
        phonetic: '/bəˈnɑːnə/',
        chinese: '香蕉',
        emoji: '🍌',
        exampleEn: 'I like eating bananas.',
        exampleCn: '我喜欢吃香蕉。',
        difficulty: 1,
        category: 'fruit',
        gradeLevel: 1,
      ),
      Word(
        id: 'w003',
        english: 'cat',
        phonetic: '/kæt/',
        chinese: '猫',
        emoji: '🐱',
        exampleEn: 'The cat is sleeping.',
        exampleCn: '猫正在睡觉。',
        difficulty: 1,
        category: 'animal',
        gradeLevel: 1,
      ),
      Word(
        id: 'w004',
        english: 'dog',
        phonetic: '/dɒg/',
        chinese: '狗',
        emoji: '🐕',
        exampleEn: 'I have a cute dog.',
        exampleCn: '我有一只可爱的狗。',
        difficulty: 1,
        category: 'animal',
        gradeLevel: 1,
      ),
      Word(
        id: 'w005',
        english: 'book',
        phonetic: '/bʊk/',
        chinese: '书',
        emoji: '📚',
        exampleEn: 'I read books every day.',
        exampleCn: '我每天读书。',
        difficulty: 1,
        category: 'school',
        gradeLevel: 1,
      ),
      Word(
        id: 'w006',
        english: 'pen',
        phonetic: '/pen/',
        chinese: '钢笔',
        emoji: '🖊️',
        exampleEn: 'I write with a pen.',
        exampleCn: '我用钢笔写字。',
        difficulty: 1,
        category: 'school',
        gradeLevel: 1,
      ),
      Word(
        id: 'w007',
        english: 'red',
        phonetic: '/red/',
        chinese: '红色',
        emoji: '🔴',
        exampleEn: 'The apple is red.',
        exampleCn: '苹果是红色的。',
        difficulty: 1,
        category: 'color',
        gradeLevel: 1,
      ),
      Word(
        id: 'w008',
        english: 'blue',
        phonetic: '/bluː/',
        chinese: '蓝色',
        emoji: '🔵',
        exampleEn: 'The sky is blue.',
        exampleCn: '天空是蓝色的。',
        difficulty: 1,
        category: 'color',
        gradeLevel: 1,
      ),
      Word(
        id: 'w009',
        english: 'mom',
        phonetic: '/mɒm/',
        chinese: '妈妈',
        emoji: '👩',
        exampleEn: 'Mom loves me very much.',
        exampleCn: '妈妈非常爱我。',
        difficulty: 1,
        category: 'family',
        gradeLevel: 1,
      ),
      Word(
        id: 'w010',
        english: 'dad',
        phonetic: '/dæd/',
        chinese: '爸爸',
        emoji: '👨',
        exampleEn: 'Dad is tall and strong.',
        exampleCn: '爸爸又高又壮。',
        difficulty: 1,
        category: 'family',
        gradeLevel: 1,
      ),
    ];
  }
}
