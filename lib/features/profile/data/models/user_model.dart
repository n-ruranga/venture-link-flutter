import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/utils/timestamp_converter.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String fullName,
    required String email,
    @Default(UserRoles.student) String role,
    String? profilePicture,
    String? degree,
    String? year,
    @Default([]) List<String> skills,
    @Default([]) List<String> interests,
    String? bio,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    String? resumeUrl,
    String? github,
    String? linkedin,
    String? portfolio,
    @Default(false) bool isProfileComplete,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.initial({
    required String uid,
    required String email,
    required String fullName,
  }) {
    final now = DateTime.now();
    return UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      role: UserRoles.student,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> json, String uid) {
    return UserModel.fromJson({...json, 'uid': uid});
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      uid: uid,
      fullName: fullName,
      email: email,
      role: role,
      profilePicture: profilePicture,
      degree: degree,
      year: year,
      skills: skills,
      interests: interests,
      bio: bio,
      createdAt: createdAt,
      updatedAt: updatedAt,
      resumeUrl: resumeUrl,
      github: github,
      linkedin: linkedin,
      portfolio: portfolio,
      isProfileComplete: isProfileComplete,
      isEmailVerified: isEmailVerified,
      isVerified: isVerified,
    );
  }

  factory UserModel.fromEntity(UserProfileEntity entity) {
    return UserModel(
      uid: entity.uid,
      fullName: entity.fullName,
      email: entity.email,
      role: entity.role,
      profilePicture: entity.profilePicture,
      degree: entity.degree,
      year: entity.year,
      skills: entity.skills,
      interests: entity.interests,
      bio: entity.bio,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      resumeUrl: entity.resumeUrl,
      github: entity.github,
      linkedin: entity.linkedin,
      portfolio: entity.portfolio,
      isProfileComplete: entity.isProfileComplete,
      isEmailVerified: entity.isEmailVerified,
      isVerified: entity.isVerified,
    );
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    return json;
  }

  static bool calculateIsComplete(UserProfileEntity profile) {
    return profile.fullName.isNotEmpty &&
        (profile.degree?.isNotEmpty ?? false) &&
        (profile.year?.isNotEmpty ?? false) &&
        profile.skills.isNotEmpty &&
        (profile.bio?.isNotEmpty ?? false);
  }
}
