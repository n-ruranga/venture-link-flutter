// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpportunityModel {

 String get id; String get title; String get description; String get startupId; String get startupName; List<String> get skills; String get location; String get workMode; String get category; String get hoursPerWeek;@TimestampConverter() DateTime get deadline;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; String get status; bool get isVerified;
/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpportunityModelCopyWith<OpportunityModel> get copyWith => _$OpportunityModelCopyWithImpl<OpportunityModel>(this as OpportunityModel, _$identity);

  /// Serializes this OpportunityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startupId, startupId) || other.startupId == startupId)&&(identical(other.startupName, startupName) || other.startupName == startupName)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.category, category) || other.category == category)&&(identical(other.hoursPerWeek, hoursPerWeek) || other.hoursPerWeek == hoursPerWeek)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startupId,startupName,const DeepCollectionEquality().hash(skills),location,workMode,category,hoursPerWeek,deadline,createdAt,updatedAt,status,isVerified);

@override
String toString() {
  return 'OpportunityModel(id: $id, title: $title, description: $description, startupId: $startupId, startupName: $startupName, skills: $skills, location: $location, workMode: $workMode, category: $category, hoursPerWeek: $hoursPerWeek, deadline: $deadline, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $OpportunityModelCopyWith<$Res>  {
  factory $OpportunityModelCopyWith(OpportunityModel value, $Res Function(OpportunityModel) _then) = _$OpportunityModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String startupId, String startupName, List<String> skills, String location, String workMode, String category, String hoursPerWeek,@TimestampConverter() DateTime deadline,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String status, bool isVerified
});




}
/// @nodoc
class _$OpportunityModelCopyWithImpl<$Res>
    implements $OpportunityModelCopyWith<$Res> {
  _$OpportunityModelCopyWithImpl(this._self, this._then);

  final OpportunityModel _self;
  final $Res Function(OpportunityModel) _then;

/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? startupId = null,Object? startupName = null,Object? skills = null,Object? location = null,Object? workMode = null,Object? category = null,Object? hoursPerWeek = null,Object? deadline = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startupId: null == startupId ? _self.startupId : startupId // ignore: cast_nullable_to_non_nullable
as String,startupName: null == startupName ? _self.startupName : startupName // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,workMode: null == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,hoursPerWeek: null == hoursPerWeek ? _self.hoursPerWeek : hoursPerWeek // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OpportunityModel].
extension OpportunityModelPatterns on OpportunityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpportunityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpportunityModel value)  $default,){
final _that = this;
switch (_that) {
case _OpportunityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpportunityModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String startupId,  String startupName,  List<String> skills,  String location,  String workMode,  String category,  String hoursPerWeek, @TimestampConverter()  DateTime deadline, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String status,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startupId,_that.startupName,_that.skills,_that.location,_that.workMode,_that.category,_that.hoursPerWeek,_that.deadline,_that.createdAt,_that.updatedAt,_that.status,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String startupId,  String startupName,  List<String> skills,  String location,  String workMode,  String category,  String hoursPerWeek, @TimestampConverter()  DateTime deadline, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String status,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _OpportunityModel():
return $default(_that.id,_that.title,_that.description,_that.startupId,_that.startupName,_that.skills,_that.location,_that.workMode,_that.category,_that.hoursPerWeek,_that.deadline,_that.createdAt,_that.updatedAt,_that.status,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String startupId,  String startupName,  List<String> skills,  String location,  String workMode,  String category,  String hoursPerWeek, @TimestampConverter()  DateTime deadline, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String status,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startupId,_that.startupName,_that.skills,_that.location,_that.workMode,_that.category,_that.hoursPerWeek,_that.deadline,_that.createdAt,_that.updatedAt,_that.status,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpportunityModel extends OpportunityModel {
  const _OpportunityModel({required this.id, required this.title, required this.description, required this.startupId, required this.startupName, final  List<String> skills = const [], required this.location, required this.workMode, required this.category, required this.hoursPerWeek, @TimestampConverter() required this.deadline, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.status = 'active', this.isVerified = false}): _skills = skills,super._();
  factory _OpportunityModel.fromJson(Map<String, dynamic> json) => _$OpportunityModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String startupId;
@override final  String startupName;
 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

@override final  String location;
@override final  String workMode;
@override final  String category;
@override final  String hoursPerWeek;
@override@TimestampConverter() final  DateTime deadline;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isVerified;

/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpportunityModelCopyWith<_OpportunityModel> get copyWith => __$OpportunityModelCopyWithImpl<_OpportunityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpportunityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpportunityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startupId, startupId) || other.startupId == startupId)&&(identical(other.startupName, startupName) || other.startupName == startupName)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.location, location) || other.location == location)&&(identical(other.workMode, workMode) || other.workMode == workMode)&&(identical(other.category, category) || other.category == category)&&(identical(other.hoursPerWeek, hoursPerWeek) || other.hoursPerWeek == hoursPerWeek)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startupId,startupName,const DeepCollectionEquality().hash(_skills),location,workMode,category,hoursPerWeek,deadline,createdAt,updatedAt,status,isVerified);

@override
String toString() {
  return 'OpportunityModel(id: $id, title: $title, description: $description, startupId: $startupId, startupName: $startupName, skills: $skills, location: $location, workMode: $workMode, category: $category, hoursPerWeek: $hoursPerWeek, deadline: $deadline, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$OpportunityModelCopyWith<$Res> implements $OpportunityModelCopyWith<$Res> {
  factory _$OpportunityModelCopyWith(_OpportunityModel value, $Res Function(_OpportunityModel) _then) = __$OpportunityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String startupId, String startupName, List<String> skills, String location, String workMode, String category, String hoursPerWeek,@TimestampConverter() DateTime deadline,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String status, bool isVerified
});




}
/// @nodoc
class __$OpportunityModelCopyWithImpl<$Res>
    implements _$OpportunityModelCopyWith<$Res> {
  __$OpportunityModelCopyWithImpl(this._self, this._then);

  final _OpportunityModel _self;
  final $Res Function(_OpportunityModel) _then;

/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? startupId = null,Object? startupName = null,Object? skills = null,Object? location = null,Object? workMode = null,Object? category = null,Object? hoursPerWeek = null,Object? deadline = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? isVerified = null,}) {
  return _then(_OpportunityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startupId: null == startupId ? _self.startupId : startupId // ignore: cast_nullable_to_non_nullable
as String,startupName: null == startupName ? _self.startupName : startupName // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,workMode: null == workMode ? _self.workMode : workMode // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,hoursPerWeek: null == hoursPerWeek ? _self.hoursPerWeek : hoursPerWeek // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
