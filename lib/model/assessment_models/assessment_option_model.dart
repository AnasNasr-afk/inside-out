import 'package:dart_mappable/dart_mappable.dart';

part 'assessment_option_model.mapper.dart';

@MappableClass()
class AssessmentOptionModel with AssessmentOptionModelMappable {

  @MappableField(key: 'option_id')
  final String optionId;

  @MappableField(key: 'text')
  final String text;

  @MappableField(key: 'score')
  final int score;

  AssessmentOptionModel({
    required this.optionId,
    required this.text,
    required this.score,
  });

}