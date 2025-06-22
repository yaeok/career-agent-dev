import 'package:your_career_app/domain/model/project_experience.dart';
import 'package:your_career_app/domain/repository/auth_repository.dart';
import 'package:your_career_app/domain/repository/project_experience_repository.dart';

class ProjectExperienceUsecase {
  ProjectExperienceUsecase(
    this._authRepository,
    this._projectExperienceRepository,
  );

  final AuthRepository _authRepository;
  final ProjectExperienceRepository _projectExperienceRepository;

  Future<String> _getUserId() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) throw Exception('Not authenticated');
    return user.uid;
  }

  Stream<List<ProjectExperience>> watchProjectExperiences() async* {
    final userId = await _getUserId();
    yield* _projectExperienceRepository.watchProjectExperiences(userId);
  }

  Future<void> addProjectExperience(ProjectExperience experience) async {
    final userId = await _getUserId();
    await _projectExperienceRepository.addProjectExperience(userId, experience);
  }

  Future<void> updateProjectExperience(ProjectExperience experience) async {
    final userId = await _getUserId();
    await _projectExperienceRepository.updateProjectExperience(
      userId,
      experience,
    );
  }

  Future<void> deleteProjectExperience(String experienceId) async {
    final userId = await _getUserId();
    await _projectExperienceRepository.deleteProjectExperience(
      userId,
      experienceId,
    );
  }
}
