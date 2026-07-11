import 'package:equatable/equatable.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';

class OpportunityEntity extends Equatable {
  const OpportunityEntity({
    required this.id,
    required this.title,
    required this.startupName,
    required this.startupLogoUrl,
    required this.startupColor,
    required this.category,
    required this.location,
    required this.workMode,
    required this.weeklyHours,
    required this.tags,
    required this.description,
    required this.postedDaysAgo,
    this.isFeatured = false,
    this.isPaid = false,
  });

  final String id;
  final String title;
  final String startupName;
  final String startupLogoUrl;
  final int startupColor;
  final OpportunityCategory category;
  final String location;
  final WorkMode workMode;
  final String weeklyHours;
  final List<String> tags;
  final String description;
  final int postedDaysAgo;
  final bool isFeatured;
  final bool isPaid;

  String get postedLabel {
    if (postedDaysAgo == 0) {
      return 'Posted today';
    }
    if (postedDaysAgo == 1) {
      return 'Posted 1d ago';
    }
    return 'Posted ${postedDaysAgo}d ago';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        startupName,
        startupLogoUrl,
        startupColor,
        category,
        location,
        workMode,
        weeklyHours,
        tags,
        description,
        postedDaysAgo,
        isFeatured,
        isPaid,
      ];
}
