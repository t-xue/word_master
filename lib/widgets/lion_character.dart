import 'package:flutter/material.dart';
import '../config/constants.dart';

/// 小狮子角色组件
class LionCharacter extends StatelessWidget {
  final double size;
  final String mood;
  final bool animate;

  const LionCharacter({
    super.key,
    this.size = 100,
    this.mood = 'happy',
    this.animate = false,
  });

  String getExpression() {
    return LionExpressions.expressions[mood] ?? LionExpressions.expressions['happy']!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 鬃毛
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
            ),
          ),
          // 脸
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardBg,
            ),
          ),
          // 耳朵
          Positioned(
            top: size * 0.15,
            left: size * 0.15,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
              ),
            ),
          ),
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
              ),
            ),
          ),
          // 眼睛
          Positioned(
            top: size * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size * 0.12,
                  height: size * 0.12,
                  alignment: Alignment.center,
                  child: Text(
                    getExpression()[0],
                    style: TextStyle(
                      fontSize: size * 0.1,
                      color: AppColors.text,
                    ),
                  ),
                ),
                SizedBox(width: size * 0.2),
                Container(
                  width: size * 0.12,
                  height: size * 0.12,
                  alignment: Alignment.center,
                  child: Text(
                    getExpression()[1],
                    style: TextStyle(
                      fontSize: size * 0.1,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 鼻子
          Positioned(
            top: size * 0.5,
            child: Container(
              width: size * 0.12,
              height: size * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
          // 嘴巴
          Positioned(
            top: size * 0.6,
            child: Container(
              width: size * 0.2,
              height: size * 0.15,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.text,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // 腮红
          Positioned(
            top: size * 0.48,
            left: size * 0.08,
            child: Container(
              width: size * 0.15,
              height: size * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB5B5).withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: size * 0.48,
            right: size * 0.08,
            child: Container(
              width: size * 0.15,
              height: size * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB5B5).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 小狮子对话组件
class LionSpeechBubble extends StatelessWidget {
  final String text;
  final double lionSize;
  final String mood;

  const LionSpeechBubble({
    super.key,
    required this.text,
    this.lionSize = 60,
    this.mood = 'happy',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LionCharacter(size: lionSize, mood: mood),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.text.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }
}
