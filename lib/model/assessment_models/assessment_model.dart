import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/model/assessment_models/assessment_question_model.dart';


part 'assessment_model.mapper.dart';

@MappableClass()
class AssessmentModel with AssessmentModelMappable {
  @MappableField(key: 'id')
  final String assessmentId;

  @MappableField(key: 'created_at')
  final String createdAt;

  @MappableField(key: 'name')
  final String name;

  @MappableField(key: 'description')
  final String description;

  @MappableField(key: 'category')
  final String category;

  @MappableField(key: 'cutoff_score')
  final int cutoffScore;

  @MappableField(key: 'image_url')
  final String imageUrl;

  @MappableField(key: 'questions')
  final List<AssessmentQuestionModel> questions;

  AssessmentModel({
    required this.assessmentId,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.category,
    required this.cutoffScore,
    required this.questions,
    required this.imageUrl,
  });
  
}