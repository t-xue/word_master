import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/constants.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/settings_screen.dart';

// 路由配置
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/learn',
      builder: (context, state) => const LearnScreen(),
    ),
    GoRoute(
      path: '/learn/:category',
      builder: (context, state) => LearnScreen(
        category: state.pathParameters['category'],
      ),
    ),
    GoRoute(
      path: '/practice',
      builder: (context, state) => const PracticeScreen(),
    ),
    GoRoute(
      path: '/practice/:mode',
      builder: (context, state) => PracticeScreen(
        mode: state.pathParameters['mode'] ?? 'flashcard',
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/vocabulary',
      builder: (context, state) => const VocabularyScreen(),
    ),
    GoRoute(
      path: '/vocabulary/:category',
      builder: (context, state) => LearnScreen(
        category: state.pathParameters['category'],
      ),
    ),
    GoRoute(
      path: '/achievements',
      builder: (context, state) => const AchievementsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class WordMasterApp extends StatelessWidget {
  const WordMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '单词小达人',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'PingFang SC',
        
        // 颜色方案
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        
        // 主题色配置
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        
        // 卡片主题
        cardTheme: CardThemeData(
          color: AppColors.cardBg,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        
        // 按钮主题
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        
        // 输入框主题
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        
        // AppBar主题
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        
        // 文本主题
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppColors.text,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
