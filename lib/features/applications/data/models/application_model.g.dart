// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    _ApplicationModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      opportunityId: json['opportunityId'] as String,
      startupId: json['startupId'] as String,
      status: json['status'] as String? ?? 'applied',
      coverLetter: json['coverLetter'] as String?,
      resumeUrl: json['resumeUrl'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$ApplicationModelToJson(_ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'opportunityId': instance.opportunityId,
      'startupId': instance.startupId,
      'status': instance.status,
      'coverLetter': instance.coverLetter,
      'resumeUrl': instance.resumeUrl,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
