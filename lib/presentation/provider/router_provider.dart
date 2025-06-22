import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/domain/model/diary_entry.dart';
import 'package:your_career_app/domain/model/project_experience.dart';
import 'package:your_career_app/presentation/page/analysis_page.dart';
import 'package:your_career_app/presentation/page/home_page.dart';
import 'package:your_career_app/presentation/page/login_page.dart';
import 'package:your_career_app/presentation/page/main_shell_page.dart';
import 'package:your_career_app/presentation/page/project_list_page.dart';
import 'package:your_career_app/presentation/page/resume_preview_page.dart';
import 'package:your_career_app/presentation/page/signup_page.dart';
import 'package:your_career_app/presentation/page/upsert_diary_page.dart';
import 'package:your_career_app/presentation/page/upsert_project_page.dart';
import 'auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // タブを持つメインの画面
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellPage(navigationShell: navigationShell);
        },
        branches: [
          // 1つ目のタブ: 日記
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const HomePage()),
            ],
          ),
          // 2つ目のタブ: 職務経歴
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectListPage(),
              ),
            ],
          ),
        ],
      ),
      // ログイン画面
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      // 新規登録画面
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      // 日記作成・編集画面
      GoRoute(
        path: '/upsert-diary',
        parentNavigatorKey: _rootNavigatorKey, // タブバーの上に表示
        builder: (context, state) {
          final diary = state.extra as DiaryEntry?;
          return UpsertDiaryPage(diary: diary);
        },
      ),
      // 職務経歴作成・編集画面
      GoRoute(
        path: '/upsert-project',
        parentNavigatorKey: _rootNavigatorKey, // タブバーの上に表示
        builder: (context, state) {
          final experience = state.extra as ProjectExperience?;
          return UpsertProjectPage(experience: experience);
        },
      ),
      // 自己分析画面
      GoRoute(
        path: '/analysis',
        parentNavigatorKey: _rootNavigatorKey, // タブバーの上に表示
        builder: (context, state) => const AnalysisPage(),
      ),
      // 職務経歴プレビュー画面
      GoRoute(
        path: '/resume-preview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResumePreviewPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = authState.valueOrNull != null;
      final loggingIn =
          state.uri.toString() == '/login' || state.uri.toString() == '/signup';

      if (authState.isLoading || authState.hasError) return null;
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';

      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.stream),
    ),
  );
});

// GoRouterのrefreshListenableにStreamを渡すためのヘルパークラス
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
