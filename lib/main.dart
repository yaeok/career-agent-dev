import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/firebase_options.dart';
import 'package:your_career_app/presentation/provider/router_provider.dart';
import 'package:your_career_app/presentation/theme/app_theme.dart'; // 作成したテーマファイルをインポート

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.development');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Career App',
      // 作成したファイルからテーマを適用
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // 必要に応じて、システムのテーマ設定（ライト/ダーク）に追従させることも可能です
      // themeMode: ThemeMode.system,
    );
  }
}
