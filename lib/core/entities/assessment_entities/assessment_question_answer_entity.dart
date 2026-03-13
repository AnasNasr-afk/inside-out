import 'package:dart_mappable/dart_mappable.dart';

part 'assessment_question_answer_entity.mapper.dart';

@MappableClass()
class AssessmentQuestionAnswerEntity with AssessmentQuestionAnswerEntityMappable {

  @MappableField(key: 'question_id')
  final String questionId;

  @MappableField(key: 'answer_id')
  final String answerId;

  AssessmentQuestionAnswerEntity({
    required this.questionId,
    required this.answerId,
  });
}