// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicationModel {

 String get id; String get studentId; String get opportunityId; String get startupId; String get status; String? get coverLetter; String? get resumeUrl;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of ApplicationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationModelCopyWith<ApplicationModel> get copyWith => _$ApplicationModelCopyWithImpl<ApplicationModel>(this as ApplicationModel, _$identity);

  /// Serializes this ApplicationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.opportunityId, opportunityId) || other.opportunityId == opportunityId)&&(identical(other.startupId, startupId) || other.startupId == startupId)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverLetter, coverLetter) || other.coverLetter == coverLetter)&&(identical(other.resumeUrl, resumeUrl) || other.resumeUrl == resumeUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,opportunityId,startupId,status,coverLetter,resumeUrl,createdAt,updatedAt);

@override
String toString() {
  return 'ApplicationModel(id: $id, studentId: $studentId, opportunityId: $opportunityId, startupId: $startupId, status: $status, coverLetter: $coverLetter, resumeUrl: $resumeUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ApplicationModelCopyWith<$Res>  {
  factory $ApplicationModelCopyWith(ApplicationModel value, $Res Function(ApplicationModel) _then) = _$ApplicationModelCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String opportunityId, String startupId, String status, String? coverLetter, String? resumeUrl,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$ApplicationModelCopyWithImpl<$Res>
    implements $ApplicationModelCopyWith<$Res> {
  _$ApplicationModelCopyWithImpl(this._self, this._then);

  final ApplicationModel _self;
  final $Res Function(ApplicationModel) _then;

/// Create a copy of ApplicationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? opportunityId = null,Object? startupId = null,Object? status = null,Object? coverLetter = freezed,Object? resumeUrl = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,opportunityId: null == opportunityId ? _self.opportunityId : opportunityId // ignore: cast_nullable_to_non_nullable
as String,startupId: null == startupId ? _self.startupId : startupId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,coverLetter: freezed == coverLetter ? _self.coverLetter : coverLetter // ignore: cast_nullable_to_non_nullable
as String?,resumeUrl: freezed == resumeUrl ? _self.resumeUrl : resumeUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationModel].
extension ApplicationModelPatterns on ApplicationModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationModel value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String opportunityId,  String startupId,  String status,  String? coverLetter,  String? resumeUrl, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationModel() when $default != null:
return $default(_that.id,_that.studentId,_that.opportunityId,_that.startupId,_that.status,_that.coverLetter,_that.resumeUrl,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String opportunityId,  String startupId,  String status,  String? coverLetter,  String? resumeUrl, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ApplicationModel():
return $default(_that.id,_that.studentId,_that.opportunityId,_that.startupId,_that.status,_that.coverLetter,_that.resumeUrl,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String opportunityId,  String startupId,  String status,  String? coverLetter,  String? resumeUrl, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationModel() when $default != null:
return $default(_that.id,_that.studentId,_that.opportunityId,_that.startupId,_that.status,_that.coverLetter,_that.resumeUrl,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationModel extends ApplicationModel {
  const _ApplicationModel({required this.id, required this.studentId, required this.opportunityId, required this.startupId, this.status = 'applied', this.coverLetter, this.resumeUrl, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): super._();
  factory _ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);

@override final  String id;
@override final  String studentId;
@override final  String opportunityId;
@override final  String startupId;
@override@JsonKey() final  String status;
@override final  String? coverLetter;
@override final  String? resumeUrl;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of ApplicationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationModelCopyWith<_ApplicationModel> get copyWith => __$ApplicationModelCopyWithImpl<_ApplicationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.opportunityId, opportunityId) || other.opportunityId == opportunityId)&&(identical(other.startupId, startupId) || other.startupId == startupId)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverLetter, coverLetter) || other.coverLetter == coverLetter)&&(identical(other.resumeUrl, resumeUrl) || other.resumeUrl == resumeUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,opportunityId,startupId,status,coverLetter,resumeUrl,createdAt,updatedAt);

@override
String toString() {
  return 'ApplicationModel(id: $id, studentId: $studentId, opportunityId: $opportunityId, startupId: $startupId, status: $status, coverLetter: $coverLetter, resumeUrl: $resumeUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ApplicationModelCopyWith<$Res> implements $ApplicationModelCopyWith<$Res> {
  factory _$ApplicationModelCopyWith(_ApplicationModel value, $Res Function(_ApplicationModel) _then) = __$ApplicationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String opportunityId, String startupId, String status, String? coverLetter, String? resumeUrl,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$ApplicationModelCopyWithImpl<$Res>
    implements _$ApplicationModelCopyWith<$Res> {
  __$ApplicationModelCopyWithImpl(this._self, this._then);

  final _ApplicationModel _self;
  final $Res Function(_ApplicationModel) _then;

/// Create a copy of ApplicationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? opportunityId = null,Object? startupId = null,Object? status = null,Object? coverLetter = freezed,Object? resumeUrl = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ApplicationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,opportunityId: null == opportunityId ? _self.opportunityId : opportunityId // ignore: cast_nullable_to_non_nullable
as String,startupId: null == startupId ? _self.startupId : startupId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,coverLetter: freezed == coverLetter ? _self.coverLetter : coverLetter // ignore: cast_nullable_to_non_nullable
as String?,resumeUrl: freezed == resumeUrl ? _self.resumeUrl : resumeUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
