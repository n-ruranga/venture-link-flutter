import 'package:equatable/equatable.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';

class ApplicationEntity extends Equatable {
  const ApplicationEntity({
    required this.id,
    required this.studentId,
    required this.opportunityId,
    required this.startupId,
    required this.status,
    this.coverLetter,
    this.resumeUrl,
    required this.createdAt,
    required this.updatedAt,
    this.opportunityTitle,
    this.startupName,
  });

  final String id;
  final String studentId;
  final String opportunityId;
  final String startupId;
  final ApplicationStatus status;
  final String? coverLetter;
  final String? resumeUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? opportunityTitle;
  final String? startupName;

  ApplicationEntity copyWith({
    String? id,
    String? studentId,
    String? opportunityId,
    String? startupId,
    ApplicationStatus? status,
    String? coverLetter,
    String? resumeUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? opportunityTitle,
    String? startupName,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      opportunityId: opportunityId ?? this.opportunityId,
      startupId: startupId ?? this.startupId,
      status: status ?? this.status,
      coverLetter: coverLetter ?? this.coverLetter,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      opportunityTitle: opportunityTitle ?? this.opportunityTitle,
      startupName: startupName ?? this.startupName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        studentId,
        opportunityId,
        startupId,
        status,
        coverLetter,
        resumeUrl,
        createdAt,
        updatedAt,
        opportunityTitle,
        startupName,
      ];
}

class ApplicationsSnapshot extends Equatable {
  const ApplicationsSnapshot({
    required this.applications,
    this.isFromCache = false,
  });

  final List<ApplicationEntity> applications;
  final bool isFromCache;

  @override
  List<Object?> get props => [applications, isFromCache];
}
