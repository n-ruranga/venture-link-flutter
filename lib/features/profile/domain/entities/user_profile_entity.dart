import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  const UserProfileEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.profilePicture,
    this.degree,
    this.year,
    this.skills = const [],
    this.interests = const [],
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.resumeUrl,
    this.github,
    this.linkedin,
    this.portfolio,
    this.isProfileComplete = false,
    this.isEmailVerified = false,
  });

  final String uid;
  final String fullName;
  final String email;
  final String role;
  final String? profilePicture;
  final String? degree;
  final String? year;
  final List<String> skills;
  final List<String> interests;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? resumeUrl;
  final String? github;
  final String? linkedin;
  final String? portfolio;
  final bool isProfileComplete;
  final bool isEmailVerified;

  int get completionPercentage {
    final fields = [
      fullName.isNotEmpty,
      degree?.isNotEmpty ?? false,
      year?.isNotEmpty ?? false,
      skills.isNotEmpty,
      interests.isNotEmpty,
      bio?.isNotEmpty ?? false,
      github?.isNotEmpty ?? false,
      linkedin?.isNotEmpty ?? false,
    ];
    final completed = fields.where((field) => field).length;
    return ((completed / fields.length) * 100).round();
  }

  UserProfileEntity copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? role,
    String? profilePicture,
    String? degree,
    String? year,
    List<String>? skills,
    List<String>? interests,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? resumeUrl,
    String? github,
    String? linkedin,
    String? portfolio,
    bool? isProfileComplete,
    bool? isEmailVerified,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      degree: degree ?? this.degree,
      year: year ?? this.year,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        fullName,
        email,
        role,
        profilePicture,
        degree,
        year,
        skills,
        interests,
        bio,
        createdAt,
        updatedAt,
        resumeUrl,
        github,
        linkedin,
        portfolio,
        isProfileComplete,
        isEmailVerified,
      ];
}
