import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/model/assessment_models/assessment_models.dart';

part 'assessment_option_entity.mapper.dart';

@MappableClass()
class AssessmentOptionEntity with AssessmentOptionEntityMappable {

  @MappableField(key: 'option_id')
  final String optionId;

  @MappableField(key: 'text')
  final String text;

  @MappableField(key: 'score')
  final int score;

  AssessmentOptionEntity({
    required this.optionId,
    required this.text,
    required this.score,
  });

  AssessmentOptionModel toModel() {
    return AssessmentOptionModel(
      optionId: optionId,
      text: text,
      score: score,
    );
  }

}