// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_option_entity.dart';

class AssessmentOptionEntityMapper
    extends ClassMapperBase<AssessmentOptionEntity> {
  AssessmentOptionEntityMapper._();

  static AssessmentOptionEntityMapper? _instance;
  static AssessmentOptionEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentOptionEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentOptionEntity';

  static String _$optionId(AssessmentOptionEntity v) => v.optionId;
  static const Field<AssessmentOptionEntity, String> _f$optionId =
      Field('optionId', _$optionId, key: r'option_id');
  static String _$text(AssessmentOptionEntity v) => v.text;
  static const Field<AssessmentOptionEntity, String> _f$text =
      Field('text', _$text);
  static int _$score(AssessmentOptionEntity v) => v.score;
  static const Field<AssessmentOptionEntity, int> _f$score =
      Field('score', _$score);

  @override
  final MappableFields<AssessmentOptionEntity> fields = const {
    #optionId: _f$optionId,
    #text: _f$text,
    #score: _f$score,
  };

  static AssessmentOptionEntity _instantiate(DecodingData data) {
    return AssessmentOptionEntity(
        optionId: data.dec(_f$optionId),
        text: data.dec(_f$text),
        score: data.dec(_f$score));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentOptionEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentOptionEntity>(map);
  }

  static AssessmentOptionEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentOptionEntity>(json);
  }
}

mixin AssessmentOptionEntityMappable {
  String toJson() {
    return AssessmentOptionEntityMapper.ensureInitialized()
        .encodeJson<AssessmentOptionEntity>(this as AssessmentOptionEntity);
  }

  Map<String, dynamic> toMap() {
    return AssessmentOptionEntityMapper.ensureInitialized()
        .encodeMap<AssessmentOptionEntity>(this as AssessmentOptionEntity);
  }

  AssessmentOptionEntityCopyWith<AssessmentOptionEntity, AssessmentOptionEntity,
          AssessmentOptionEntity>
      get copyWith => _AssessmentOptionEntityCopyWithImpl(
          this as AssessmentOptionEntity, $identity, $identity);
  @override
  String toString() {
    return AssessmentOptionEntityMapper.ensureInitialized()
        .stringifyValue(this as AssessmentOptionEntity);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentOptionEntityMapper.ensureInitialized()
        .equalsValue(this as AssessmentOptionEntity, other);
  }

  @override
  int get hashCode {
    return AssessmentOptionEntityMapper.ensureInitialized()
        .hashValue(this as AssessmentOptionEntity);
  }
}

extension AssessmentOptionEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentOptionEntity, $Out> {
  AssessmentOptionEntityCopyWith<$R, AssessmentOptionEntity, $Out>
      get $asAssessmentOptionEntity =>
          $base.as((v, t, t2) => _AssessmentOptionEntityCopyWithImpl(v, t, t2));
}

abstract class AssessmentOptionEntityCopyWith<
    $R,
    $In extends AssessmentOptionEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? optionId, String? text, int? score});
  AssessmentOptionEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentOptionEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentOptionEntity, $Out>
    implements
        AssessmentOptionEntityCopyWith<$R, AssessmentOptionEntity, $Out> {
  _AssessmentOptionEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentOptionEntity> $mapper =
      AssessmentOptionEntityMapper.ensureInitialized();
  @override
  $R call({String? optionId, String? text, int? score}) =>
      $apply(FieldCopyWithData({
        if (optionId != null) #optionId: optionId,
        if (text != null) #text: text,
        if (score != null) #score: score
      }));
  @override
  AssessmentOptionEntity $make(CopyWithData data) => AssessmentOptionEntity(
      optionId: data.get(#optionId, or: $value.optionId),
      text: data.get(#text, or: $value.text),
      score: data.get(#score, or: $value.score));

  @override
  AssessmentOptionEntityCopyWith<$R2, AssessmentOptionEntity, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentOptionEntityCopyWithImpl($value, $cast, t);
}
