import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'config/app_config.dart';
import 'providers/user_provider.dart';
import 'services/storage_service.dart';
import 'services/word_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Hive本地存储
  await Hive.initFlutter();

  // 初始化存储服务
  final storageService = StorageService();
  await storageService.init();

  // 加载应用配置（包括 API Key）
  await AppConfig.init();

  // 加载词库数据
  final wordService = WordService();
  await wordService.loadWords();

  runApp(
    ProviderScope(
      child: const WordMasterApp(),
    ),
  );
}
