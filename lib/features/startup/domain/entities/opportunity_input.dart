import 'package:equatable/equatable.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';

class OpportunityInput extends Equatable {
  const OpportunityInput({
    required this.title,
    required this.description,
    required this.skills,
    required this.location,
    required this.workMode,
    required this.category,
    required this.hoursPerWeek,
    required this.deadline,
  });

  final String title;
  final String description;
  final List<String> skills;
  final String location;
  final WorkMode workMode;
  final OpportunityCategory category;
  final String hoursPerWeek;
  final DateTime deadline;

  @override
  List<Object?> get props => [
        title,
        description,
        skills,
        location,
        workMode,
        category,
        hoursPerWeek,
        deadline,
      ];
}
