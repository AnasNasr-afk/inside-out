import 'package:dart_mappable/dart_mappable.dart';

part 'consultation_request_entity.mapper.dart';

@MappableClass()
class ConsultationRequestEntity with ConsultationRequestEntityMappable {

  @MappableField(key: 'timestamp')
  final String? timestamp;

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


  ConsultationRequestEntity({
    this.timestamp,
    this.therapistId,
    this.patientId,
    this.isConsultation,
    this.mode,
    this.duration,
    this.name,
    this.status,
  });

}