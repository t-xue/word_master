import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../config/app_config.dart';
import '../widgets/lion_character.dart';
import '../providers/user_provider.dart';
import '../models/word.dart';
import '../services/tts_service.dart';

/// 练习页
class PracticeScreen extends ConsumerStatefulWidget {
  final String? mode;

  const PracticeScreen({super.key, this.mode});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  // 通用状态
  int _currentIndex = 0;
  int _score = 0;
  int _correctStreak = 0;
  List<Word> _practiceWords = [];
  bool _isLoading = true;

  // 多选模式状态
  String? _selectedAnswer;
  bool _hasAnswered = false;
  List<String> _options = [];
  int _correctIndex = 0;

  // 闪卡模式状态
  bool _isFlipped = false;
  late TtsService _ttsService;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    _initPractice();
  }

  Future<void> _initPractice() async {
    // 获取单词列表
    final words = ref.read(currentWordsProvider);
    if (words.isNotEmpty) {
      _practiceWords = words;
    } else {
      final wordService = ref.read(wordServiceProvider);
      final userProgress = ref.read(userProgressProvider);
      final gradeLevel = userProgress?.age != null
          ? _getGradeFromAge(userProgress!.age)
          : 1;
      _practiceWords = wordService.getDailyWords(AppConfig.dailyWordTarget, gradeLevel: gradeLevel);
    }

    setState(() => _isLoading = false);

    // 如果是多选模式，生成选项
    if (_isMultipleChoiceMode) {
      _generateOptions();
    }
  }

  bool get _isMultipleChoiceMode =>
      widget.mode == null || widget.mode == 'choice' || widget.mode == 'multiple';

  int _getGradeFromAge(int age) {
    if (age <= 7) return 1;
    if (age <= 8) return 2;
    if (age <= 9) return 3;
    if (age <= 10) return 4;
    if (age <= 11) return 5;
    return 6;
  }

  // ============ 多选模式方法 ============

  void _generateOptions() {
    if (_practiceWords.isEmpty) return;

    final currentWord = _practiceWords[_currentIndex % _practiceWords.length];
    final wordService = ref.read(wordServiceProvider);
    final allWords = wordService.getAllWords();

    // 生成选项（正确答案 + 3个随机错误答案）
    _correctIndex = 0; // 正确答案固定为第一个选项
    _options = [currentWord.chinese];

    // 获取其他单词作为错误选项
    final otherWords = allWords.where((w) => w.id != currentWord.id).toList();
    otherWords.shuffle();

    for (int i = 0; i < 3 && i < otherWords.length; i++) {
      _options.add(otherWords[i].chinese);
    }

    // 打乱选项顺序
    final correctAnswer = _options[0];
    _options.shuffle();
    _correctIndex = _options.indexOf(correctAnswer);
  }

  void _selectAnswer(int index) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswer = _options[index];
      _hasAnswered = true;

      if (index == _correctIndex) {
        _score += 10;
        _correctStreak++;
        ref.read(practiceScoreProvider.notifier).state += 10;
        ref.read(correctStreakProvider.notifier).state++;

        // 更新用户进度
        final currentWord = _practiceWords[_currentIndex % _practiceWords.length];
        ref.read(userProgressProvider.notifier).updateLearningProgress(
          experienceDelta: AppConfig.expPerCorrect,
          wordId: currentWord.id,
          isCorrect: true,
        );
      } else {
        _correctStreak = 0;
        ref.read(correctStreakProvider.notifier).state = 0;

        final currentWord = _practiceWords[_currentIndex % _practiceWords.length];
        ref.read(userProgressProvider.notifier).updateLearningProgress(
          wordId: currentWord.id,
          isCorrect: false,
        );
      }
    });
  }

  // ============ 闪卡模式方法 ============

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _playSound(String text) {
    // 播放发音（支持本地TTS和远程API）
    _ttsService.speak(text).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发音失败，请重试'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    });
  }

  void _handleFlashcardAnswer(bool known) {
    final currentWord = _practiceWords[_currentIndex % _practiceWords.length];

    // 更新用户进度
    ref.read(userProgressProvider.notifier).updateLearningProgress(
      wordsLearnedDelta: known ? 1 : 0,
      experienceDelta: known ? AppConfig.expPerWord : 0,
      wordId: currentWord.id,
      isCorrect: known,
    );

    if (known) {
      _score += 10;
      _correctStreak++;
    } else {
      _correctStreak = 0;
    }

    _nextQuestion();
  }

  // ============ 通用方法 ============

  void _nextQuestion() {
    if (_currentIndex >= _practiceWords.length - 1) {
      // 练习完成
      showDialog(
        context: context,
        builder: (context) => _CompletionDialog(
          score: _score,
          total: _practiceWords.length,
          mode: _isMultipleChoiceMode ? 'choice' : 'flashcard',
          onConfirm: () {
            Navigator.pop(context);
            context.go('/home');
          },
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
        _isFlipped = false;
      });

      if (_isMultipleChoiceMode) {
        _generateOptions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_practiceWords.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LionCharacter(size: 100, mood: 'thinking'),
              const SizedBox(height: 20),
              Text('暂无练习内容', style: TextStyle(fontSize: 18, color: AppColors.text)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      );
    }

    return _isMultipleChoiceMode
        ? _buildMultipleChoiceMode()
        : _buildFlashcardMode();
  }

  // ============ 多选模式UI ============

  Widget _buildMultipleChoiceMode() {
    final currentWord = _practiceWords[_currentIndex % _practiceWords.length];
    final progress = (_currentIndex + 1) / _practiceWords.length;
    final isCorrect = _selectedAnswer == _options[_correctIndex];

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              // 顶部进度条
              _buildTopBar(progress, '选择题'),

              // 题目卡片
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.text.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '选择题',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '这是什么意思？',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentWord.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      Text(
                        currentWord.english,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 选项
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(4, (index) {
                    if (index >= _options.length) return const SizedBox.shrink();

                    final letters = ['A', 'B', 'C', 'D'];
                    final isSelected = _selectedAnswer == _options[index];
                    final isCorrectAnswer = index == _correctIndex;

                    Color bgColor = AppColors.cardBg;
                    Color borderColor = AppColors.border;

                    if (_hasAnswered) {
                      if (isCorrectAnswer) {
                        bgColor = AppColors.success.withOpacity(0.15);
                        borderColor = AppColors.success;
                      } else if (isSelected && !isCorrectAnswer) {
                        bgColor = AppColors.accent.withOpacity(0.15);
                        borderColor = AppColors.accent;
                      }
                    } else if (isSelected) {
                      bgColor = AppColors.primary.withOpacity(0.1);
                      borderColor = AppColors.primary;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: _hasAnswered && isCorrectAnswer
                                      ? AppColors.success
                                      : AppColors.border,
                                ),
                                child: Center(
                                  child: Text(
                                    _hasAnswered && isCorrectAnswer
                                        ? '✓'
                                        : letters[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _hasAnswered && isCorrectAnswer
                                          ? Colors.white
                                          : AppColors.text,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _options[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // 下一步按钮
              if (_hasAnswered)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      '下一题',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              const Spacer(),

              // 小狮子鼓励
              Padding(
                padding: const EdgeInsets.all(12),
                child: LionSpeechBubble(
                  text: _hasAnswered
                      ? (isCorrect ? '答对啦！太棒了~ 🎉' : '没关系，正确答案是：${_options[_correctIndex]}')
                      : '选择正确的答案吧~',
                  mood: _hasAnswered
                      ? (isCorrect ? 'celebrating' : 'thinking')
                      : 'happy',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ 闪卡模式UI ============

  Widget _buildFlashcardMode() {
    final currentWord = _practiceWords[_currentIndex % _practiceWords.length];
    final progress = (_currentIndex + 1) / _practiceWords.length;

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              // 顶部进度条
              _buildTopBar(progress, '闪卡练习'),

              // 闪卡区域
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      width: 300,
                      height: 380,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: _isFlipped
                                ? AppColors.primary.withOpacity(0.3)
                                : AppColors.text.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: _isFlipped
                            ? Border.all(color: AppColors.primary, width: 3)
                            : null,
                      ),
                      child: _isFlipped
                          ? _buildFlashcardBack(currentWord)
                          : _buildFlashcardFront(currentWord),
                    ),
                  ),
                ),
              ),

              // 提示文字
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _isFlipped ? '点击卡片翻回正面' : '点击卡片查看释义',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ),

              // 小狮子鼓励
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LionSpeechBubble(
                  text: _isFlipped ? '记住这个单词了吗？' : '先想想这个单词的意思~',
                  mood: _isFlipped ? 'thinking' : 'happy',
                ),
              ),

              // 底部按钮
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleFlashcardAnswer(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardBg,
                          side: BorderSide(color: AppColors.border, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '不认识 😕',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleFlashcardAnswer(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          '认识 ✓',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardFront(Word word) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                word.emoji,
                style: const TextStyle(fontSize: 65),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 英文单词
          Text(
            word.english,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 10),

          // 音标
          Text(
            word.phonetic,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),

          const SizedBox(height: 25),

          // 发音按钮
          GestureDetector(
            onTap: () => _playSound(word.english),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryLight, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🗣️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '点击发音',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 翻转提示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  '点击查看释义',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardBack(Word word) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 中文释义
          Text(
            word.chinese,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 15),

          // 英文单词
          Text(
            word.english,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 20),

          // 分割线
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // 例句
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  word.exampleEn,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  word.exampleCn,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 播放例句按钮
          GestureDetector(
            onTap: () => _playSound(word.exampleEn),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent.withOpacity(0.1), AppColors.accent.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('📖', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '播放例句',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ 公共组件 ============

  Widget _buildTopBar(double progress, String modeLabel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardBg,
              ),
              child: const Center(
                child: Text('←', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: progress,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.success, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '${_currentIndex + 1}/${_practiceWords.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 完成对话框
class _CompletionDialog extends StatelessWidget {
  final int score;
  final int total;
  final String mode;
  final VoidCallback onConfirm;

  const _CompletionDialog({
    required this.score,
    required this.total,
    required this.mode,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = total > 0 ? (score / (total * 10) * 100).round() : 0;
    final isFlashcard = mode == 'flashcard';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LionCharacter(size: 80, mood: accuracy >= 80 ? 'celebrating' : 'proud'),
            const SizedBox(height: 16),
            Text(
              isFlashcard ? '🎉 闪卡练习完成！' : '🎯 选择题练习完成！',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            if (isFlashcard)
              Text(
                '今天练习了 $total 个单词',
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              )
            else
              Text(
                '得分：$score 分  正确率：$accuracy%',
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '返回首页',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
