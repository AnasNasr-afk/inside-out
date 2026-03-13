
import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/core/entities/assessment_entities/assessment_question_entity.dart';
import 'package:patient/model/assessment_models/assessment_models.dart';

part 'assessment_entity.mapper.dart';

@MappableClass()
class AssessmentEntity with AssessmentEntityMappable {

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
  final List<AssessmentQuestionEntity> questions;

  AssessmentEntity({
    required this.assessmentId,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.category,
    required this.cutoffScore,
    required this.imageUrl,
    required this.questions,
  });

  AssessmentModel toModel() {
    return AssessmentModel(
      assessmentId: assessmentId,
      createdAt: createdAt,
      name: name,
      description: description,
      category: category,
      cutoffScore: cutoffScore,
      imageUrl: imageUrl,
      questions: questions.map((e) => e.toModel()).toList(),
    );
  }

}