import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/firebase_options.dart';
import 'package:your_career_app/presentation/provider/router_provider.dart'; // 1. インポートを追加

void main() async {
  // 3. main関数を async に変更
  WidgetsFlutterBinding.ensureInitialized(); // 4. Flutterの初期化を保証

  await dotenv.load(fileName: '.env.development');

  await Firebase.initializeApp(
    // 5. Firebaseを初期化
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 2. ProviderScopeでラップする
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // 3. buildメソッドに WidgetRef を追加
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Career App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // ElevatedButton の共通スタイル
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // ボタンの背景色
            foregroundColor: Colors.white, // ボタンの文字色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // 角丸
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        // InputDecoration (TextFieldなど) の共通スタイル
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
