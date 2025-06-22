import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_entry.freezed.dart';
part 'diary_entry.g.dart';

/// 日記のカテゴリ
enum DiaryCategory {
  bad, // 嫌だったこと
  good, // 成果・楽しかったこと
  other, // その他
}

@freezed
abstract class DiaryEntry with _$DiaryEntry {
  const factory DiaryEntry({
    String? id, // ドキュメントID
    required String content, // 内容
    required DiaryCategory category, // カテゴリ
    @TimestampConverter() required DateTime createdAt, // 作成日時
  }) = _DiaryEntry;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryFromJson(json);
}

// FirestoreのTimestampとDartのDateTimeを相互に変換するためのコンバーター
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
