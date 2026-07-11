import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venture_link/core/utils/timestamp_converter.dart';
import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';

part 'application_model.freezed.dart';
part 'application_model.g.dart';

@freezed
abstract class ApplicationModel with _$ApplicationModel {
  const ApplicationModel._();

  const factory ApplicationModel({
    required String id,
    required String studentId,
    required String opportunityId,
    required String startupId,
    @Default('applied') String status,
    String? coverLetter,
    String? resumeUrl,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _ApplicationModel;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(json);

  factory ApplicationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ApplicationModel.fromJson({...data, 'id': doc.id});
  }

  ApplicationEntity toEntity({
    String? opportunityTitle,
    String? startupName,
  }) {
    return ApplicationEntity(
      id: id,
      studentId: studentId,
      opportunityId: opportunityId,
      startupId: startupId,
      status: ApplicationStatus.fromString(status),
      coverLetter: coverLetter,
      resumeUrl: resumeUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      opportunityTitle: opportunityTitle,
      startupName: startupName,
    );
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}
