import 'package:venture_link/features/applications/data/datasources/firestore_application_datasource.dart';
import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';
import 'package:venture_link/features/applications/domain/repositories/application_repository.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  ApplicationRepositoryImpl(this.datasource);

  final FirestoreApplicationDatasource datasource;

  @override
  Stream<ApplicationsSnapshot> watchStudentApplications(String studentId) {
    return datasource.watchStudentApplications(studentId);
  }

  @override
  Stream<ApplicationsSnapshot> watchStartupApplications(String startupId) {
    return datasource.watchStartupApplications(startupId);
  }

  @override
  Stream<ApplicationEntity?> watchStudentApplicationForOpportunity({
    required String studentId,
    required String opportunityId,
  }) {
    return datasource.watchStudentApplicationForOpportunity(
      studentId: studentId,
      opportunityId: opportunityId,
    );
  }

  @override
  Stream<ApplicationEntity?> watchApplication(String applicationId) {
    return datasource.watchApplication(applicationId);
  }

  @override
  Future<void> apply({
    required String studentId,
    required String opportunityId,
    required String startupId,
    required String coverLetter,
    String? resumeUrl,
  }) {
    return datasource.apply(
      studentId: studentId,
      opportunityId: opportunityId,
      startupId: startupId,
      coverLetter: coverLetter,
      resumeUrl: resumeUrl,
    );
  }

  @override
  Future<void> withdraw({
    required String applicationId,
    required String studentId,
  }) {
    return datasource.withdraw(
      applicationId: applicationId,
      studentId: studentId,
    );
  }

  @override
  Future<void> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
  }) {
    return datasource.updateStatus(
      applicationId: applicationId,
      status: status,
    );
  }
}
