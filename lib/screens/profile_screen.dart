import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/lion_character.dart';
import '../providers/user_provider.dart';
import '../models/user_progress.dart';

/// 个人中心页
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);

    // 如果没有用户，跳转到登录页
    if (userProgress == null || userProgress.userName.isEmpty) {
      Future.microtask(() => context.go('/'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // 顶部用户信息
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
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cardBg,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              userProgress.avatarEmoji,
                              style: const TextStyle(fontSize: 34),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProgress.userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '⭐ Lv.${userProgress.level} ${LevelSystem.getLevelName(userProgress.level)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _showSettings(context, ref),
                          icon: const Icon(Icons.settings, color: Colors.white),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // 统计数据
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _HeaderStat(
                            value: userProgress.wordsLearned.toString(),
                            label: '已学单词',
                          ),
                          _HeaderStat(
                            value: userProgress.streakDays.toString(),
                            label: '连续天数',
                          ),
                          _HeaderStat(
                            value: userProgress.totalPoints.toString(),
                            label: '获得积分',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 内容区
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // 徽章区
                    const SizedBox(height: 5),
                    Text(
                      '🏆 我的徽章',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: BadgeSystem.badges.map((badge) {
                        final isUnlocked = userProgress.unlockedBadges.contains(badge['id']);
                        return GestureDetector(
                          onTap: () => _showBadgeDetail(context, badge, isUnlocked),
                          child: Column(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isUnlocked
                                      ? _getBadgeColor(badge['id'] as String)
                                      : AppColors.border,
                                ),
                                child: Center(
                                  child: Opacity(
                                    opacity: isUnlocked ? 1 : 0.3,
                                    child: Text(
                                      badge['emoji'] as String,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                badge['name'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textLight,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 15),

                    // 等级进度
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondaryLight, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          // 进度环
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.border,
                                  ),
                                ),
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.background,
                                  ),
                                ),
                                Text(
                                  LevelSystem.getLevelEmoji(userProgress.level),
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '当前等级',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.text,
                                  ),
                                ),
                                Text(
                                  'Lv.${userProgress.level} ${LevelSystem.getLevelName(userProgress.level)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _ProgressBar(
                                  progress: _calculateLevelProgress(userProgress),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${userProgress.experience}/${LevelSystem.getExpRequired(userProgress.level + 1)} 经验值',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 学习统计
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.text.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '学习统计',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.text,
                                ),
                              ),
                              Icon(Icons.bar_chart, color: AppColors.primary),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatCard(
                                icon: '📚',
                                value: userProgress.wordsLearned.toString(),
                                label: '已学单词',
                              ),
                              _StatCard(
                                icon: '✅',
                                value: userProgress.wordsMastered.toString(),
                                label: '掌握单词',
                              ),
                              _StatCard(
                                icon: '🔥',
                                value: userProgress.streakDays.toString(),
                                label: '连续天数',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 今日目标
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.text.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '今日学习',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.text,
                                ),
                              ),
                              Text(
                                '${userProgress.wordsLearned % 10}/10 单词',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 9,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: (userProgress.wordsLearned % 10) / 10,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.primary, AppColors.secondary],
                                  ),
                                  borderRadius: BorderRadius.circular(5),
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

            // 底部导航
            const BottomNavBar(currentIndex: 3),
          ],
        ),
      ),
    );
  }

  double _calculateLevelProgress(UserProgress progress) {
    final currentExp = progress.experience;
    final currentLevelExp = LevelSystem.getExpRequired(progress.level);
    final nextLevelExp = LevelSystem.getExpRequired(progress.level + 1);

    if (nextLevelExp <= currentLevelExp) return 1.0;

    return (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp);
  }

  Color _getBadgeColor(String id) {
    if (id.contains('streak')) return AppColors.accent;
    if (id.contains('words')) return AppColors.success;
    if (id.contains('perfect')) return AppColors.secondary;
    return AppColors.primary;
  }

  void _showSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.primary),
              title: const Text('API 设置'),
              subtitle: const Text('配置 TTS 发音服务'),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.secondary),
              title: const Text('修改名字'),
              onTap: () {
                Navigator.pop(context);
                _showEditNameDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: AppColors.accent),
              title: const Text('重置进度'),
              onTap: () {
                Navigator.pop(context);
                _showResetConfirmDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改名字'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '输入新名字'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProgressProvider.notifier).updateUserInfo(name: controller.text);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置进度'),
        content: const Text('确定要清除所有学习进度吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProgressProvider.notifier).clearUserData();
              Navigator.pop(context);
              context.go('/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('确定重置'),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetail(BuildContext context, Map<String, dynamic> badge, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked ? _getBadgeColor(badge['id'] as String) : AppColors.border,
                ),
                child: Center(
                  child: Opacity(
                    opacity: isUnlocked ? 1 : 0.3,
                    child: Text(badge['emoji'] as String, style: const TextStyle(fontSize: 30)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge['name'] as String,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                badge['description'] as String,
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              ),
              if (!isUnlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '未解锁',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat({required this.value, required this.label});

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

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0.0, 1.0),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.text,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textLight),
        ),
      ],
    );
  }
}
