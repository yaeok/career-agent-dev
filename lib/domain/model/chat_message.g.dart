// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String?,
  text: json['text'] as String,
  sender: $enumDecode(_$SenderRoleEnumMap, json['sender']),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'sender': _$SenderRoleEnumMap[instance.sender]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$SenderRoleEnumMap = {
  SenderRole.user: 'user',
  SenderRole.agent: 'agent',
};
