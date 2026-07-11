// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  role: json['role'] as String?,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'isEmailVerified': instance.isEmailVerified,
      'role': instance.role,
      'skills': instance.skills,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
