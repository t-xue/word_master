import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/lion_character.dart';
import '../providers/user_provider.dart';

/// 成就页面
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

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
                          '🏆 成就',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // 用户等级信息
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // 头像
                          Container(
                            width: 60,
                            height: 60,
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
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // 等级信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lv.${userProgress.level} ${LevelSystem.getLevelName(userProgress.level)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 经验值进度条
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor: _calculateLevelProgress(userProgress),
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${userProgress.experience}/${LevelSystem.getExpRequired(userProgress.level + 1)} EXP',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 等级emoji
                          Text(
                            LevelSystem.getLevelEmoji(userProgress.level),
                            style: const TextStyle(fontSize: 40),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 徽章区
                    _buildSectionTitle('🎖️ 我的徽章'),
                    const SizedBox(height: 12),
                    _buildBadgeGrid(context, userProgress),

                    const SizedBox(height: 20),

                    // 学习统计
                    _buildSectionTitle('📊 学习统计'),
                    const SizedBox(height: 12),
                    _buildStatsSection(userProgress),

                    const SizedBox(height: 20),

                    // 等级系统
                    _buildSectionTitle('⭐ 等级系统'),
                    const SizedBox(height: 12),
                    _buildLevelSystem(userProgress.level),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 底部导航
            const BottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  double _calculateLevelProgress(dynamic progress) {
    final currentExp = progress.experience;
    final currentLevelExp = LevelSystem.getExpRequired(progress.level);
    final nextLevelExp = LevelSystem.getExpRequired(progress.level + 1);

    if (nextLevelExp <= currentLevelExp) return 1.0;

    return (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildBadgeGrid(BuildContext context, dynamic userProgress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: BadgeSystem.badges.map((badge) {
          final isUnlocked = userProgress.unlockedBadges.contains(badge['id']);
          return GestureDetector(
            onTap: () => _showBadgeDetail(context, badge, isUnlocked),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? _getBadgeColor(badge['id'] as String)
                        : AppColors.border,
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: _getBadgeColor(badge['id'] as String).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: isUnlocked ? 1 : 0.3,
                      child: Text(
                        badge['emoji'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  badge['name'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isUnlocked ? AppColors.text : AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsSection(dynamic userProgress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCard(
            icon: '📚',
            value: userProgress.wordsLearned.toString(),
            label: '已学单词',
            color: AppColors.primary,
          ),
          _StatCard(
            icon: '✅',
            value: userProgress.wordsMastered.toString(),
            label: '掌握单词',
            color: AppColors.success,
          ),
          _StatCard(
            icon: '🔥',
            value: userProgress.streakDays.toString(),
            label: '连续天数',
            color: AppColors.accent,
          ),
          _StatCard(
            icon: '💎',
            value: userProgress.totalPoints.toString(),
            label: '总积分',
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSystem(int currentLevel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: LevelSystem.levels.map((level) {
          final levelNum = level['level'] as int;
          final levelName = level['name'] as String;
          final levelEmoji = level['emoji'] as String;
          final isCurrentLevel = levelNum == currentLevel;
          final isPastLevel = levelNum < currentLevel;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isCurrentLevel
                  ? AppColors.primary.withOpacity(0.1)
                  : isPastLevel
                      ? AppColors.success.withOpacity(0.05)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isCurrentLevel
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                // 等级emoji
                Opacity(
                  opacity: isPastLevel || isCurrentLevel ? 1.0 : 0.3,
                  child: Text(
                    levelEmoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 14),
                // 等级信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lv.$levelNum $levelName',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isCurrentLevel ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrentLevel
                              ? AppColors.primary
                              : isPastLevel
                                  ? AppColors.text
                                  : AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '需要 ${level['expRequired']} 经验值',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                // 状态指示
                if (isPastLevel)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24,
                  )
                else if (isCurrentLevel)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '当前',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getBadgeColor(String id) {
    if (id.contains('streak')) return AppColors.accent;
    if (id.contains('words')) return AppColors.success;
    if (id.contains('perfect')) return AppColors.secondary;
    return AppColors.primary;
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
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? _getBadgeColor(badge['id'] as String)
                      : AppColors.border,
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: _getBadgeColor(badge['id'] as String).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Opacity(
                    opacity: isUnlocked ? 1 : 0.3,
                    child: Text(badge['emoji'] as String, style: const TextStyle(fontSize: 35)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge['name'] as String,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge['description'] as String,
                style: TextStyle(fontSize: 15, color: AppColors.textLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '已解锁',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: AppColors.textMuted, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '未解锁',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '关闭',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
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
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
