// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_experience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectExperience _$ProjectExperienceFromJson(Map<String, dynamic> json) =>
    _ProjectExperience(
      id: json['id'] as String?,
      projectName: json['projectName'] as String,
      role: json['role'] as String,
      startDate: const TimestampConverter().fromJson(
        json['startDate'] as Timestamp,
      ),
      endDate: const NullableTimestampConverter().fromJson(
        json['endDate'] as Timestamp?,
      ),
      description: json['description'] as String,
      technologies:
          (json['technologies'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$ProjectExperienceToJson(_ProjectExperience instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectName': instance.projectName,
      'role': instance.role,
      'startDate': const TimestampConverter().toJson(instance.startDate),
      'endDate': const NullableTimestampConverter().toJson(instance.endDate),
      'description': instance.description,
      'technologies': instance.technologies,
    };
