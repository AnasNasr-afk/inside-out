// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_question_entity.dart';

class AssessmentQuestionEntityMapper
    extends ClassMapperBase<AssessmentQuestionEntity> {
  AssessmentQuestionEntityMapper._();

  static AssessmentQuestionEntityMapper? _instance;
  static AssessmentQuestionEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AssessmentQuestionEntityMapper._());
      AssessmentOptionEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentQuestionEntity';

  static String _$questionId(AssessmentQuestionEntity v) => v.questionId;
  static const Field<AssessmentQuestionEntity, String> _f$questionId =
      Field('questionId', _$questionId, key: r'question_id');
  static String _$text(AssessmentQuestionEntity v) => v.text;
  static const Field<AssessmentQuestionEntity, String> _f$text =
      Field('text', _$text);
  static List<AssessmentOptionEntity> _$options(AssessmentQuestionEntity v) =>
      v.options;
  static const Field<AssessmentQuestionEntity, List<AssessmentOptionEntity>>
      _f$options = Field('options', _$options);

  @override
  final MappableFields<AssessmentQuestionEntity> fields = const {
    #questionId: _f$questionId,
    #text: _f$text,
    #options: _f$options,
  };

  static AssessmentQuestionEntity _instantiate(DecodingData data) {
    return AssessmentQuestionEntity(
        questionId: data.dec(_f$questionId),
        text: data.dec(_f$text),
        options: data.dec(_f$options));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentQuestionEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentQuestionEntity>(map);
  }

  static AssessmentQuestionEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentQuestionEntity>(json);
  }
}

mixin AssessmentQuestionEntityMappable {
  String toJson() {
    return AssessmentQuestionEntityMapper.ensureInitialized()
        .encodeJson<AssessmentQuestionEntity>(this as AssessmentQuestionEntity);
  }

  Map<String, dynamic> toMap() {
    return AssessmentQuestionEntityMapper.ensureInitialized()
        .encodeMap<AssessmentQuestionEntity>(this as AssessmentQuestionEntity);
  }

  AssessmentQuestionEntityCopyWith<AssessmentQuestionEntity,
          AssessmentQuestionEntity, AssessmentQuestionEntity>
      get copyWith => _AssessmentQuestionEntityCopyWithImpl(
          this as AssessmentQuestionEntity, $identity, $identity);
  @override
  String toString() {
    return AssessmentQuestionEntityMapper.ensureInitialized()
        .stringifyValue(this as AssessmentQuestionEntity);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentQuestionEntityMapper.ensureInitialized()
        .equalsValue(this as AssessmentQuestionEntity, other);
  }

  @override
  int get hashCode {
    return AssessmentQuestionEntityMapper.ensureInitialized()
        .hashValue(this as AssessmentQuestionEntity);
  }
}

extension AssessmentQuestionEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentQuestionEntity, $Out> {
  AssessmentQuestionEntityCopyWith<$R, AssessmentQuestionEntity, $Out>
      get $asAssessmentQuestionEntity => $base
          .as((v, t, t2) => _AssessmentQuestionEntityCopyWithImpl(v, t, t2));
}

abstract class AssessmentQuestionEntityCopyWith<
    $R,
    $In extends AssessmentQuestionEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      AssessmentOptionEntity,
      AssessmentOptionEntityCopyWith<$R, AssessmentOptionEntity,
          AssessmentOptionEntity>> get options;
  $R call(
      {String? questionId,
      String? text,
      List<AssessmentOptionEntity>? options});
  AssessmentQuestionEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentQuestionEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentQuestionEntity, $Out>
    implements
        AssessmentQuestionEntityCopyWith<$R, AssessmentQuestionEntity, $Out> {
  _AssessmentQuestionEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentQuestionEntity> $mapper =
      AssessmentQuestionEntityMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      AssessmentOptionEntity,
      AssessmentOptionEntityCopyWith<$R, AssessmentOptionEntity,
          AssessmentOptionEntity>> get options => ListCopyWith(
      $value.options, (v, t) => v.copyWith.$chain(t), (v) => call(options: v));
  @override
  $R call(
          {String? questionId,
          String? text,
          List<AssessmentOptionEntity>? options}) =>
      $apply(FieldCopyWithData({
        if (questionId != null) #questionId: questionId,
        if (text != null) #text: text,
        if (options != null) #options: options
      }));
  @override
  AssessmentQuestionEntity $make(CopyWithData data) => AssessmentQuestionEntity(
      questionId: data.get(#questionId, or: $value.questionId),
      text: data.get(#text, or: $value.text),
      options: data.get(#options, or: $value.options));

  @override
  AssessmentQuestionEntityCopyWith<$R2, AssessmentQuestionEntity, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentQuestionEntityCopyWithImpl($value, $cast, t);
}
