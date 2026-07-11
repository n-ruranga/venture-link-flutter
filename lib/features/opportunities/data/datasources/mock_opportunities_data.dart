import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';

abstract final class MockOpportunitiesData {
  static const List<OpportunityEntity> opportunities = [
    OpportunityEntity(
      id: 'opp-1',
      title: 'Flutter Developer Intern',
      startupName: 'CampusPay ALU',
      startupLogoUrl: '',
      startupColor: 0xFF6C63FF,
      category: OpportunityCategory.engineering,
      location: 'Kigali, Rwanda',
      workMode: WorkMode.hybrid,
      weeklyHours: '10-15 hrs/week',
      tags: ['Flutter', 'Firebase', 'Dart'],
      description:
          'Join CampusPay to build mobile payment solutions for the ALU campus ecosystem. You will work on Flutter features, integrate Firebase, and collaborate with a student-led engineering team.',
      postedDaysAgo: 1,
      isFeatured: true,
      isPaid: true,
    ),
    OpportunityEntity(
      id: 'opp-2',
      title: 'UX Research Volunteer',
      startupName: 'EduBridge Africa',
      startupLogoUrl: '',
      startupColor: 0xFFEC4899,
      category: OpportunityCategory.design,
      location: 'Remote',
      workMode: WorkMode.remote,
      weeklyHours: '4-6 hrs/week',
      tags: ['UX Design', 'Research', 'Figma'],
      description:
          'Help EduBridge improve learning experiences for ALU students through user interviews, usability testing, and research synthesis.',
      postedDaysAgo: 2,
      isFeatured: true,
    ),
    OpportunityEntity(
      id: 'opp-3',
      title: 'Growth Marketing Intern',
      startupName: 'AgriLink Rwanda',
      startupLogoUrl: '',
      startupColor: 0xFF10B981,
      category: OpportunityCategory.marketing,
      location: 'Kigali, Rwanda',
      workMode: WorkMode.onCampus,
      weeklyHours: '8-10 hrs/week',
      tags: ['Marketing', 'Social Media', 'Content'],
      description:
          'Drive awareness for AgriLink among ALU students and local farming communities. Create campaigns, manage social channels, and track growth metrics.',
      postedDaysAgo: 3,
      isFeatured: true,
    ),
    OpportunityEntity(
      id: 'opp-4',
      title: 'Financial Analyst Intern',
      startupName: 'VentureNest',
      startupLogoUrl: '',
      startupColor: 0xFF0EA5E9,
      category: OpportunityCategory.finance,
      location: 'Kigali, Rwanda',
      workMode: WorkMode.hybrid,
      weeklyHours: '12 hrs/week',
      tags: ['Finance', 'Excel', 'Modeling'],
      description:
          'Support VentureNest with financial modeling, budgeting, and investor reporting for early-stage ALU startups.',
      postedDaysAgo: 4,
      isPaid: true,
    ),
    OpportunityEntity(
      id: 'opp-5',
      title: 'Research Assistant',
      startupName: 'HealthBridge ALU',
      startupLogoUrl: '',
      startupColor: 0xFF8B5CF6,
      category: OpportunityCategory.research,
      location: 'On-campus',
      workMode: WorkMode.onCampus,
      weeklyHours: '6-8 hrs/week',
      tags: ['Research', 'Healthcare', 'Data Collection'],
      description:
          'Assist HealthBridge with literature reviews, survey design, and field research on student wellness initiatives.',
      postedDaysAgo: 5,
    ),
    OpportunityEntity(
      id: 'opp-6',
      title: 'Operations Coordinator',
      startupName: 'LogiFlow',
      startupLogoUrl: '',
      startupColor: 0xFF64748B,
      category: OpportunityCategory.operations,
      location: 'Kigali, Rwanda',
      workMode: WorkMode.hybrid,
      weeklyHours: '10 hrs/week',
      tags: ['Operations', 'Logistics', 'Coordination'],
      description:
          'Help LogiFlow streamline delivery operations and coordinate between ALU campus partners and local vendors.',
      postedDaysAgo: 2,
    ),
    OpportunityEntity(
      id: 'opp-7',
      title: 'Business Development Intern',
      startupName: 'GreenLoop',
      startupLogoUrl: '',
      startupColor: 0xFF22C55E,
      category: OpportunityCategory.business,
      location: 'Remote',
      workMode: WorkMode.remote,
      weeklyHours: '8 hrs/week',
      tags: ['Business Dev', 'Partnerships', 'Sales'],
      description:
          'Identify partnership opportunities and support outreach for GreenLoop\'s sustainability initiatives across ALU.',
      postedDaysAgo: 6,
    ),
    OpportunityEntity(
      id: 'opp-8',
      title: 'Data Analytics Intern',
      startupName: 'InsightALU',
      startupLogoUrl: '',
      startupColor: 0xFF14B8A6,
      category: OpportunityCategory.data,
      location: 'Kigali, Rwanda',
      workMode: WorkMode.remote,
      weeklyHours: '10-12 hrs/week',
      tags: ['Python', 'SQL', 'Analytics'],
      description:
          'Build dashboards and analyze user data to help InsightALU deliver actionable insights to student startups.',
      postedDaysAgo: 1,
      isPaid: true,
    ),
    OpportunityEntity(
      id: 'opp-9',
      title: 'Social Media Assistant',
      startupName: 'GreenLoop',
      startupLogoUrl: '',
      startupColor: 0xFF22C55E,
      category: OpportunityCategory.marketing,
      location: 'Kigali, Rwanda',
      workMode: WorkMode.onCampus,
      weeklyHours: '5-8 hrs/week',
      tags: ['Social Media', 'Content', 'Canva'],
      description:
          'Create engaging content and manage GreenLoop\'s social presence to reach ALU students passionate about sustainability.',
      postedDaysAgo: 3,
    ),
  ];

  static List<OpportunityEntity> get featured =>
      opportunities.where((o) => o.isFeatured).toList();

  static List<OpportunityEntity> get recent =>
      List<OpportunityEntity>.from(opportunities)
        ..sort((a, b) => a.postedDaysAgo.compareTo(b.postedDaysAgo));

  static OpportunityEntity? findById(String id) {
    try {
      return opportunities.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
