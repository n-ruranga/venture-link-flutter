import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.isEmailVerified = false,
    this.role,
    this.skills = const [],
    this.createdAt,
  });

  final String uid;
  final String email;
  final String? displayName;
  final bool isEmailVerified;
  final String? role;
  final List<String> skills;
  final DateTime? createdAt;

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isEmailVerified,
    String? role,
    List<String>? skills,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        isEmailVerified,
        role,
        skills,
        createdAt,
      ];
}
