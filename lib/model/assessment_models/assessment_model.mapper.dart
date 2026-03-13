// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_model.dart';

class AssessmentModelMapper extends ClassMapperBase<AssessmentModel> {
  AssessmentModelMapper._();

  static AssessmentModelMapper? _instance;
  static AssessmentModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentModelMapper._());
      AssessmentQuestionModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentModel';

  static String _$assessmentId(AssessmentModel v) => v.assessmentId;
  static const Field<AssessmentModel, String> _f$assessmentId =
      Field('assessmentId', _$assessmentId, key: r'id');
  static String _$createdAt(AssessmentModel v) => v.createdAt;
  static const Field<AssessmentModel, String> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$name(AssessmentModel v) => v.name;
  static const Field<AssessmentModel, String> _f$name = Field('name', _$name);
  static String _$description(AssessmentModel v) => v.description;
  static const Field<AssessmentModel, String> _f$description =
      Field('description', _$description);
  static String _$category(AssessmentModel v) => v.category;
  static const Field<AssessmentModel, String> _f$category =
      Field('category', _$category);
  static int _$cutoffScore(AssessmentModel v) => v.cutoffScore;
  static const Field<AssessmentModel, int> _f$cutoffScore =
      Field('cutoffScore', _$cutoffScore, key: r'cutoff_score');
  static List<AssessmentQuestionModel> _$questions(AssessmentModel v) =>
      v.questions;
  static const Field<AssessmentModel, List<AssessmentQuestionModel>>
      _f$questions = Field('questions', _$questions);
  static String _$imageUrl(AssessmentModel v) => v.imageUrl;
  static const Field<AssessmentModel, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, key: r'image_url');

  @override
  final MappableFields<AssessmentModel> fields = const {
    #assessmentId: _f$assessmentId,
    #createdAt: _f$createdAt,
    #name: _f$name,
    #description: _f$description,
    #category: _f$category,
    #cutoffScore: _f$cutoffScore,
    #questions: _f$questions,
    #imageUrl: _f$imageUrl,
  };

  static AssessmentModel _instantiate(DecodingData data) {
    return AssessmentModel(
        assessmentId: data.dec(_f$assessmentId),
        createdAt: data.dec(_f$createdAt),
        name: data.dec(_f$name),
        description: data.dec(_f$description),
        category: data.dec(_f$category),
        cutoffScore: data.dec(_f$cutoffScore),
        questions: data.dec(_f$questions),
        imageUrl: data.dec(_f$imageUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentModel>(map);
  }

  static AssessmentModel fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentModel>(json);
  }
}

mixin AssessmentModelMappable {
  String toJson() {
    return AssessmentModelMapper.ensureInitialized()
        .encodeJson<AssessmentModel>(this as AssessmentModel);
  }

  Map<String, dynamic> toMap() {
    return AssessmentModelMapper.ensureInitialized()
        .encodeMap<AssessmentModel>(this as AssessmentModel);
  }

  AssessmentModelCopyWith<AssessmentModel, AssessmentModel, AssessmentModel>
      get copyWith => _AssessmentModelCopyWithImpl(
          this as AssessmentModel, $identity, $identity);
  @override
  String toString() {
    return AssessmentModelMapper.ensureInitialized()
        .stringifyValue(this as AssessmentModel);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentModelMapper.ensureInitialized()
        .equalsValue(this as AssessmentModel, other);
  }

  @override
  int get hashCode {
    return AssessmentModelMapper.ensureInitialized()
        .hashValue(this as AssessmentModel);
  }
}

extension AssessmentModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentModel, $Out> {
  AssessmentModelCopyWith<$R, AssessmentModel, $Out> get $asAssessmentModel =>
      $base.as((v, t, t2) => _AssessmentModelCopyWithImpl(v, t, t2));
}

abstract class AssessmentModelCopyWith<$R, $In extends AssessmentModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      AssessmentQuestionModel,
      AssessmentQuestionModelCopyWith<$R, AssessmentQuestionModel,
          AssessmentQuestionModel>> get questions;
  $R call(
      {String? assessmentId,
      String? createdAt,
      String? name,
      String? description,
      String? category,
      int? cutoffScore,
      List<AssessmentQuestionModel>? questions,
      String? imageUrl});
  AssessmentModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentModel, $Out>
    implements AssessmentModelCopyWith<$R, AssessmentModel, $Out> {
  _AssessmentModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentModel> $mapper =
      AssessmentModelMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      AssessmentQuestionModel,
      AssessmentQuestionModelCopyWith<$R, AssessmentQuestionModel,
          AssessmentQuestionModel>> get questions => ListCopyWith(
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
          List<AssessmentQuestionModel>? questions,
          String? imageUrl}) =>
      $apply(FieldCopyWithData({
        if (assessmentId != null) #assessmentId: assessmentId,
        if (createdAt != null) #createdAt: createdAt,
        if (name != null) #name: name,
        if (description != null) #description: description,
        if (category != null) #category: category,
        if (cutoffScore != null) #cutoffScore: cutoffScore,
        if (questions != null) #questions: questions,
        if (imageUrl != null) #imageUrl: imageUrl
      }));
  @override
  AssessmentModel $make(CopyWithData data) => AssessmentModel(
      assessmentId: data.get(#assessmentId, or: $value.assessmentId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      name: data.get(#name, or: $value.name),
      description: data.get(#description, or: $value.description),
      category: data.get(#category, or: $value.category),
      cutoffScore: data.get(#cutoffScore, or: $value.cutoffScore),
      questions: data.get(#questions, or: $value.questions),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl));

  @override
  AssessmentModelCopyWith<$R2, AssessmentModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AssessmentModelCopyWithImpl($value, $cast, t);
}
