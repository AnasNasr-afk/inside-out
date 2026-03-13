// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_entity.dart';

class AssessmentEntityMapper extends ClassMapperBase<AssessmentEntity> {
  AssessmentEntityMapper._();

  static AssessmentEntityMapper? _instance;
  static AssessmentEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentEntityMapper._());
      AssessmentQuestionEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentEntity';

  static String _$assessmentId(AssessmentEntity v) => v.assessmentId;
  static const Field<AssessmentEntity, String> _f$assessmentId =
      Field('assessmentId', _$assessmentId, key: r'id');
  static String _$createdAt(AssessmentEntity v) => v.createdAt;
  static const Field<AssessmentEntity, String> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$name(AssessmentEntity v) => v.name;
  static const Field<AssessmentEntity, String> _f$name = Field('name', _$name);
  static String _$description(AssessmentEntity v) => v.description;
  static const Field<AssessmentEntity, String> _f$description =
      Field('description', _$description);
  static String _$category(AssessmentEntity v) => v.category;
  static const Field<AssessmentEntity, String> _f$category =
      Field('category', _$category);
  static int _$cutoffScore(AssessmentEntity v) => v.cutoffScore;
  static const Field<AssessmentEntity, int> _f$cutoffScore =
      Field('cutoffScore', _$cutoffScore, key: r'cutoff_score');
  static String _$imageUrl(AssessmentEntity v) => v.imageUrl;
  static const Field<AssessmentEntity, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, key: r'image_url');
  static List<AssessmentQuestionEntity> _$questions(AssessmentEntity v) =>
      v.questions;
  static const Field<AssessmentEntity, List<AssessmentQuestionEntity>>
      _f$questions = Field('questions', _$questions);

  @override
  final MappableFields<AssessmentEntity> fields = const {
    #assessmentId: _f$assessmentId,
    #createdAt: _f$createdAt,
    #name: _f$name,
    #description: _f$description,
    #category: _f$category,
    #cutoffScore: _f$cutoffScore,
    #imageUrl: _f$imageUrl,
    #questions: _f$questions,
  };

  static AssessmentEntity _instantiate(DecodingData data) {
    return AssessmentEntity(
        assessmentId: data.dec(_f$assessmentId),
        createdAt: data.dec(_f$createdAt),
        name: data.dec(_f$name),
        description: data.dec(_f$description),
        category: data.dec(_f$category),
        cutoffScore: data.dec(_f$cutoffScore),
        imageUrl: data.dec(_f$imageUrl),
        questions: data.dec(_f$questions));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentEntity>(map);
  }

  static AssessmentEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentEntity>(json);
  }
}

mixin AssessmentEntityMappable {
  String toJson() {
    return AssessmentEntityMapper.ensureInitialized()
        .encodeJson<AssessmentEntity>(this as AssessmentEntity);
  }

  Map<String, dynamic> toMap() {
    return AssessmentEntityMapper.ensureInitialized()
        .encodeMap<AssessmentEntity>(this as AssessmentEntity);
  }

  AssessmentEntityCopyWith<AssessmentEntity, AssessmentEntity, AssessmentEntity>
      get copyWith => _AssessmentEntityCopyWithImpl(
          this as AssessmentEntity, $identity, $identity);
  @override
  String toString() {
    return AssessmentEntityMapper.ensureInitialized()
        .stringifyValue(this as AssessmentEntity);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentEntityMapper.ensureInitialized()
        .equalsValue(this as AssessmentEntity, other);
  }

  @override
  int get hashCode {
    return AssessmentEntityMapper.ensureInitialized()
        .hashValue(this as AssessmentEntity);
  }
}

extension AssessmentEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentEntity, $Out> {
  AssessmentEntityCopyWith<$R, AssessmentEntity, $Out>
      get $asAssessmentEntity =>
          $base.as((v, t, t2) => _AssessmentEntityCopyWithImpl(v, t, t2));
}

abstract class AssessmentEntityCopyWith<$R, $In extends AssessmentEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      AssessmentQuestionEntity,
      AssessmentQuestionEntityCopyWith<$R, AssessmentQuestionEntity,
          AssessmentQuestionEntity>> get questions;
  $R call(
      {String? assessmentId,
      String? createdAt,
      String? name,
      String? description,
      String? category,
      int? cutoffScore,
      String? imageUrl,
      List<AssessmentQuestionEntity>? questions});
  AssessmentEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentEntity, $Out>
    implements AssessmentEntityCopyWith<$R, AssessmentEntity, $Out> {
  _AssessmentEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentEntity> $mapper =
      AssessmentEntityMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      AssessmentQuestionEntity,
      AssessmentQuestionEntityCopyWith<$R, AssessmentQuestionEntity,
          AssessmentQuestionEntity>> get questions => ListCopyWith(
      $value.questions,
      (v, t) => v.copyWith.$chain(t),
      (v) => call(questions: v));
  @override
  $R call(
          {String? assessmentId,
          String? createdAt,
          String? name,
          String? description,
          String? category,
          int? cutoffScore,
          String? imageUrl,
          List<AssessmentQuestionEntity>? questions}) =>
      $apply(FieldCopyWithData({
        if (assessmentId != null) #assessmentId: assessmentId,
        if (createdAt != null) #createdAt: createdAt,
        if (name != null) #name: name,
        if (description != null) #description: description,
        if (category != null) #category: category,
        if (cutoffScore != null) #cutoffScore: cutoffScore,
        if (imageUrl != null) #imageUrl: imageUrl,
        if (questions != null) #questions: questions
      }));
  @override
  AssessmentEntity $make(CopyWithData data) => AssessmentEntity(
      assessmentId: data.get(#assessmentId, or: $value.assessmentId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      name: data.get(#name, or: $value.name),
      description: data.get(#description, or: $value.description),
      category: data.get(#category, or: $value.category),
      cutoffScore: data.get(#cutoffScore, or: $value.cutoffScore),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      questions: data.get(#questions, or: $value.questions));

  @override
  AssessmentEntityCopyWith<$R2, AssessmentEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AssessmentEntityCopyWithImpl($value, $cast, t);
}
