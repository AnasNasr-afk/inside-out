// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_answer_entity.dart';

class AssessmentAnswerEntityMapper
    extends ClassMapperBase<AssessmentAnswerEntity> {
  AssessmentAnswerEntityMapper._();

  static AssessmentAnswerEntityMapper? _instance;
  static AssessmentAnswerEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentAnswerEntityMapper._());
      AssessmentQuestionAnswerEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentAnswerEntity';

  static String? _$patientId(AssessmentAnswerEntity v) => v.patientId;
  static const Field<AssessmentAnswerEntity, String> _f$patientId =
      Field('patientId', _$patientId, key: r'patient_id', opt: true);
  static String _$assessmentId(AssessmentAnswerEntity v) => v.assessmentId;
  static const Field<AssessmentAnswerEntity, String> _f$assessmentId =
      Field('assessmentId', _$assessmentId, key: r'assessment_id');
  static List<AssessmentQuestionAnswerEntity> _$questions(
          AssessmentAnswerEntity v) =>
      v.questions;
  static const Field<AssessmentAnswerEntity,
          List<AssessmentQuestionAnswerEntity>> _f$questions =
      Field('questions', _$questions);

  @override
  final MappableFields<AssessmentAnswerEntity> fields = const {
    #patientId: _f$patientId,
    #assessmentId: _f$assessmentId,
    #questions: _f$questions,
  };

  static AssessmentAnswerEntity _instantiate(DecodingData data) {
    return AssessmentAnswerEntity(
        patientId: data.dec(_f$patientId),
        assessmentId: data.dec(_f$assessmentId),
        questions: data.dec(_f$questions));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentAnswerEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentAnswerEntity>(map);
  }

  static AssessmentAnswerEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentAnswerEntity>(json);
  }
}

mixin AssessmentAnswerEntityMappable {
  String toJson() {
    return AssessmentAnswerEntityMapper.ensureInitialized()
        .encodeJson<AssessmentAnswerEntity>(this as AssessmentAnswerEntity);
  }

  Map<String, dynamic> toMap() {
    return AssessmentAnswerEntityMapper.ensureInitialized()
        .encodeMap<AssessmentAnswerEntity>(this as AssessmentAnswerEntity);
  }

  AssessmentAnswerEntityCopyWith<AssessmentAnswerEntity, AssessmentAnswerEntity,
          AssessmentAnswerEntity>
      get copyWith => _AssessmentAnswerEntityCopyWithImpl<
              AssessmentAnswerEntity, AssessmentAnswerEntity>(
          this as AssessmentAnswerEntity, $identity, $identity);
  @override
  String toString() {
    return AssessmentAnswerEntityMapper.ensureInitialized()
        .stringifyValue(this as AssessmentAnswerEntity);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentAnswerEntityMapper.ensureInitialized()
        .equalsValue(this as AssessmentAnswerEntity, other);
  }

  @override
  int get hashCode {
    return AssessmentAnswerEntityMapper.ensureInitialized()
        .hashValue(this as AssessmentAnswerEntity);
  }
}

extension AssessmentAnswerEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentAnswerEntity, $Out> {
  AssessmentAnswerEntityCopyWith<$R, AssessmentAnswerEntity, $Out>
      get $asAssessmentAnswerEntity => $base.as((v, t, t2) =>
          _AssessmentAnswerEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AssessmentAnswerEntityCopyWith<
    $R,
    $In extends AssessmentAnswerEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      AssessmentQuestionAnswerEntity,
      AssessmentQuestionAnswerEntityCopyWith<$R, AssessmentQuestionAnswerEntity,
          AssessmentQuestionAnswerEntity>> get questions;
  $R call(
      {String? patientId,
      String? assessmentId,
      List<AssessmentQuestionAnswerEntity>? questions});
  AssessmentAnswerEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentAnswerEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentAnswerEntity, $Out>
    implements
        AssessmentAnswerEntityCopyWith<$R, AssessmentAnswerEntity, $Out> {
  _AssessmentAnswerEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentAnswerEntity> $mapper =
      AssessmentAnswerEntityMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      AssessmentQuestionAnswerEntity,
      AssessmentQuestionAnswerEntityCopyWith<$R, AssessmentQuestionAnswerEntity,
          AssessmentQuestionAnswerEntity>> get questions => ListCopyWith(
      $value.questions,
      (v, t) => v.copyWith.$chain(t),
      (v) => call(questions: v));
  @override
  $R call(
          {Object? patientId = $none,
          String? assessmentId,
          List<AssessmentQuestionAnswerEntity>? questions}) =>
      $apply(FieldCopyWithData({
        if (patientId != $none) #patientId: patientId,
        if (assessmentId != null) #assessmentId: assessmentId,
        if (questions != null) #questions: questions
      }));
  @override
  AssessmentAnswerEntity $make(CopyWithData data) => AssessmentAnswerEntity(
      patientId: data.get(#patientId, or: $value.patientId),
      assessmentId: data.get(#assessmentId, or: $value.assessmentId),
      questions: data.get(#questions, or: $value.questions));

  @override
  AssessmentAnswerEntityCopyWith<$R2, AssessmentAnswerEntity, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentAnswerEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
