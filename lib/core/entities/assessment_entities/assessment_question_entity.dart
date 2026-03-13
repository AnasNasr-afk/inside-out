import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/core/entities/assessment_entities/assessment_option_entity.dart';
import 'package:patient/model/assessment_models/assessment_models.dart';

part 'assessment_question_entity.mapper.dart';

@MappableClass()
class AssessmentQuestionEntity with AssessmentQuestionEntityMappable {

  @MappableField(key: 'question_id')
  final String questionId;

  @MappableField(key: 'text')
  final String text;

  @MappableField(key: 'options')
  final List<AssessmentOptionEntity> options;

  AssessmentQuestionEntity({
    required this.questionId,
    required this.text,
    required this.options,
  });

  AssessmentQuestionModel toModel() {
    return AssessmentQuestionModel(
      questionId: questionId,
      text: text,
      options: options.map((e) => e.toModel()).toList(),
    );
  }

}