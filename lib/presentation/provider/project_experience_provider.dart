import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_career_app/application/usecase/project_experience_usecase.dart';
import 'package:your_career_app/domain/model/project_experience.dart';
import 'auth_provider.dart';
import 'repository_provider.dart';

final projectExperienceUsecaseProvider = Provider<ProjectExperienceUsecase>((
  ref,
) {
  final authRepo = ref.watch(authRepositoryProvider);
  final projRepo = ref.watch(projectExperienceRepositoryProvider);
  return ProjectExperienceUsecase(authRepo, projRepo);
});

final projectExperiencesProvider = StreamProvider<List<ProjectExperience>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  if (authState.valueOrNull != null) {
    return ref
        .watch(projectExperienceUsecaseProvider)
        .watchProjectExperiences();
  }
  return Stream.value([]);
});
