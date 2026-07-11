import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';

abstract class ApplicationRepository {
  Stream<ApplicationsSnapshot> watchStudentApplications(String studentId);

  Stream<ApplicationsSnapshot> watchStartupApplications(String startupId);

  Stream<ApplicationEntity?> watchStudentApplicationForOpportunity({
    required String studentId,
    required String opportunityId,
  });

  Stream<ApplicationEntity?> watchApplication(String applicationId);

  Future<void> apply({
    required String studentId,
    required String opportunityId,
    required String startupId,
    required String coverLetter,
    String? resumeUrl,
  });

  Future<void> withdraw({
    required String applicationId,
    required String studentId,
  });

  Future<void> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
  });
}
