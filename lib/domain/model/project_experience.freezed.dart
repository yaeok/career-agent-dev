// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_experience.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectExperience {

 String? get id;// ドキュメントID
 String get projectName;// プロジェクト名
 String get role;// 役割・役職
@TimestampConverter() DateTime get startDate;// 開始日
@NullableTimestampConverter() DateTime? get endDate;// 終了日 (null許容)
 String get description;// プロジェクト概要・成果
 List<String> get technologies;
/// Create a copy of ProjectExperience
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectExperienceCopyWith<ProjectExperience> get copyWith => _$ProjectExperienceCopyWithImpl<ProjectExperience>(this as ProjectExperience, _$identity);

  /// Serializes this ProjectExperience to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectExperience&&(identical(other.id, id) || other.id == id)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.role, role) || other.role == role)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.technologies, technologies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectName,role,startDate,endDate,description,const DeepCollectionEquality().hash(technologies));

@override
String toString() {
  return 'ProjectExperience(id: $id, projectName: $projectName, role: $role, startDate: $startDate, endDate: $endDate, description: $description, technologies: $technologies)';
}


}

/// @nodoc
abstract mixin class $ProjectExperienceCopyWith<$Res>  {
  factory $ProjectExperienceCopyWith(ProjectExperience value, $Res Function(ProjectExperience) _then) = _$ProjectExperienceCopyWithImpl;
@useResult
$Res call({
 String? id, String projectName, String role,@TimestampConverter() DateTime startDate,@NullableTimestampConverter() DateTime? endDate, String description, List<String> technologies
});




}
/// @nodoc
class _$ProjectExperienceCopyWithImpl<$Res>
    implements $ProjectExperienceCopyWith<$Res> {
  _$ProjectExperienceCopyWithImpl(this._self, this._then);

  final ProjectExperience _self;
  final $Res Function(ProjectExperience) _then;

/// Create a copy of ProjectExperience
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? projectName = null,Object? role = null,Object? startDate = null,Object? endDate = freezed,Object? description = null,Object? technologies = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,technologies: null == technologies ? _self.technologies : technologies // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ProjectExperience implements ProjectExperience {
  const _ProjectExperience({this.id, required this.projectName, required this.role, @TimestampConverter() required this.startDate, @NullableTimestampConverter() this.endDate, required this.description, required final  List<String> technologies}): _technologies = technologies;
  factory _ProjectExperience.fromJson(Map<String, dynamic> json) => _$ProjectExperienceFromJson(json);

@override final  String? id;
// ドキュメントID
@override final  String projectName;
// プロジェクト名
@override final  String role;
// 役割・役職
@override@TimestampConverter() final  DateTime startDate;
// 開始日
@override@NullableTimestampConverter() final  DateTime? endDate;
// 終了日 (null許容)
@override final  String description;
// プロジェクト概要・成果
 final  List<String> _technologies;
// プロジェクト概要・成果
@override List<String> get technologies {
  if (_technologies is EqualUnmodifiableListView) return _technologies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_technologies);
}


/// Create a copy of ProjectExperience
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectExperienceCopyWith<_ProjectExperience> get copyWith => __$ProjectExperienceCopyWithImpl<_ProjectExperience>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectExperienceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectExperience&&(identical(other.id, id) || other.id == id)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.role, role) || other.role == role)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._technologies, _technologies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectName,role,startDate,endDate,description,const DeepCollectionEquality().hash(_technologies));

@override
String toString() {
  return 'ProjectExperience(id: $id, projectName: $projectName, role: $role, startDate: $startDate, endDate: $endDate, description: $description, technologies: $technologies)';
}


}

/// @nodoc
abstract mixin class _$ProjectExperienceCopyWith<$Res> implements $ProjectExperienceCopyWith<$Res> {
  factory _$ProjectExperienceCopyWith(_ProjectExperience value, $Res Function(_ProjectExperience) _then) = __$ProjectExperienceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String projectName, String role,@TimestampConverter() DateTime startDate,@NullableTimestampConverter() DateTime? endDate, String description, List<String> technologies
});




}
/// @nodoc
class __$ProjectExperienceCopyWithImpl<$Res>
    implements _$ProjectExperienceCopyWith<$Res> {
  __$ProjectExperienceCopyWithImpl(this._self, this._then);

  final _ProjectExperience _self;
  final $Res Function(_ProjectExperience) _then;

/// Create a copy of ProjectExperience
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? projectName = null,Object? role = null,Object? startDate = null,Object? endDate = freezed,Object? description = null,Object? technologies = null,}) {
  return _then(_ProjectExperience(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,technologies: null == technologies ? _self._technologies : technologies // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
