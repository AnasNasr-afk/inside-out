import 'package:dart_mappable/dart_mappable.dart';

import 'assessment_question_answer_entity.dart';

part 'assessment_answer_entity.mapper.dart';

@MappableClass()
class AssessmentAnswerEntity with AssessmentAnswerEntityMappable {

  @MappableField(key: 'patient_id')
  final String? patientId;

  @MappableField(key: 'assessment_id')
  final String assessmentId;

  @MappableField(key: 'questions')
  final List<AssessmentQuestionAnswerEntity> questions;

  AssessmentAnswerEntity({
    this.patientId,
    required this.assessmentId,
    required this.questions,
  });

}