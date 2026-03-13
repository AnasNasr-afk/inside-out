// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'assessment_result_model.dart';

class AssessmentResultModelMapper
    extends ClassMapperBase<AssessmentResultModel> {
  AssessmentResultModelMapper._();

  static AssessmentResultModelMapper? _instance;
  static AssessmentResultModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AssessmentResultModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AssessmentResultModel';

  static int _$assessmentScore(AssessmentResultModel v) => v.assessmentScore;
  static const Field<AssessmentResultModel, int> _f$assessmentScore =
      Field('assessmentScore', _$assessmentScore, key: r'assessment_score');
  static bool _$isAutistic(AssessmentResultModel v) => v.isAutistic;
  static const Field<AssessmentResultModel, bool> _f$isAutistic =
      Field('isAutistic', _$isAutistic, key: r'is_autistic');
  static String _$message(AssessmentResultModel v) => v.message;
  static const Field<AssessmentResultModel, String> _f$message =
      Field('message', _$message);

  @override
  final MappableFields<AssessmentResultModel> fields = const {
    #assessmentScore: _f$assessmentScore,
    #isAutistic: _f$isAutistic,
    #message: _f$message,
  };

  static AssessmentResultModel _instantiate(DecodingData data) {
    return AssessmentResultModel(
        assessmentScore: data.dec(_f$assessmentScore),
        isAutistic: data.dec(_f$isAutistic),
        message: data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static AssessmentResultModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AssessmentResultModel>(map);
  }

  static AssessmentResultModel fromJson(String json) {
    return ensureInitialized().decodeJson<AssessmentResultModel>(json);
  }
}

mixin AssessmentResultModelMappable {
  String toJson() {
    return AssessmentResultModelMapper.ensureInitialized()
        .encodeJson<AssessmentResultModel>(this as AssessmentResultModel);
  }

  Map<String, dynamic> toMap() {
    return AssessmentResultModelMapper.ensureInitialized()
        .encodeMap<AssessmentResultModel>(this as AssessmentResultModel);
  }

  AssessmentResultModelCopyWith<AssessmentResultModel, AssessmentResultModel,
          AssessmentResultModel>
      get copyWith => _AssessmentResultModelCopyWithImpl(
          this as AssessmentResultModel, $identity, $identity);
  @override
  String toString() {
    return AssessmentResultModelMapper.ensureInitialized()
        .stringifyValue(this as AssessmentResultModel);
  }

  @override
  bool operator ==(Object other) {
    return AssessmentResultModelMapper.ensureInitialized()
        .equalsValue(this as AssessmentResultModel, other);
  }

  @override
  int get hashCode {
    return AssessmentResultModelMapper.ensureInitialized()
        .hashValue(this as AssessmentResultModel);
  }
}

extension AssessmentResultModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AssessmentResultModel, $Out> {
  AssessmentResultModelCopyWith<$R, AssessmentResultModel, $Out>
      get $asAssessmentResultModel =>
          $base.as((v, t, t2) => _AssessmentResultModelCopyWithImpl(v, t, t2));
}

abstract class AssessmentResultModelCopyWith<
    $R,
    $In extends AssessmentResultModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? assessmentScore, bool? isAutistic, String? message});
  AssessmentResultModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AssessmentResultModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AssessmentResultModel, $Out>
    implements AssessmentResultModelCopyWith<$R, AssessmentResultModel, $Out> {
  _AssessmentResultModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AssessmentResultModel> $mapper =
      AssessmentResultModelMapper.ensureInitialized();
  @override
  $R call({int? assessmentScore, bool? isAutistic, String? message}) =>
      $apply(FieldCopyWithData({
        if (assessmentScore != null) #assessmentScore: assessmentScore,
        if (isAutistic != null) #isAutistic: isAutistic,
        if (message != null) #message: message
      }));
  @override
  AssessmentResultModel $make(CopyWithData data) => AssessmentResultModel(
      assessmentScore: data.get(#assessmentScore, or: $value.assessmentScore),
      isAutistic: data.get(#isAutistic, or: $value.isAutistic),
      message: data.get(#message, or: $value.message));

  @override
  AssessmentResultModelCopyWith<$R2, AssessmentResultModel, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AssessmentResultModelCopyWithImpl($value, $cast, t);
}
