// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_option_model.dart';

class AssessmentOptionModelMapper
    extends ClassMapperBase<AssessmentOptionModel> {
  AssessmentOptionModelMapper._();

  static AssessmentOptionModelMapper? _instance;
  static AssessmentOptionModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentOptionModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentOptionModel';

  static String _$optionId(AssessmentOptionModel v) => v.optionId;
  static const Field<AssessmentOptionModel, String> _f$optionId =
      Field('optionId', _$optionId, key: r'option_id');
  static String _$text(AssessmentOptionModel v) => v.text;
  static const Field<AssessmentOptionModel, String> _f$text =
      Field('text', _$text);
  static int _$score(AssessmentOptionModel v) => v.score;
  static const Field<AssessmentOptionModel, int> _f$score =
      Field('score', _$score);

  @override
  final MappableFields<AssessmentOptionModel> fields = const {
    #optionId: _f$optionId,
    #text: _f$text,
    #score: _f$score,
  };

  static AssessmentOptionModel _instantiate(DecodingData data) {
    return AssessmentOptionModel(
        optionId: data.dec(_f$optionId),
        text: data.dec(_f$text),
        score: data.dec(_f$score));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentOptionModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentOptionModel>(map);
  }

  static AssessmentOptionModel fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentOptionModel>(json);
  }
}

mixin AssessmentOptionModelMappable {
  String toJson() {
    return AssessmentOptionModelMapper.ensureInitialized()
        .encodeJson<AssessmentOptionModel>(this as AssessmentOptionModel);
  }

  Map<String, dynamic> toMap() {
    return AssessmentOptionModelMapper.ensureInitialized()
        .encodeMap<AssessmentOptionModel>(this as AssessmentOptionModel);
  }

  AssessmentOptionModelCopyWith<AssessmentOptionModel, AssessmentOptionModel,
          AssessmentOptionModel>
      get copyWith => _AssessmentOptionModelCopyWithImpl(
          this as AssessmentOptionModel, $identity, $identity);
  @override
  String toString() {
    return AssessmentOptionModelMapper.ensureInitialized()
        .stringifyValue(this as AssessmentOptionModel);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentOptionModelMapper.ensureInitialized()
        .equalsValue(this as AssessmentOptionModel, other);
  }

  @override
  int get hashCode {
    return AssessmentOptionModelMapper.ensureInitialized()
        .hashValue(this as AssessmentOptionModel);
  }
}

extension AssessmentOptionModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentOptionModel, $Out> {
  AssessmentOptionModelCopyWith<$R, AssessmentOptionModel, $Out>
      get $asAssessmentOptionModel =>
          $base.as((v, t, t2) => _AssessmentOptionModelCopyWithImpl(v, t, t2));
}

abstract class AssessmentOptionModelCopyWith<
    $R,
    $In extends AssessmentOptionModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? optionId, String? text, int? score});
  AssessmentOptionModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentOptionModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentOptionModel, $Out>
    implements AssessmentOptionModelCopyWith<$R, AssessmentOptionModel, $Out> {
  _AssessmentOptionModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentOptionModel> $mapper =
      AssessmentOptionModelMapper.ensureInitialized();
  @override
  $R call({String? optionId, String? text, int? score}) =>
      $apply(FieldCopyWithData({
        if (optionId != null) #optionId: optionId,
        if (text != null) #text: text,
        if (score != null) #score: score
      }));
  @override
  AssessmentOptionModel $make(CopyWithData data) => AssessmentOptionModel(
      optionId: data.get(#optionId, or: $value.optionId),
      text: data.get(#text, or: $value.text),
      score: data.get(#score, or: $value.score));

  @override
  AssessmentOptionModelCopyWith<$R2, AssessmentOptionModel, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentOptionModelCopyWithImpl($value, $cast, t);
}
