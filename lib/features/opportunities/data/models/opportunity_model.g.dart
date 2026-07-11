// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpportunityModel _$OpportunityModelFromJson(Map<String, dynamic> json) =>
    _OpportunityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startupId: json['startupId'] as String,
      startupName: json['startupName'] as String,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String,
      workMode: json['workMode'] as String,
      category: json['category'] as String,
      hoursPerWeek: json['hoursPerWeek'] as String,
      deadline: const TimestampConverter().fromJson(json['deadline']),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      status: json['status'] as String? ?? 'active',
      isVerified: json['isVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$OpportunityModelToJson(_OpportunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startupId': instance.startupId,
      'startupName': instance.startupName,
      'skills': instance.skills,
      'location': instance.location,
      'workMode': instance.workMode,
      'category': instance.category,
      'hoursPerWeek': instance.hoursPerWeek,
      'deadline': const TimestampConverter().toJson(instance.deadline),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'status': instance.status,
      'isVerified': instance.isVerified,
    };
