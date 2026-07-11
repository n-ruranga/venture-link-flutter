import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';

/// Seeds sample opportunities into Firestore for local development.
/// Call once from debug tooling or a temporary admin action.
abstract final class FirestoreOpportunitySeed {
  static Future<void> seedSampleOpportunities(FirebaseFirestore firestore) async {
    final collection = firestore.collection('opportunities');
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    final samples = [
      _sample(
        id: 'opp-flutter-intern',
        title: 'Flutter Developer Intern',
        startupId: 'startup-campuspay',
        startupName: 'CampusPay ALU',
        skills: ['Flutter', 'Firebase', 'Dart'],
        location: 'Kigali, Rwanda',
        workMode: WorkMode.hybrid,
        category: OpportunityCategory.engineering,
        hoursPerWeek: '10-15 hrs/week',
        daysFromNowDeadline: 30,
        daysAgoCreated: 1,
        isVerified: true,
        now: now,
      ),
      _sample(
        id: 'opp-ux-research',
        title: 'UX Research Volunteer',
        startupId: 'startup-edubridge',
        startupName: 'EduBridge Africa',
        skills: ['UX Design', 'Research', 'Figma'],
        location: 'Remote',
        workMode: WorkMode.remote,
        category: OpportunityCategory.design,
        hoursPerWeek: '4-6 hrs/week',
        daysFromNowDeadline: 21,
        daysAgoCreated: 2,
        isVerified: true,
        now: now,
      ),
      _sample(
        id: 'opp-marketing',
        title: 'Growth Marketing Intern',
        startupId: 'startup-agrilink',
        startupName: 'AgriLink Rwanda',
        skills: ['Marketing', 'Social Media', 'Content'],
        location: 'Kigali, Rwanda',
        workMode: WorkMode.onCampus,
        category: OpportunityCategory.marketing,
        hoursPerWeek: '8-10 hrs/week',
        daysFromNowDeadline: 25,
        daysAgoCreated: 3,
        isVerified: true,
        now: now,
      ),
      _sample(
        id: 'opp-data-analyst',
        title: 'Data Analytics Intern',
        startupId: 'startup-insightalu',
        startupName: 'InsightALU',
        skills: ['Python', 'SQL', 'Analytics'],
        location: 'Kigali, Rwanda',
        workMode: WorkMode.remote,
        category: OpportunityCategory.data,
        hoursPerWeek: '10-12 hrs/week',
        daysFromNowDeadline: 28,
        daysAgoCreated: 1,
        isVerified: true,
        now: now,
      ),
    ];

    final batch = firestore.batch();
    for (final sample in samples) {
      batch.set(collection.doc(sample['id'] as String), sample['data']);
    }
    await batch.commit();
  }

  static Map<String, Object> _sample({
    required String id,
    required String title,
    required String startupId,
    required String startupName,
    required List<String> skills,
    required String location,
    required WorkMode workMode,
    required OpportunityCategory category,
    required String hoursPerWeek,
    required int daysFromNowDeadline,
    required int daysAgoCreated,
    required bool isVerified,
    required DateTime now,
  }) {
    final createdAt = now.subtract(Duration(days: daysAgoCreated));
    return {
      'id': id,
      'data': {
        'title': title,
        'description':
            'Join $startupName through VentureLink and gain hands-on experience while contributing to the ALU startup ecosystem.',
        'startupId': startupId,
        'startupName': startupName,
        'skills': skills,
        'location': location,
        'workMode': workMode.name,
        'category': category.name,
        'hoursPerWeek': hoursPerWeek,
        'deadline': Timestamp.fromDate(
          now.add(Duration(days: daysFromNowDeadline)),
        ),
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(createdAt),
        'status': 'active',
        'isVerified': isVerified,
      },
    };
  }
}
