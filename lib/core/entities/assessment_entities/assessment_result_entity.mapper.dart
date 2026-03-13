// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_result_entity.dart';

class AssessmentResultEntityMapper
    extends ClassMapperBase<AssessmentResultEntity> {
  AssessmentResultEntityMapper._();

  static AssessmentResultEntityMapper? _instance;
  static AssessmentResultEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentResultEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentResultEntity';

  static int _$assessmentScore(AssessmentResultEntity v) => v.assessmentScore;
  static const Field<AssessmentResultEntity, int> _f$assessmentScore =
      Field('assessmentScore', _$assessmentScore, key: r'assessment_score');
  static bool _$isAutistic(AssessmentResultEntity v) => v.isAutistic;
  static const Field<AssessmentResultEntity, bool> _f$isAutistic =
      Field('isAutistic', _$isAutistic, key: r'is_autistic');
  static String _$message(AssessmentResultEntity v) => v.message;
  static const Field<AssessmentResultEntity, String> _f$message =
      Field('message', _$message);

  @override
  final MappableFields<AssessmentResultEntity> fields = const {
    #assessmentScore: _f$assessmentScore,
    #isAutistic: _f$isAutistic,
    #message: _f$message,
  };

  static AssessmentResultEntity _instantiate(DecodingData data) {
    return AssessmentResultEntity(
        assessmentScore: data.dec(_f$assessmentScore),
        isAutistic: data.dec(_f$isAutistic),
        message: data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentResultEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentResultEntity>(map);
  }

  static AssessmentResultEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentResultEntity>(json);
  }
}

mixin AssessmentResultEntityMappable {
  String toJson() {
    return AssessmentResultEntityMapper.ensureInitialized()
        .encodeJson<AssessmentResultEntity>(this as AssessmentResultEntity);
  }

  Map<String, dynamic> toMap() {
    return AssessmentResultEntityMapper.ensureInitialized()
        .encodeMap<AssessmentResultEntity>(this as AssessmentResultEntity);
  }

  AssessmentResultEntityCopyWith<AssessmentResultEntity, AssessmentResultEntity,
          AssessmentResultEntity>
      get copyWith => _AssessmentResultEntityCopyWithImpl(
          this as AssessmentResultEntity, $identity, $identity);
  @override
  String toString() {
    return AssessmentResultEntityMapper.ensureInitialized()
        .stringifyValue(this as AssessmentResultEntity);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentResultEntityMapper.ensureInitialized()
        .equalsValue(this as AssessmentResultEntity, other);
  }

  @override
  int get hashCode {
    return AssessmentResultEntityMapper.ensureInitialized()
        .hashValue(this as AssessmentResultEntity);
  }
}

extension AssessmentResultEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentResultEntity, $Out> {
  AssessmentResultEntityCopyWith<$R, AssessmentResultEntity, $Out>
      get $asAssessmentResultEntity =>
          $base.as((v, t, t2) => _AssessmentResultEntityCopyWithImpl(v, t, t2));
}

abstract class AssessmentResultEntityCopyWith<
    $R,
    $In extends AssessmentResultEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? assessmentScore, bool? isAutistic, String? message});
  AssessmentResultEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentResultEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentResultEntity, $Out>
    implements
        AssessmentResultEntityCopyWith<$R, AssessmentResultEntity, $Out> {
  _AssessmentResultEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentResultEntity> $mapper =
      AssessmentResultEntityMapper.ensureInitialized();
  @override
  $R call({int? assessmentScore, bool? isAutistic, String? message}) =>
      $apply(FieldCopyWithData({
        if (assessmentScore != null) #assessmentScore: assessmentScore,
        if (isAutistic != null) #isAutistic: isAutistic,
        if (message != null) #message: message
      }));
  @override
  AssessmentResultEntity $make(CopyWithData data) => AssessmentResultEntity(
      assessmentScore: data.get(#assessmentScore, or: $value.assessmentScore),
      isAutistic: data.get(#isAutistic, or: $value.isAutistic),
      message: data.get(#message, or: $value.message));

  @override
  AssessmentResultEntityCopyWith<$R2, AssessmentResultEntity, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentResultEntityCopyWithImpl($value, $cast, t);
}
