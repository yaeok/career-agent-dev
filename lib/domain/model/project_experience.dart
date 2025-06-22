import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'diary_entry.dart'; // TimestampConverter を再利用するため

part 'project_experience.freezed.dart';
part 'project_experience.g.dart';

@freezed
abstract class ProjectExperience with _$ProjectExperience {
  const factory ProjectExperience({
    String? id, // ドキュメントID
    required String projectName, // プロジェクト名
    required String role, // 役割・役職
    @TimestampConverter() required DateTime startDate, // 開始日
    @NullableTimestampConverter() DateTime? endDate, // 終了日 (null許容)
    required String description, // プロジェクト概要・成果
    required List<String> technologies, // 使用技術
  }) = _ProjectExperience;

  factory ProjectExperience.fromJson(Map<String, dynamic> json) =>
      _$ProjectExperienceFromJson(json);
}

// nullを許容するTimestampとDateTimeを変換するためのコンバーター
class NullableTimestampConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  @override
  Timestamp? toJson(DateTime? date) {
    return date == null ? null : Timestamp.fromDate(date);
  }
}
