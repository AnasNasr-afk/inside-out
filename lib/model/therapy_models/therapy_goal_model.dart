import 'package:dart_mappable/dart_mappable.dart';

import 'therapy_model.dart';


part 'therapy_goal_model.mapper.dart';

@MappableClass()
class TherapyGoalModel with TherapyGoalModelMappable {

  @MappableField(key: 'performed_on')
  final DateTime performedOn;

  @MappableField(key: 'therapist_id')
  final String? therapistId;

  @MappableField(key: 'therapy_type_id')
  final String therapyTypeId;

  @MappableField(key: 'goals')
  final List<TherapyModel> goals;

  @MappableField(key: 'observations')
  final List<TherapyModel> observations;

  @MappableField(key: 'regressions')
  final List<TherapyModel> regressions;

  @MappableField(key: 'activities')
  final List<TherapyModel> activities;

  @MappableField(key: 'duration')
  final int? duration;

  @MappableField(key: 'name')
  final String? therapistName;

  @MappableField(key: 'phone')
  final String? therapistPhone;

  @MappableField(key: 'email')
  final String? therapistEmail;

  @MappableField(key: 'therapy_type')
  final String? therapyType;

  @MappableField(key: 'therapy_mode')
  final int? therapyMode;

  @MappableField(key: 'specialization')
  final String? specialization;

  TherapyGoalModel({
    required this.performedOn,
    this.therapistId,
    required this.therapyTypeId,
    required this.goals,
    required this.observations,
    required this.regressions,
    required this.activities,
    this.duration,
    this.therapistName,
    this.therapistPhone,
    this.therapistEmail,
    this.therapyType,
    this.therapyMode,
    this.specialization,
  });

}