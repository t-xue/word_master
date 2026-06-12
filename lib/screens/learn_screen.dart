import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../config/app_config.dart';
import '../widgets/lion_character.dart';
import '../providers/user_provider.dart';
import '../services/tts_service.dart';

/// 单词学习页
class LearnScreen extends ConsumerStatefulWidget {
  final String? category;

  const LearnScreen({super.key, this.category});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  late TtsService _ttsService;
  bool _isLoading = true;
  String _currentMessage = '加油，开始学习吧！';
  String _currentMood = 'happy';

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    _initLearning();
  }

  Future<void> _initLearning() async {
    // 获取单词列表
    final words = ref.read(currentWordsProvider);
    if (words.isEmpty) {
      final wordService = ref.read(wordServiceProvider);
      final userProgress = ref.read(userProgressProvider);
      final gradeLevel = userProgress?.age != null 
          ? _getGradeFromAge(userProgress!.age) 
          : 1;
      
      final newWords = wordService.getDailyWords(AppConfig.dailyWordTarget, gradeLevel: gradeLevel);
      ref.read(currentWordsProvider.notifier).state = newWords;
    }
    
    setState(() => _isLoading = false);
  }

  int _getGradeFromAge(int age) {
    if (age <= 7) return 1;
    if (age <= 8) return 2;
    if (age <= 9) return 3;
    if (age <= 10) return 4;
    if (age <= 11) return 5;
    return 6;
  }

  void _playSound(String text) {
    _ttsService.speak(text);
  }

  Future<void> _nextWord(bool known) async {
    final currentIndex = ref.read(currentWordIndexProvider);
    final words = ref.read(currentWordsProvider);
    
    if (words.isEmpty) return;
    
    final currentWord = words[currentIndex % words.length];
    
    // 更新进度
    await ref.read(userProgressProvider.notifier).updateLearningProgress(
      wordsLearnedDelta: known ? 1 : 0,
      experienceDelta: known ? AppConfig.expPerWord : 0,
      wordId: currentWord.id,
      isCorrect: known,
    );

    // 更新鼓励消息
    setState(() {
      if (known) {
        _currentMessage = '太棒了！继续保持~ 👏';
        _currentMood = 'proud';
      } else {
        _currentMessage = '没关系，多练习就会记住的~';
        _currentMood = 'thinking';
      }
    });

    // 检查是否完成学习
    if (currentIndex >= words.length - 1) {
      // 学习完成
      showDialog(
        context: context,
        builder: (context) => _CompletionDialog(
          wordsLearned: words.length,
          onConfirm: () {
            Navigator.pop(context);
            context.go('/home');
          },
        ),
      );
    } else {
      // 进入下一个单词
      ref.read(currentWordIndexProvider.notifier).state = currentIndex + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentWordIndexProvider);
    final words = ref.watch(currentWordsProvider);
    final userProgress = ref.watch(userProgressProvider);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (words.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LionCharacter(size: 100, mood: 'thinking'),
              const SizedBox(height: 20),
              Text('暂无学习内容', style: TextStyle(fontSize: 18, color: AppColors.text)),
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

    final currentWord = words[currentIndex % words.length];
    final progress = (currentIndex + 1) / words.length;

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              // 顶部进度条
              Padding(
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
                                colors: [AppColors.primary, AppColors.secondary],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${currentIndex + 1}/${words.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // 单词卡片
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.text.withOpacity(0.12),
                            blurRadius: 40,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 图片/Emoji
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                currentWord.emoji,
                                style: const TextStyle(fontSize: 70),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 15),
                          
                          // 单词
                          Text(
                            currentWord.english,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // 音标
                          Text(
                            currentWord.phonetic,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textLight,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // 中文
                          Text(
                            currentWord.chinese,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // 例句
                          Text(
                            currentWord.exampleEn,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentWord.exampleCn,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // 发音按钮
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _playSound(currentWord.english),
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [AppColors.secondary, AppColors.primaryLight],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('🔊', style: TextStyle(fontSize: 24)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => _playSound(currentWord.exampleEn),
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [AppColors.accent, AppColors.primary],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('🎤', style: TextStyle(fontSize: 24)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 小狮子鼓励
              Padding(
                padding: const EdgeInsets.all(15),
                child: LionSpeechBubble(
                  text: _currentMessage,
                  mood: _currentMood,
                ),
              ),

              // 底部按钮
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _nextWord(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardBg,
                          side: BorderSide(color: AppColors.border, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '不认识',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _nextWord(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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
}

class _CompletionDialog extends StatelessWidget {
  final int wordsLearned;
  final VoidCallback onConfirm;

  const _CompletionDialog({
    required this.wordsLearned,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LionCharacter(size: 80, mood: 'celebrating'),
            const SizedBox(height: 16),
            const Text(
              '🎉 学习完成！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '今天学习了 $wordsLearned 个单词',
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
