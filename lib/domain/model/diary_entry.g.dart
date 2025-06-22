// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryEntry _$DiaryEntryFromJson(Map<String, dynamic> json) => _DiaryEntry(
  id: json['id'] as String?,
  content: json['content'] as String,
  category: $enumDecode(_$DiaryCategoryEnumMap, json['category']),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$DiaryEntryToJson(_DiaryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'category': _$DiaryCategoryEnumMap[instance.category]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$DiaryCategoryEnumMap = {
  DiaryCategory.bad: 'bad',
  DiaryCategory.good: 'good',
  DiaryCategory.other: 'other',
};
