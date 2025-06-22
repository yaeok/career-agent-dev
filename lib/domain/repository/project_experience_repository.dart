import 'package:your_career_app/domain/model/project_experience.dart';

abstract class ProjectExperienceRepository {
  /// 特定ユーザーの職務経歴一覧を取得する (Stream)
  Stream<List<ProjectExperience>> watchProjectExperiences(String userId);

  /// 新しい職務経歴を追加する
  Future<void> addProjectExperience(
    String userId,
    ProjectExperience experience,
  );

  /// 既存の職務経歴を更新する
  Future<void> updateProjectExperience(
    String userId,
    ProjectExperience experience,
  );

  /// 職務経歴を削除する
  Future<void> deleteProjectExperience(String userId, String experienceId);
}
