import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_career_app/domain/model/project_experience.dart';
import 'package:your_career_app/domain/repository/project_experience_repository.dart';

class FirestoreProjectExperienceRepository
    implements ProjectExperienceRepository {
  FirestoreProjectExperienceRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // ユーザーごとの職務経歴コレクションへの参照
  CollectionReference<ProjectExperience> _experiencesRef(String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('project_experiences')
          .withConverter<ProjectExperience>(
            fromFirestore:
                (snapshot, _) => ProjectExperience.fromJson(
                  snapshot.data()!,
                ).copyWith(id: snapshot.id),
            toFirestore: (experience, _) => experience.toJson(),
          );

  @override
  Stream<List<ProjectExperience>> watchProjectExperiences(String userId) {
    final query = _experiencesRef(
      userId,
    ).orderBy('startDate', descending: true);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Future<void> addProjectExperience(
    String userId,
    ProjectExperience experience,
  ) async {
    await _experiencesRef(userId).add(experience);
  }

  @override
  Future<void> updateProjectExperience(
    String userId,
    ProjectExperience experience,
  ) async {
    if (experience.id == null) {
      throw Exception('Project Experience ID is null, cannot update.');
    }
    await _experiencesRef(
      userId,
    ).doc(experience.id).update(experience.toJson());
  }

  @override
  Future<void> deleteProjectExperience(
    String userId,
    String experienceId,
  ) async {
    await _experiencesRef(userId).doc(experienceId).delete();
  }
}
