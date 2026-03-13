// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'task_model.dart';

class PatientTaskModelMapper extends ClassMapperBase<PatientTaskModel> {
  PatientTaskModelMapper._();

  static PatientTaskModelMapper? _instance;
  static PatientTaskModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PatientTaskModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PatientTaskModel';

  static String? _$activityId(PatientTaskModel v) => v.activityId;
  static const Field<PatientTaskModel, String> _f$activityId =
      Field('activityId', _$activityId, key: r'id', opt: true);
  static String? _$activityName(PatientTaskModel v) => v.activityName;
  static const Field<PatientTaskModel, String> _f$activityName =
      Field('activityName', _$activityName, key: r'activity', opt: true);
  static bool? _$isCompleted(PatientTaskModel v) => v.isCompleted;
  static const Field<PatientTaskModel, bool> _f$isCompleted = Field(
      'isCompleted', _$isCompleted,
      key: r'is_completed', opt: true, def: false);

  @override
  final MappableFields<PatientTaskModel> fields = const {
    #activityId: _f$activityId,
    #activityName: _f$activityName,
    #isCompleted: _f$isCompleted,
  };

  static PatientTaskModel _instantiate(DecodingData data) {
    return PatientTaskModel(
        activityId: data.dec(_f$activityId),
        activityName: data.dec(_f$activityName),
        isCompleted: data.dec(_f$isCompleted));
  }

  @override
  final Function instantiate = _instantiate;

  static PatientTaskModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PatientTaskModel>(map);
  }

  static PatientTaskModel fromJson(String json) {
    return ensureInitialized().decodeJson<PatientTaskModel>(json);
  }
}

mixin PatientTaskModelMappable {
  String toJson() {
    return PatientTaskModelMapper.ensureInitialized()
        .encodeJson<PatientTaskModel>(this as PatientTaskModel);
  }

  Map<String, dynamic> toMap() {
    return PatientTaskModelMapper.ensureInitialized()
        .encodeMap<PatientTaskModel>(this as PatientTaskModel);
  }

  PatientTaskModelCopyWith<PatientTaskModel, PatientTaskModel, PatientTaskModel>
      get copyWith =>
          _PatientTaskModelCopyWithImpl<PatientTaskModel, PatientTaskModel>(
              this as PatientTaskModel, $identity, $identity);
  @override
  String toString() {
    return PatientTaskModelMapper.ensureInitialized()
        .stringifyValue(this as PatientTaskModel);
  }

  @override
  bool operator ==(Object other) {
    return PatientTaskModelMapper.ensureInitialized()
        .equalsValue(this as PatientTaskModel, other);
  }

  @override
  int get hashCode {
    return PatientTaskModelMapper.ensureInitialized()
        .hashValue(this as PatientTaskModel);
  }
}

extension PatientTaskModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PatientTaskModel, $Out> {
  PatientTaskModelCopyWith<$R, PatientTaskModel, $Out>
      get $asPatientTaskModel => $base
          .as((v, t, t2) => _PatientTaskModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PatientTaskModelCopyWith<$R, $In extends PatientTaskModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? activityId, String? activityName, bool? isCompleted});
  PatientTaskModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PatientTaskModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PatientTaskModel, $Out>
    implements PatientTaskModelCopyWith<$R, PatientTaskModel, $Out> {
  _PatientTaskModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PatientTaskModel> $mapper =
      PatientTaskModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? activityId = $none,
          Object? activityName = $none,
          Object? isCompleted = $none}) =>
      $apply(FieldCopyWithData({
        if (activityId != $none) #activityId: activityId,
        if (activityName != $none) #activityName: activityName,
        if (isCompleted != $none) #isCompleted: isCompleted
      }));
  @override
  PatientTaskModel $make(CopyWithData data) => PatientTaskModel(
      activityId: data.get(#activityId, or: $value.activityId),
      activityName: data.get(#activityName, or: $value.activityName),
      isCompleted: data.get(#isCompleted, or: $value.isCompleted));

  @override
  PatientTaskModelCopyWith<$R2, PatientTaskModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PatientTaskModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
