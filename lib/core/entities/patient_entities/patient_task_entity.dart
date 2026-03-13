import 'package:dart_mappable/dart_mappable.dart';

part 'patient_task_entity.mapper.dart';

@MappableClass()
class PatientTaskEntity with PatientTaskEntityMappable {

  @MappableField(key: 'title')
  final String title;

  @MappableField(key: 'is_completed')
  final bool isCompleted;
  
  @MappableField(key: 'date_assigned')
  final DateTime date;

  const PatientTaskEntity({
    required this.title,
    required this.isCompleted,
    required this.date,
  });

  static const fromMap = PatientTaskEntityMapper.fromMap;
  static const fromJson = PatientTaskEntityMapper.fromJson;
}
