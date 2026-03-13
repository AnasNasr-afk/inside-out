// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_question_model.dart';

class AssessmentQuestionModelMapper
    extends ClassMapperBase<AssessmentQuestionModel> {
  AssessmentQuestionModelMapper._();

  static AssessmentQuestionModelMapper? _instance;
  static AssessmentQuestionModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AssessmentQuestionModelMapper._());
      AssessmentOptionModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentQuestionModel';

  static String _$questionId(AssessmentQuestionModel v) => v.questionId;
  static const Field<AssessmentQuestionModel, String> _f$questionId =
      Field('questionId', _$questionId, key: r'question_id');
  static String _$text(AssessmentQuestionModel v) => v.text;
  static const Field<AssessmentQuestionModel, String> _f$text =
      Field('text', _$text);
  static List<AssessmentOptionModel> _$options(AssessmentQuestionModel v) =>
      v.options;
  static const Field<AssessmentQuestionModel, List<AssessmentOptionModel>>
      _f$options = Field('options', _$options);

  @override
  final MappableFields<AssessmentQuestionModel> fields = const {
    #questionId: _f$questionId,
    #text: _f$text,
    #options: _f$options,
  };

  static AssessmentQuestionModel _instantiate(DecodingData data) {
    return AssessmentQuestionModel(
        questionId: data.dec(_f$questionId),
        text: data.dec(_f$text),
        options: data.dec(_f$options));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentQuestionModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentQuestionModel>(map);
  }

  static AssessmentQuestionModel fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentQuestionModel>(json);
  }
}

mixin AssessmentQuestionModelMappable {
  String toJson() {
    return AssessmentQuestionModelMapper.ensureInitialized()
        .encodeJson<AssessmentQuestionModel>(this as AssessmentQuestionModel);
  }

  Map<String, dynamic> toMap() {
    return AssessmentQuestionModelMapper.ensureInitialized()
        .encodeMap<AssessmentQuestionModel>(this as AssessmentQuestionModel);
  }

  AssessmentQuestionModelCopyWith<AssessmentQuestionModel,
          AssessmentQuestionModel, AssessmentQuestionModel>
      get copyWith => _AssessmentQuestionModelCopyWithImpl(
          this as AssessmentQuestionModel, $identity, $identity);
  @override
  String toString() {
    return AssessmentQuestionModelMapper.ensureInitialized()
        .stringifyValue(this as AssessmentQuestionModel);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentQuestionModelMapper.ensureInitialized()
        .equalsValue(this as AssessmentQuestionModel, other);
  }

  @override
  int get hashCode {
    return AssessmentQuestionModelMapper.ensureInitialized()
        .hashValue(this as AssessmentQuestionModel);
  }
}

extension AssessmentQuestionModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentQuestionModel, $Out> {
  AssessmentQuestionModelCopyWith<$R, AssessmentQuestionModel, $Out>
      get $asAssessmentQuestionModel => $base
          .as((v, t, t2) => _AssessmentQuestionModelCopyWithImpl(v, t, t2));
}

abstract class AssessmentQuestionModelCopyWith<
    $R,
    $In extends AssessmentQuestionModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      AssessmentOptionModel,
      AssessmentOptionModelCopyWith<$R, AssessmentOptionModel,
          AssessmentOptionModel>> get options;
  $R call(
      {String? questionId, String? text, List<AssessmentOptionModel>? options});
  AssessmentQuestionModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentQuestionModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentQuestionModel, $Out>
    implements
        AssessmentQuestionModelCopyWith<$R, AssessmentQuestionModel, $Out> {
  _AssessmentQuestionModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentQuestionModel> $mapper =
      AssessmentQuestionModelMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      AssessmentOptionModel,
      AssessmentOptionModelCopyWith<$R, AssessmentOptionModel,
          AssessmentOptionModel>> get options => ListCopyWith(
      $value.options, (v, t) => v.copyWith.$chain(t), (v) => call(options: v));
  @override
  $R call(
          {String? questionId,
          String? text,
          List<AssessmentOptionModel>? options}) =>
      $apply(FieldCopyWithData({
        if (questionId != null) #questionId: questionId,
        if (text != null) #text: text,
        if (options != null) #options: options
      }));
  @override
  AssessmentQuestionModel $make(CopyWithData data) => AssessmentQuestionModel(
      questionId: data.get(#questionId, or: $value.questionId),
      text: data.get(#text, or: $value.text),
      options: data.get(#options, or: $value.options));

  @override
  AssessmentQuestionModelCopyWith<$R2, AssessmentQuestionModel, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentQuestionModelCopyWithImpl($value, $cast, t);
}
