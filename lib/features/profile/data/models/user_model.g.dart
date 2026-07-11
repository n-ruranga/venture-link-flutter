// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  role: json['role'] as String? ?? UserRoles.student,
  profilePicture: json['profilePicture'] as String?,
  degree: json['degree'] as String?,
  year: json['year'] as String?,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  bio: json['bio'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  resumeUrl: json['resumeUrl'] as String?,
  github: json['github'] as String?,
  linkedin: json['linkedin'] as String?,
  portfolio: json['portfolio'] as String?,
  isProfileComplete: json['isProfileComplete'] as bool? ?? false,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': instance.role,
      'profilePicture': instance.profilePicture,
      'degree': instance.degree,
      'year': instance.year,
      'skills': instance.skills,
      'interests': instance.interests,
      'bio': instance.bio,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'resumeUrl': instance.resumeUrl,
      'github': instance.github,
      'linkedin': instance.linkedin,
      'portfolio': instance.portfolio,
      'isProfileComplete': instance.isProfileComplete,
      'isEmailVerified': instance.isEmailVerified,
    };
