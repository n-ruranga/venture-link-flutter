import 'package:equatable/equatable.dart';

class StartupDashboardStats extends Equatable {
  const StartupDashboardStats({
    this.activeOpportunities = 0,
    this.totalApplicants = 0,
    this.acceptedStudents = 0,
    this.rejectedStudents = 0,
  });

  final int activeOpportunities;
  final int totalApplicants;
  final int acceptedStudents;
  final int rejectedStudents;

  @override
  List<Object?> get props => [
        activeOpportunities,
        totalApplicants,
        acceptedStudents,
        rejectedStudents,
      ];
}
