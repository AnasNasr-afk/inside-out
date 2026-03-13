
import 'package:dart_mappable/dart_mappable.dart';

part 'assessment_result_model.mapper.dart';

@MappableClass()
class AssessmentResultModel with AssessmentResultModelMappable {

  @MappableField(key: 'assessment_score')
  final int assessmentScore;

  @MappableField(key: 'is_autistic')
  final bool isAutistic;

  @MappableField(key: 'message')
  final String message;

  AssessmentResultModel({
    required this.assessmentScore,
    required this.isAutistic,
    required this.message,
  });

}