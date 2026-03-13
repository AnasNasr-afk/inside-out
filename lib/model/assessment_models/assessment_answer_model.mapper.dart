// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_answer_model.dart';

class AssessmentAnswerModelMapper
    extends ClassMapperBase<AssessmentAnswerModel> {
  AssessmentAnswerModelMapper._();

  static AssessmentAnswerModelMapper? _instance;
  static AssessmentAnswerModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentAnswerModelMapper._());
      AssessmentQuestionAnswerModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentAnswerModel';

  static String? _$patientId(AssessmentAnswerModel v) => v.patientId;
  static const Field<AssessmentAnswerModel, String> _f$patientId =
      Field('patientId', _$patientId, key: r'patient_id', opt: true);
  static String _$assessmentId(AssessmentAnswerModel v) => v.assessmentId;
  static const Field<AssessmentAnswerModel, String> _f$assessmentId =
      Field('assessmentId', _$assessmentId, key: r'assessment_id');
  static List<AssessmentQuestionAnswerModel> _$questions(
          AssessmentAnswerModel v) =>
      v.questions;
  static const Field<AssessmentAnswerModel, List<AssessmentQuestionAnswerModel>>
      _f$questions = Field('questions', _$questions);

  @override
  final MappableFields<AssessmentAnswerModel> fields = const {
    #patientId: _f$patientId,
    #assessmentId: _f$assessmentId,
    #questions: _f$questions,
  };

  static AssessmentAnswerModel _instantiate(DecodingData data) {
    return AssessmentAnswerModel(
        patientId: data.dec(_f$patientId),
        assessmentId: data.dec(_f$assessmentId),
        questions: data.dec(_f$questions));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentAnswerModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentAnswerModel>(map);
  }

  static AssessmentAnswerModel fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentAnswerModel>(json);
  }
}

mixin AssessmentAnswerModelMappable {
  String toJson() {
    return AssessmentAnswerModelMapper.ensureInitialized()
        .encodeJson<AssessmentAnswerModel>(this as AssessmentAnswerModel);
  }

  Map<String, dynamic> toMap() {
    return AssessmentAnswerModelMapper.ensureInitialized()
        .encodeMap<AssessmentAnswerModel>(this as AssessmentAnswerModel);
  }

  AssessmentAnswerModelCopyWith<AssessmentAnswerModel, AssessmentAnswerModel,
      AssessmentAnswerModel> get copyWith => _AssessmentAnswerModelCopyWithImpl<
          AssessmentAnswerModel, AssessmentAnswerModel>(
      this as AssessmentAnswerModel, $identity, $identity);
  @override
  String toString() {
    return AssessmentAnswerModelMapper.ensureInitialized()
        .stringifyValue(this as AssessmentAnswerModel);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentAnswerModelMapper.ensureInitialized()
        .equalsValue(this as AssessmentAnswerModel, other);
  }

  @override
  int get hashCode {
    return AssessmentAnswerModelMapper.ensureInitialized()
        .hashValue(this as AssessmentAnswerModel);
  }
}

extension AssessmentAnswerModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentAnswerModel, $Out> {
  AssessmentAnswerModelCopyWith<$R, AssessmentAnswerModel, $Out>
      get $asAssessmentAnswerModel => $base.as(
          (v, t, t2) => _AssessmentAnswerModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AssessmentAnswerModelCopyWith<
    $R,
    $In extends AssessmentAnswerModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      AssessmentQuestionAnswerModel,
      AssessmentQuestionAnswerModelCopyWith<$R, AssessmentQuestionAnswerModel,
          AssessmentQuestionAnswerModel>> get questions;
  $R call(
      {String? patientId,
      String? assessmentId,
      List<AssessmentQuestionAnswerModel>? questions});
  AssessmentAnswerModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentAnswerModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentAnswerModel, $Out>
    implements AssessmentAnswerModelCopyWith<$R, AssessmentAnswerModel, $Out> {
  _AssessmentAnswerModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentAnswerModel> $mapper =
      AssessmentAnswerModelMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      AssessmentQuestionAnswerModel,
      AssessmentQuestionAnswerModelCopyWith<$R, AssessmentQuestionAnswerModel,
          AssessmentQuestionAnswerModel>> get questions => ListCopyWith(
      $value.questions,
      (v, t) => v.copyWith.$chain(t),
      (v) => call(questions: v));
  @override
  $R call(
          {Object? patientId = $none,
          String? assessmentId,
          List<AssessmentQuestionAnswerModel>? questions}) =>
      $apply(FieldCopyWithData({
        if (patientId != $none) #patientId: patientId,
        if (assessmentId != null) #assessmentId: assessmentId,
        if (questions != null) #questions: questions
      }));
  @override
  AssessmentAnswerModel $make(CopyWithData data) => AssessmentAnswerModel(
      patientId: data.get(#patientId, or: $value.patientId),
      assessmentId: data.get(#assessmentId, or: $value.assessmentId),
      questions: data.get(#questions, or: $value.questions));

  @override
  AssessmentAnswerModelCopyWith<$R2, AssessmentAnswerModel, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentAnswerModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
