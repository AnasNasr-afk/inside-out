import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/core/entities/assessment_entities/assessment_question_answer_entity.dart';

part 'assessment_question_answer_model.mapper.dart';

@MappableClass()
class AssessmentQuestionAnswerModel with AssessmentQuestionAnswerModelMappable {

  @MappableField(key: 'question_id')
  final String questionId;

  @MappableField(key: 'answer_id')
  final String answerId;

  AssessmentQuestionAnswerModel({
    required this.questionId,
    required this.answerId,
  });

  AssessmentQuestionAnswerEntity toEntity() {
    return AssessmentQuestionAnswerEntity(
      questionId: questionId,
      answerId: answerId,
    );
  }

}