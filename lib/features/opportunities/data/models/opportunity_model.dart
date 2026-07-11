import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venture_link/core/utils/timestamp_converter.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_category.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';

part 'opportunity_model.freezed.dart';
part 'opportunity_model.g.dart';

@freezed
abstract class OpportunityModel with _$OpportunityModel {
  const OpportunityModel._();

  const factory OpportunityModel({
    required String id,
    required String title,
    required String description,
    required String startupId,
    required String startupName,
    @Default([]) List<String> skills,
    required String location,
    required String workMode,
    required String category,
    required String hoursPerWeek,
    @TimestampConverter() required DateTime deadline,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @Default('active') String status,
    @Default(false) bool isVerified,
  }) = _OpportunityModel;

  factory OpportunityModel.fromJson(Map<String, dynamic> json) =>
      _$OpportunityModelFromJson(json);

  factory OpportunityModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return OpportunityModel.fromJson({...data, 'id': doc.id});
  }

  OpportunityEntity toEntity() {
    return OpportunityEntity(
      id: id,
      title: title,
      description: description,
      startupId: startupId,
      startupName: startupName,
      skills: skills,
      location: location,
      workMode: _parseWorkMode(workMode),
      category: _parseCategory(category),
      hoursPerWeek: hoursPerWeek,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      isVerified: isVerified,
    );
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  static WorkMode _parseWorkMode(String value) {
    final normalized = value.toLowerCase().replaceAll('-', '');
    return WorkMode.values.firstWhere(
      (mode) =>
          mode.name.toLowerCase() == normalized ||
          mode.label.toLowerCase().replaceAll('-', '') == normalized,
      orElse: () => WorkMode.remote,
    );
  }

  static OpportunityCategory _parseCategory(String value) {
    final normalized = value.toLowerCase();
    return OpportunityCategory.values.firstWhere(
      (category) =>
          category.name.toLowerCase() == normalized ||
          category.label.toLowerCase() == normalized,
      orElse: () => OpportunityCategory.engineering,
    );
  }
}
