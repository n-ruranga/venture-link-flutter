// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get uid; String get fullName; String get email; String get role; String? get profilePicture; String? get degree; String? get year; List<String> get skills; List<String> get interests; String? get bio;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; String? get resumeUrl; String? get github; String? get linkedin; String? get portfolio; bool get isProfileComplete; bool get isEmailVerified;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other.skills, skills)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.resumeUrl, resumeUrl) || other.resumeUrl == resumeUrl)&&(identical(other.github, github) || other.github == github)&&(identical(other.linkedin, linkedin) || other.linkedin == linkedin)&&(identical(other.portfolio, portfolio) || other.portfolio == portfolio)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,fullName,email,role,profilePicture,degree,year,const DeepCollectionEquality().hash(skills),const DeepCollectionEquality().hash(interests),bio,createdAt,updatedAt,resumeUrl,github,linkedin,portfolio,isProfileComplete,isEmailVerified);

@override
String toString() {
  return 'UserModel(uid: $uid, fullName: $fullName, email: $email, role: $role, profilePicture: $profilePicture, degree: $degree, year: $year, skills: $skills, interests: $interests, bio: $bio, createdAt: $createdAt, updatedAt: $updatedAt, resumeUrl: $resumeUrl, github: $github, linkedin: $linkedin, portfolio: $portfolio, isProfileComplete: $isProfileComplete, isEmailVerified: $isEmailVerified)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String uid, String fullName, String email, String role, String? profilePicture, String? degree, String? year, List<String> skills, List<String> interests, String? bio,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String? resumeUrl, String? github, String? linkedin, String? portfolio, bool isProfileComplete, bool isEmailVerified
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? fullName = null,Object? email = null,Object? role = null,Object? profilePicture = freezed,Object? degree = freezed,Object? year = freezed,Object? skills = null,Object? interests = null,Object? bio = freezed,Object? createdAt = null,Object? updatedAt = null,Object? resumeUrl = freezed,Object? github = freezed,Object? linkedin = freezed,Object? portfolio = freezed,Object? isProfileComplete = null,Object? isEmailVerified = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,degree: freezed == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String?,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,resumeUrl: freezed == resumeUrl ? _self.resumeUrl : resumeUrl // ignore: cast_nullable_to_non_nullable
as String?,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,linkedin: freezed == linkedin ? _self.linkedin : linkedin // ignore: cast_nullable_to_non_nullable
as String?,portfolio: freezed == portfolio ? _self.portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as String?,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String fullName,  String email,  String role,  String? profilePicture,  String? degree,  String? year,  List<String> skills,  List<String> interests,  String? bio, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String? resumeUrl,  String? github,  String? linkedin,  String? portfolio,  bool isProfileComplete,  bool isEmailVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.uid,_that.fullName,_that.email,_that.role,_that.profilePicture,_that.degree,_that.year,_that.skills,_that.interests,_that.bio,_that.createdAt,_that.updatedAt,_that.resumeUrl,_that.github,_that.linkedin,_that.portfolio,_that.isProfileComplete,_that.isEmailVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String fullName,  String email,  String role,  String? profilePicture,  String? degree,  String? year,  List<String> skills,  List<String> interests,  String? bio, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String? resumeUrl,  String? github,  String? linkedin,  String? portfolio,  bool isProfileComplete,  bool isEmailVerified)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.uid,_that.fullName,_that.email,_that.role,_that.profilePicture,_that.degree,_that.year,_that.skills,_that.interests,_that.bio,_that.createdAt,_that.updatedAt,_that.resumeUrl,_that.github,_that.linkedin,_that.portfolio,_that.isProfileComplete,_that.isEmailVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String fullName,  String email,  String role,  String? profilePicture,  String? degree,  String? year,  List<String> skills,  List<String> interests,  String? bio, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String? resumeUrl,  String? github,  String? linkedin,  String? portfolio,  bool isProfileComplete,  bool isEmailVerified)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.uid,_that.fullName,_that.email,_that.role,_that.profilePicture,_that.degree,_that.year,_that.skills,_that.interests,_that.bio,_that.createdAt,_that.updatedAt,_that.resumeUrl,_that.github,_that.linkedin,_that.portfolio,_that.isProfileComplete,_that.isEmailVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.uid, required this.fullName, required this.email, this.role = UserRoles.student, this.profilePicture, this.degree, this.year, final  List<String> skills = const [], final  List<String> interests = const [], this.bio, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.resumeUrl, this.github, this.linkedin, this.portfolio, this.isProfileComplete = false, this.isEmailVerified = false}): _skills = skills,_interests = interests,super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String uid;
@override final  String fullName;
@override final  String email;
@override@JsonKey() final  String role;
@override final  String? profilePicture;
@override final  String? degree;
@override final  String? year;
 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override final  String? bio;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override final  String? resumeUrl;
@override final  String? github;
@override final  String? linkedin;
@override final  String? portfolio;
@override@JsonKey() final  bool isProfileComplete;
@override@JsonKey() final  bool isEmailVerified;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other._skills, _skills)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.resumeUrl, resumeUrl) || other.resumeUrl == resumeUrl)&&(identical(other.github, github) || other.github == github)&&(identical(other.linkedin, linkedin) || other.linkedin == linkedin)&&(identical(other.portfolio, portfolio) || other.portfolio == portfolio)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,fullName,email,role,profilePicture,degree,year,const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_interests),bio,createdAt,updatedAt,resumeUrl,github,linkedin,portfolio,isProfileComplete,isEmailVerified);

@override
String toString() {
  return 'UserModel(uid: $uid, fullName: $fullName, email: $email, role: $role, profilePicture: $profilePicture, degree: $degree, year: $year, skills: $skills, interests: $interests, bio: $bio, createdAt: $createdAt, updatedAt: $updatedAt, resumeUrl: $resumeUrl, github: $github, linkedin: $linkedin, portfolio: $portfolio, isProfileComplete: $isProfileComplete, isEmailVerified: $isEmailVerified)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String fullName, String email, String role, String? profilePicture, String? degree, String? year, List<String> skills, List<String> interests, String? bio,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String? resumeUrl, String? github, String? linkedin, String? portfolio, bool isProfileComplete, bool isEmailVerified
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? fullName = null,Object? email = null,Object? role = null,Object? profilePicture = freezed,Object? degree = freezed,Object? year = freezed,Object? skills = null,Object? interests = null,Object? bio = freezed,Object? createdAt = null,Object? updatedAt = null,Object? resumeUrl = freezed,Object? github = freezed,Object? linkedin = freezed,Object? portfolio = freezed,Object? isProfileComplete = null,Object? isEmailVerified = null,}) {
  return _then(_UserModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,degree: freezed == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String?,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,resumeUrl: freezed == resumeUrl ? _self.resumeUrl : resumeUrl // ignore: cast_nullable_to_non_nullable
as String?,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,linkedin: freezed == linkedin ? _self.linkedin : linkedin // ignore: cast_nullable_to_non_nullable
as String?,portfolio: freezed == portfolio ? _self.portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as String?,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
