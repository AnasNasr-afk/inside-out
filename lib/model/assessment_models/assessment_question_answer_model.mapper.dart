// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_question_answer_model.dart';

class AssessmentQuestionAnswerModelMapper
    extends ClassMapperBase<AssessmentQuestionAnswerModel> {
  AssessmentQuestionAnswerModelMapper._();

  static AssessmentQuestionAnswerModelMapper? _instance;
  static AssessmentQuestionAnswerModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AssessmentQuestionAnswerModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentQuestionAnswerModel';

  static String _$questionId(AssessmentQuestionAnswerModel v) => v.questionId;
  static const Field<AssessmentQuestionAnswerModel, String> _f$questionId =
      Field('questionId', _$questionId, key: r'question_id');
  static String _$answerId(AssessmentQuestionAnswerModel v) => v.answerId;
  static const Field<AssessmentQuestionAnswerModel, String> _f$answerId =
      Field('answerId', _$answerId, key: r'answer_id');

  @override
  final MappableFields<AssessmentQuestionAnswerModel> fields = const {
    #questionId: _f$questionId,
    #answerId: _f$answerId,
  };

  static AssessmentQuestionAnswerModel _instantiate(DecodingData data) {
    return AssessmentQuestionAnswerModel(
        questionId: data.dec(_f$questionId), answerId: data.dec(_f$answerId));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentQuestionAnswerModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentQuestionAnswerModel>(map);
  }

  static AssessmentQuestionAnswerModel fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentQuestionAnswerModel>(json);
  }
}

mixin AssessmentQuestionAnswerModelMappable {
  String toJson() {
    return AssessmentQuestionAnswerModelMapper.ensureInitialized()
        .encodeJson<AssessmentQuestionAnswerModel>(
            this as AssessmentQuestionAnswerModel);
  }

  Map<String, dynamic> toMap() {
    return AssessmentQuestionAnswerModelMapper.ensureInitialized()
        .encodeMap<AssessmentQuestionAnswerModel>(
            this as AssessmentQuestionAnswerModel);
  }

  AssessmentQuestionAnswerModelCopyWith<AssessmentQuestionAnswerModel,
          AssessmentQuestionAnswerModel, AssessmentQuestionAnswerModel>
      get copyWith => _AssessmentQuestionAnswerModelCopyWithImpl(
          this as AssessmentQuestionAnswerModel, $identity, $identity);
  @override
  String toString() {
    return AssessmentQuestionAnswerModelMapper.ensureInitialized()
        .stringifyValue(this as AssessmentQuestionAnswerModel);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentQuestionAnswerModelMapper.ensureInitialized()
        .equalsValue(this as AssessmentQuestionAnswerModel, other);
  }

  @override
  int get hashCode {
    return AssessmentQuestionAnswerModelMapper.ensureInitialized()
        .hashValue(this as AssessmentQuestionAnswerModel);
  }
}

extension AssessmentQuestionAnswerModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentQuestionAnswerModel, $Out> {
  AssessmentQuestionAnswerModelCopyWith<$R, AssessmentQuestionAnswerModel, $Out>
      get $asAssessmentQuestionAnswerModel => $base.as(
          (v, t, t2) => _AssessmentQuestionAnswerModelCopyWithImpl(v, t, t2));
}

abstract class AssessmentQuestionAnswerModelCopyWith<
    $R,
    $In extends AssessmentQuestionAnswerModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? questionId, String? answerId});
  AssessmentQuestionAnswerModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentQuestionAnswerModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentQuestionAnswerModel, $Out>
    implements
        AssessmentQuestionAnswerModelCopyWith<$R, AssessmentQuestionAnswerModel,
            $Out> {
  _AssessmentQuestionAnswerModelCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentQuestionAnswerModel> $mapper =
      AssessmentQuestionAnswerModelMapper.ensureInitialized();
  @override
  $R call({String? questionId, String? answerId}) => $apply(FieldCopyWithData({
        if (questionId != null) #questionId: questionId,
        if (answerId != null) #answerId: answerId
      }));
  @override
  AssessmentQuestionAnswerModel $make(CopyWithData data) =>
      AssessmentQuestionAnswerModel(
          questionId: data.get(#questionId, or: $value.questionId),
          answerId: data.get(#answerId, or: $value.answerId));

  @override
  AssessmentQuestionAnswerModelCopyWith<$R2, AssessmentQuestionAnswerModel,
      $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AssessmentQuestionAnswerModelCopyWithImpl($value, $cast, t);
}
