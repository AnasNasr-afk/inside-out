// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_question_answer_entity.dart';

class AssessmentQuestionAnswerEntityMapper
    extends ClassMapperBase<AssessmentQuestionAnswerEntity> {
  AssessmentQuestionAnswerEntityMapper._();

  static AssessmentQuestionAnswerEntityMapper? _instance;
  static AssessmentQuestionAnswerEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AssessmentQuestionAnswerEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentQuestionAnswerEntity';

  static String _$questionId(AssessmentQuestionAnswerEntity v) => v.questionId;
  static const Field<AssessmentQuestionAnswerEntity, String> _f$questionId =
      Field('questionId', _$questionId, key: r'question_id');
  static String _$answerId(AssessmentQuestionAnswerEntity v) => v.answerId;
  static const Field<AssessmentQuestionAnswerEntity, String> _f$answerId =
      Field('answerId', _$answerId, key: r'answer_id');

  @override
  final MappableFields<AssessmentQuestionAnswerEntity> fields = const {
    #questionId: _f$questionId,
    #answerId: _f$answerId,
  };

  static AssessmentQuestionAnswerEntity _instantiate(DecodingData data) {
    return AssessmentQuestionAnswerEntity(
        questionId: data.dec(_f$questionId), answerId: data.dec(_f$answerId));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentQuestionAnswerEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentQuestionAnswerEntity>(map);
  }

  static AssessmentQuestionAnswerEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentQuestionAnswerEntity>(json);
  }
}

mixin AssessmentQuestionAnswerEntityMappable {
  String toJson() {
    return AssessmentQuestionAnswerEntityMapper.ensureInitialized()
        .encodeJson<AssessmentQuestionAnswerEntity>(
            this as AssessmentQuestionAnswerEntity);
  }

  Map<String, dynamic> toMap() {
    return AssessmentQuestionAnswerEntityMapper.ensureInitialized()
        .encodeMap<AssessmentQuestionAnswerEntity>(
            this as AssessmentQuestionAnswerEntity);
  }

  AssessmentQuestionAnswerEntityCopyWith<AssessmentQuestionAnswerEntity,
          AssessmentQuestionAnswerEntity, AssessmentQuestionAnswerEntity>
      get copyWith => _AssessmentQuestionAnswerEntityCopyWithImpl(
          this as AssessmentQuestionAnswerEntity, $identity, $identity);
  @override
  String toString() {
    return AssessmentQuestionAnswerEntityMapper.ensureInitialized()
        .stringifyValue(this as AssessmentQuestionAnswerEntity);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentQuestionAnswerEntityMapper.ensureInitialized()
        .equalsValue(this as AssessmentQuestionAnswerEntity, other);
  }

  @override
  int get hashCode {
    return AssessmentQuestionAnswerEntityMapper.ensureInitialized()
        .hashValue(this as AssessmentQuestionAnswerEntity);
  }
}

extension AssessmentQuestionAnswerEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentQuestionAnswerEntity, $Out> {
  AssessmentQuestionAnswerEntityCopyWith<$R, AssessmentQuestionAnswerEntity,
          $Out>
      get $asAssessmentQuestionAnswerEntity => $base.as(
          (v, t, t2) => _AssessmentQuestionAnswerEntityCopyWithImpl(v, t, t2));
}

abstract class AssessmentQuestionAnswerEntityCopyWith<
    $R,
    $In extends AssessmentQuestionAnswerEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? questionId, String? answerId});
  AssessmentQuestionAnswerEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentQuestionAnswerEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentQuestionAnswerEntity, $Out>
    implements
        AssessmentQuestionAnswerEntityCopyWith<$R,
            AssessmentQuestionAnswerEntity, $Out> {
  _AssessmentQuestionAnswerEntityCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentQuestionAnswerEntity> $mapper =
      AssessmentQuestionAnswerEntityMapper.ensureInitialized();
  @override
  $R call({String? questionId, String? answerId}) => $apply(FieldCopyWithData({
        if (questionId != null) #questionId: questionId,
        if (answerId != null) #answerId: answerId
      }));
  @override
  AssessmentQuestionAnswerEntity $make(CopyWithData data) =>
      AssessmentQuestionAnswerEntity(
          questionId: data.get(#questionId, or: $value.questionId),
          answerId: data.get(#answerId, or: $value.answerId));

  @override
  AssessmentQuestionAnswerEntityCopyWith<$R2, AssessmentQuestionAnswerEntity,
      $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AssessmentQuestionAnswerEntityCopyWithImpl($value, $cast, t);
}
