import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/core/core.dart';

part 'consultation_request_model.mapper.dart';

@MappableClass()
class ConsultationRequestModel with ConsultationRequestModelMappable {

  @MappableField(key: 'timestamp')
  final DateTime? timestamp;

  @MappableField(key: 'therapist_id')
  final String? therapistId;

  @MappableField(key: 'patient_id')
  final String? patientId;

  @MappableField(key: 'is_consultation')
  final bool? isConsultation;

  @MappableField(key: 'mode')
  final int? mode;

  @MappableField(key: 'duration')
  final int? duration;

  @MappableField(key: 'name')
  final String? name;

  @MappableField(key: 'status')
  final String? status;


  ConsultationRequestModel({
    this.timestamp,
    this.therapistId,
    this.patientId,
    this.isConsultation,
    this.mode,
    this.duration,
    this.name,
    this.status,
  });

  ConsultationRequestEntity toEntity() {
    return ConsultationRequestEntity(
      timestamp: timestamp!.toIso8601String(),
      therapistId: therapistId,
      patientId: patientId,
      isConsultation: isConsultation,
      mode: mode,
      duration: duration,
      name: name,
      status: status,
    );
  }

}