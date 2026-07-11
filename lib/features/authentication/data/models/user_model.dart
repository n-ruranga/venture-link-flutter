import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venture_link/features/authentication/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String email,
    String? displayName,
    @Default(false) bool isEmailVerified,
    String? role,
    @Default([]) List<String> skills,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? data['name'] as String?,
      isEmailVerified: data['isEmailVerified'] as bool? ?? false,
      role: data['role'] as String?,
      skills: (data['skills'] as List<dynamic>?)
              ?.map((skill) => skill.toString())
              .toList() ??
          const [],
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      isEmailVerified: isEmailVerified,
      role: role,
      skills: skills,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'name': displayName,
      'isEmailVerified': isEmailVerified,
      'role': role,
      'skills': skills,
      'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}
