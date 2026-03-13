
import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/model/assessment_models/assessment_option_model.dart';

part 'assessment_question_model.mapper.dart';


@MappableClass()
class AssessmentQuestionModel with AssessmentQuestionModelMappable {

  @MappableField(key: 'question_id')
  final String questionId;

  @MappableField(key: 'text')
  final String text;

  @MappableField(key: 'options')
  final List<AssessmentOptionModel> options;

  AssessmentQuestionModel({
    required this.questionId,
    required this.text,
    required this.options,
  });

}