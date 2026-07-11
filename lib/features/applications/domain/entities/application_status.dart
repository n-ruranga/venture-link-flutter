import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';

enum ApplicationStatus {
  applied('applied', 'Applied'),
  underReview('under_review', 'Under Review'),
  interview('interview', 'Interview'),
  accepted('accepted', 'Accepted'),
  rejected('rejected', 'Rejected');

  const ApplicationStatus(this.value, this.label);

  final String value;
  final String label;

  static ApplicationStatus fromString(String? value) {
    return ApplicationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ApplicationStatus.applied,
    );
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.applied:
        return AppColors.primary;
      case ApplicationStatus.underReview:
        return AppColors.accent;
      case ApplicationStatus.interview:
        return const Color(0xFF0EA5E9);
      case ApplicationStatus.accepted:
        return AppColors.success;
      case ApplicationStatus.rejected:
        return AppColors.error;
    }
  }

  Color get backgroundColor => color.withValues(alpha: 0.12);

  static const List<ApplicationStatus> timelineOrder = [
    ApplicationStatus.applied,
    ApplicationStatus.underReview,
    ApplicationStatus.interview,
    ApplicationStatus.accepted,
  ];

  bool get isTerminal =>
      this == ApplicationStatus.accepted || this == ApplicationStatus.rejected;

  bool get canWithdraw => this == ApplicationStatus.applied;
}
