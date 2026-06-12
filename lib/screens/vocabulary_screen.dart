import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/lion_character.dart';
import '../providers/user_provider.dart';
import '../models/word.dart';

/// 词库页面
class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  String _searchQuery = '';
  List<Word> _searchResults = [];
  bool _isSearching = false;

  /// 分类配置
  static const List<Map<String, dynamic>> _categories = [
    {'id': 'fruit', 'name': '水果', 'emoji': '🍎'},
    {'id': 'animal', 'name': '动物', 'emoji': '🐱'},
    {'id': 'family', 'name': '家庭', 'emoji': '👨‍👩‍👧'},
    {'id': 'school', 'name': '学校', 'emoji': '📚'},
    {'id': 'food', 'name': '食物', 'emoji': '🍚'},
    {'id': 'body', 'name': '身体', 'emoji': '👃'},
    {'id': 'color', 'name': '颜色', 'emoji': '🎨'},
    {'id': 'number', 'name': '数字', 'emoji': '🔢'},
    {'id': 'action', 'name': '动作', 'emoji': '🏃'},
    {'id': 'weather', 'name': '天气', 'emoji': '☀️'},
    {'id': 'clothes', 'name': '衣服', 'emoji': '👗'},
    {'id': 'transport', 'name': '交通', 'emoji': '🚗'},
    {'id': 'nature', 'name': '自然', 'emoji': '🌿'},
    {'id': 'sport', 'name': '运动', 'emoji': '⚽'},
    {'id': 'job', 'name': '职业', 'emoji': '👨‍⚕️'},
    {'id': 'time', 'name': '时间', 'emoji': '⏰'},
    {'id': 'place', 'name': '地点', 'emoji': '🏠'},
    {'id': 'adjective', 'name': '形容词', 'emoji': '📝'},
    {'id': 'verb', 'name': '常用动词', 'emoji': '✨'},
    {'id': 'daily', 'name': '日用品', 'emoji': '🧴'},
    {'id': 'emotion', 'name': '情感', 'emoji': '😊'},
    {'id': 'direction', 'name': '方位', 'emoji': '🧭'},
    {'id': 'pronoun', 'name': '代词', 'emoji': '👤'},
    {'id': 'question', 'name': '疑问词', 'emoji': '❓'},
    {'id': 'season', 'name': '季节', 'emoji': '🌸'},
    {'id': 'month', 'name': '月份', 'emoji': '📅'},
    {'id': 'day', 'name': '星期', 'emoji': '📆'},
  ];

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _isSearching = false;
        _searchResults = [];
      } else {
        _isSearching = true;
        final wordService = ref.read(wordServiceProvider);
        _searchResults = wordService.searchWords(query);
      }
    });
  }

  void _navigateToCategory(String categoryId, String categoryName) {
    context.push('/vocabulary/$categoryId');
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = ref.watch(userProgressProvider);
    final wordService = ref.read(wordServiceProvider);
    final totalWords = wordService.getTotalCount();

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // 顶部标题区
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '📖 词库',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        // 搜索按钮
                        GestureDetector(
                          onTap: () {
                            showSearch(
                              context: context,
                              delegate: _WordSearchDelegate(wordService, userProgress),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.search, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // 统计信息
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            value: totalWords.toString(),
                            label: '总单词',
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _StatItem(
                            value: (userProgress?.wordsLearned ?? 0).toString(),
                            label: '已学习',
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _StatItem(
                            value: _categories.length.toString(),
                            label: '分类',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 分类列表
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildCategoryList(wordService),
            ),

            // 底部导航
            const BottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(dynamic wordService) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final categoryId = category['id'] as String;
        final categoryName = category['name'] as String;
        final categoryEmoji = category['emoji'] as String;
        final wordsInCategory = wordService.getWordsByCategory(categoryId);
        final wordCount = wordsInCategory.length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => _navigateToCategory(categoryId, categoryName),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 分类图标
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        categoryEmoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // 分类信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$wordCount 个单词',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 箭头
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LionCharacter(size: 80, mood: 'thinking'),
            const SizedBox(height: 16),
            Text(
              '没有找到相关单词',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final word = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.text.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Emoji
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      word.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // 单词信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.english,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        word.chinese,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                // 音标
                Text(
                  word.phonetic,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// 搜索代理
class _WordSearchDelegate extends SearchDelegate<Word?> {
  final dynamic wordService;
  final dynamic userProgress;

  _WordSearchDelegate(this.wordService, this.userProgress);

  @override
  String get searchFieldHint => '搜索单词...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              '输入英文或中文搜索单词',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = wordService.searchWords(query);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('😿', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              '没有找到"$query"相关单词',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final word = results[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Emoji
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        word.emoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // 单词信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.english,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          word.chinese,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 音标
                  Text(
                    word.phonetic,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
