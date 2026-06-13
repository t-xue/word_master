import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../config/app_config.dart';
import '../widgets/lion_character.dart';
import '../widgets/bottom_nav.dart';
import '../providers/user_provider.dart';

/// 首页
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _remainingWords = 10;

  @override
  void initState() {
    super.initState();
    _loadDailyWords();
    _checkApiKey();
  }

  void _checkApiKey() {
    // 延迟检查，避免在 build 过程中显示对话框
    Future.microtask(() {
      if (!AppConfig.isApiKeyConfigured()) {
        _showApiKeyTip();
      }
    });
  }

  void _showApiKeyTip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text('🔑', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text('配置 API Key'),
          ],
        ),
        content: Text(
          '检测到您还未配置 TTS API Key，发音功能将无法使用。\n\n'
          '是否现在配置？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('稍后'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/settings');
            },
            child: Text('去配置'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadDailyWords() async {
    final userProgress = ref.read(userProgressProvider);
    final wordService = ref.read(wordServiceProvider);
    
    // 根据用户年龄/年级加载单词
    final gradeLevel = userProgress?.age != null ? _getGradeFromAge(userProgress!.age) : 1;
    final words = wordService.getDailyWords(AppConfig.dailyWordTarget, gradeLevel: gradeLevel);
    
    ref.read(currentWordsProvider.notifier).state = words;
    
    // 计算剩余未学单词数量
    final learnedCount = userProgress?.wordsLearned ?? 0;
    setState(() {
      _remainingWords = AppConfig.dailyWordTarget - (learnedCount % AppConfig.dailyWordTarget);
    });
  }

  int _getGradeFromAge(int age) {
    if (age <= 7) return 1;
    if (age <= 8) return 2;
    if (age <= 9) return 3;
    if (age <= 10) return 4;
    if (age <= 11) return 5;
    return 6;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '早上好 ☀️';
    if (hour < 18) return '下午好 ☀️';
    return '晚上好 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = ref.watch(userProgressProvider);
    final isTablet = ResponsiveHelper.isTablet(context);

    // 如果没有用户，跳转到登录页
    if (userProgress == null || userProgress.userName.isEmpty) {
      Future.microtask(() => context.go('/'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.secondaryLight.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部问候区
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              userProgress.userName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // API 状态指示器
                            GestureDetector(
                              onTap: () => context.push('/settings'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConfig.isApiKeyConfigured()
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppConfig.isApiKeyConfigured()
                                        ? AppColors.success
                                        : AppColors.accent,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      AppConfig.isApiKeyConfigured()
                                          ? Icons.check_circle
                                          : Icons.warning,
                                      size: 14,
                                      color: AppConfig.isApiKeyConfigured()
                                          ? AppColors.success
                                          : AppColors.accent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppConfig.isApiKeyConfigured()
                                          ? 'API 已配置'
                                          : 'API 未配置',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppConfig.isApiKeyConfigured()
                                            ? AppColors.success
                                            : AppColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            userProgress.avatarEmoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 小狮子对话区
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.text.withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _getMotivationalMessage(userProgress.streakDays),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    LionCharacter(
                      size: isTablet ? AppSizes.tabletLionSize : AppSizes.mobileLionSize,
                      mood: userProgress.streakDays > 7 ? 'proud' : 'happy',
                    ),
                  ],
                ),
              ),

              // 统计数据
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatItem(
                      value: userProgress.wordsLearned.toString(),
                      label: '已学单词',
                    ),
                    const SizedBox(width: 25),
                    _StatItem(
                      value: userProgress.streakDays.toString(),
                      label: '连续天数',
                    ),
                    const SizedBox(width: 25),
                    _StatItem(
                      value: 'Lv.${userProgress.level}',
                      label: '当前等级',
                    ),
                  ],
                ),
              ),

              // 功能入口
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _MenuCard(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        icon: '📚',
                        title: '今日学习',
                        subtitle: '还有$_remainingWords个单词',
                        onTap: () => context.push('/learn'),
                      ),
                      const SizedBox(height: 10),
                      _MenuCard(
                        color: AppColors.cardBg,
                        icon: '🎯',
                        title: '开始练习',
                        subtitle: '闪卡·选择题',
                        onTap: () => context.push('/practice'),
                      ),
                      const SizedBox(height: 10),
                      _MenuCard(
                        color: AppColors.cardBg,
                        icon: '📊',
                        title: '学习报告',
                        subtitle: '查看你的进步',
                        onTap: () => context.push('/profile'),
                      ),
                    ],
                  ),
                ),
              ),

              // 底部导航
              const BottomNavBar(currentIndex: 0),
            ],
          ),
        ),
      ),
    );
  }

  String _getMotivationalMessage(int streakDays) {
    if (streakDays == 0) return '欢迎回来！今天也要加油哦~';
    if (streakDays < 3) return '坚持学习，你已经连续${streakDays}天！';
    if (streakDays < 7) return '太棒了！连续${streakDays}天，继续保持！';
    if (streakDays < 15) return '你是学习小达人！连续${streakDays}天！';
    return '超级厉害！连续${streakDays}天，你是最棒的！';
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
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Gradient? gradient;
  final Color? color;
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    this.gradient,
    this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          color: color ?? AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.text.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: gradient != null
                    ? Colors.white.withOpacity(0.25)
                    : AppColors.secondaryLight,
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: gradient != null ? Colors.white : AppColors.text,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: gradient != null
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '→',
              style: TextStyle(
                fontSize: 20,
                color: gradient != null ? Colors.white : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
