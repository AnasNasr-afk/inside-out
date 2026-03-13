import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/model/assessment_models/assessment_result_model.dart';

part 'assessment_result_entity.mapper.dart';

@MappableClass()
class AssessmentResultEntity with AssessmentResultEntityMappable {

  @MappableField(key: 'assessment_score')
  final int assessmentScore;

  @MappableField(key: 'is_autistic')
  final bool isAutistic;

  @MappableField(key: 'message')
  final String message;

  AssessmentResultEntity({
    required this.assessmentScore,
    required this.isAutistic,
    required this.message,
  });


  AssessmentResultModel toModel() {
    return AssessmentResultModel(
      assessmentScore: assessmentScore,
      isAutistic: isAutistic,
      message: message,
    );
  }

}