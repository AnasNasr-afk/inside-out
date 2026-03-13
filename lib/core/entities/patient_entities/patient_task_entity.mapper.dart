// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'patient_task_entity.dart';

class PatientTaskEntityMapper extends ClassMapperBase<PatientTaskEntity> {
  PatientTaskEntityMapper._();

  static PatientTaskEntityMapper? _instance;
  static PatientTaskEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PatientTaskEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PatientTaskEntity';

  static String _$title(PatientTaskEntity v) => v.title;
  static const Field<PatientTaskEntity, String> _f$title =
      Field('title', _$title);
  static bool _$isCompleted(PatientTaskEntity v) => v.isCompleted;
  static const Field<PatientTaskEntity, bool> _f$isCompleted =
      Field('isCompleted', _$isCompleted, key: r'is_completed');
  static DateTime _$date(PatientTaskEntity v) => v.date;
  static const Field<PatientTaskEntity, DateTime> _f$date =
      Field('date', _$date, key: r'date_assigned');

  @override
  final MappableFields<PatientTaskEntity> fields = const {
    #title: _f$title,
    #isCompleted: _f$isCompleted,
    #date: _f$date,
  };

  static PatientTaskEntity _instantiate(DecodingData data) {
    return PatientTaskEntity(
        title: data.dec(_f$title),
        isCompleted: data.dec(_f$isCompleted),
        date: data.dec(_f$date));
  }

  @override
  final Function instantiate = _instantiate;

  static PatientTaskEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PatientTaskEntity>(map);
  }

  static PatientTaskEntity fromJson(String json) {
    return ensureInitialized().decodeJson<PatientTaskEntity>(json);
  }
}

mixin PatientTaskEntityMappable {
  String toJson() {
    return PatientTaskEntityMapper.ensureInitialized()
        .encodeJson<PatientTaskEntity>(this as PatientTaskEntity);
  }

  Map<String, dynamic> toMap() {
    return PatientTaskEntityMapper.ensureInitialized()
        .encodeMap<PatientTaskEntity>(this as PatientTaskEntity);
  }

  PatientTaskEntityCopyWith<PatientTaskEntity, PatientTaskEntity,
          PatientTaskEntity>
      get copyWith => _PatientTaskEntityCopyWithImpl(
          this as PatientTaskEntity, $identity, $identity);
  @override
  String toString() {
    return PatientTaskEntityMapper.ensureInitialized()
        .stringifyValue(this as PatientTaskEntity);
  }

  @override
  bool operator ==(Object other) {
    return PatientTaskEntityMapper.ensureInitialized()
        .equalsValue(this as PatientTaskEntity, other);
  }

  @override
  int get hashCode {
    return PatientTaskEntityMapper.ensureInitialized()
        .hashValue(this as PatientTaskEntity);
  }
}

extension PatientTaskEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PatientTaskEntity, $Out> {
  PatientTaskEntityCopyWith<$R, PatientTaskEntity, $Out>
      get $asPatientTaskEntity =>
          $base.as((v, t, t2) => _PatientTaskEntityCopyWithImpl(v, t, t2));
}

abstract class PatientTaskEntityCopyWith<$R, $In extends PatientTaskEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? title, bool? isCompleted, DateTime? date});
  PatientTaskEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PatientTaskEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PatientTaskEntity, $Out>
    implements PatientTaskEntityCopyWith<$R, PatientTaskEntity, $Out> {
  _PatientTaskEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PatientTaskEntity> $mapper =
      PatientTaskEntityMapper.ensureInitialized();
  @override
  $R call({String? title, bool? isCompleted, DateTime? date}) =>
      $apply(FieldCopyWithData({
        if (title != null) #title: title,
        if (isCompleted != null) #isCompleted: isCompleted,
        if (date != null) #date: date
      }));
  @override
  PatientTaskEntity $make(CopyWithData data) => PatientTaskEntity(
      title: data.get(#title, or: $value.title),
      isCompleted: data.get(#isCompleted, or: $value.isCompleted),
      date: data.get(#date, or: $value.date));

  @override
  PatientTaskEntityCopyWith<$R2, PatientTaskEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PatientTaskEntityCopyWithImpl($value, $cast, t);
}
