import 'package:equatable/equatable.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';

class OpportunityEntity extends Equatable {
  const OpportunityEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startupId,
    required this.startupName,
    required this.skills,
    required this.location,
    required this.workMode,
    required this.category,
    required this.hoursPerWeek,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.isVerified,
    this.startupLogoUrl = '',
  });

  final String id;
  final String title;
  final String description;
  final String startupId;
  final String startupName;
  final List<String> skills;
  final String location;
  final WorkMode workMode;
  final OpportunityCategory category;
  final String hoursPerWeek;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final bool isVerified;
  final String startupLogoUrl;

  int get startupColor => startupId.hashCode & 0xFFFFFF | 0xFF000000;

  bool get isActive => status == 'active';

  bool get isFeatured => isVerified && postedDaysAgo <= 7;

  int get postedDaysAgo {
    final difference = DateTime.now().difference(createdAt).inDays;
    return difference < 0 ? 0 : difference;
  }

  String get postedLabel {
    if (postedDaysAgo == 0) {
      return 'Posted today';
    }
    if (postedDaysAgo == 1) {
      return 'Posted 1d ago';
    }
    return 'Posted ${postedDaysAgo}d ago';
  }

  String get hoursLabel {
    if (hoursPerWeek.contains('hr')) {
      return hoursPerWeek;
    }
    return '$hoursPerWeek hrs/week';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startupId,
        startupName,
        skills,
        location,
        workMode,
        category,
        hoursPerWeek,
        deadline,
        createdAt,
        updatedAt,
        status,
        isVerified,
        startupLogoUrl,
      ];
}

class OpportunitiesSnapshot extends Equatable {
  const OpportunitiesSnapshot({
    required this.opportunities,
    this.isFromCache = false,
    this.hasPendingWrites = false,
  });

  final List<OpportunityEntity> opportunities;
  final bool isFromCache;
  final bool hasPendingWrites;

  bool get isOffline => isFromCache;

  @override
  List<Object?> get props => [opportunities, isFromCache, hasPendingWrites];
}

class OpportunitySnapshot extends Equatable {
  const OpportunitySnapshot({
    this.opportunity,
    this.isFromCache = false,
    this.hasPendingWrites = false,
  });

  final OpportunityEntity? opportunity;
  final bool isFromCache;
  final bool hasPendingWrites;

  bool get isOffline => isFromCache;

  @override
  List<Object?> get props => [opportunity, isFromCache, hasPendingWrites];
}
