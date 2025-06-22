import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:your_career_app/domain/model/diary_entry.dart'; // TimestampConverterを再利用

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// メッセージの送信者を定義
enum SenderRole {
  user, // ユーザー
  agent, // AIエージェント
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    String? id,
    required String text,
    required SenderRole sender,
    @TimestampConverter() required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
