import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/application/usecase/auth_usecase.dart';
import 'package:your_career_app/domain/model/app_user.dart';
import 'repository_provider.dart';

final authUsecaseProvider = Provider<AuthUsecase>((ref) {
  return AuthUsecase(ref.watch(authRepositoryProvider));
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
