// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'consultation_request_entity.dart';

class ConsultationRequestEntityMapper
    extends ClassMapperBase<ConsultationRequestEntity> {
  ConsultationRequestEntityMapper._();

  static ConsultationRequestEntityMapper? _instance;
  static ConsultationRequestEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = ConsultationRequestEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ConsultationRequestEntity';

  static String? _$timestamp(ConsultationRequestEntity v) => v.timestamp;
  static const Field<ConsultationRequestEntity, String> _f$timestamp =
      Field('timestamp', _$timestamp, opt: true);
  static String? _$therapistId(ConsultationRequestEntity v) => v.therapistId;
  static const Field<ConsultationRequestEntity, String> _f$therapistId =
      Field('therapistId', _$therapistId, key: r'therapist_id', opt: true);
  static String? _$patientId(ConsultationRequestEntity v) => v.patientId;
  static const Field<ConsultationRequestEntity, String> _f$patientId =
      Field('patientId', _$patientId, key: r'patient_id', opt: true);
  static bool? _$isConsultation(ConsultationRequestEntity v) =>
      v.isConsultation;
  static const Field<ConsultationRequestEntity, bool> _f$isConsultation = Field(
      'isConsultation', _$isConsultation,
      key: r'is_consultation', opt: true);
  static int? _$mode(ConsultationRequestEntity v) => v.mode;
  static const Field<ConsultationRequestEntity, int> _f$mode =
      Field('mode', _$mode, opt: true);
  static int? _$duration(ConsultationRequestEntity v) => v.duration;
  static const Field<ConsultationRequestEntity, int> _f$duration =
      Field('duration', _$duration, opt: true);
  static String? _$name(ConsultationRequestEntity v) => v.name;
  static const Field<ConsultationRequestEntity, String> _f$name =
      Field('name', _$name, opt: true);
  static String? _$status(ConsultationRequestEntity v) => v.status;
  static const Field<ConsultationRequestEntity, String> _f$status =
      Field('status', _$status, opt: true);

  @override
  final MappableFields<ConsultationRequestEntity> fields = const {
    #timestamp: _f$timestamp,
    #therapistId: _f$therapistId,
    #patientId: _f$patientId,
    #isConsultation: _f$isConsultation,
    #mode: _f$mode,
    #duration: _f$duration,
    #name: _f$name,
    #status: _f$status,
  };

  static ConsultationRequestEntity _instantiate(DecodingData data) {
    return ConsultationRequestEntity(
        timestamp: data.dec(_f$timestamp),
        therapistId: data.dec(_f$therapistId),
        patientId: data.dec(_f$patientId),
        isConsultation: data.dec(_f$isConsultation),
        mode: data.dec(_f$mode),
        duration: data.dec(_f$duration),
        name: data.dec(_f$name),
        status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static ConsultationRequestEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConsultationRequestEntity>(map);
  }

  static ConsultationRequestEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ConsultationRequestEntity>(json);
  }
}

mixin ConsultationRequestEntityMappable {
  String toJson() {
    return ConsultationRequestEntityMapper.ensureInitialized()
        .encodeJson<ConsultationRequestEntity>(
            this as ConsultationRequestEntity);
  }

  Map<String, dynamic> toMap() {
    return ConsultationRequestEntityMapper.ensureInitialized()
        .encodeMap<ConsultationRequestEntity>(
            this as ConsultationRequestEntity);
  }

  ConsultationRequestEntityCopyWith<ConsultationRequestEntity,
          ConsultationRequestEntity, ConsultationRequestEntity>
      get copyWith => _ConsultationRequestEntityCopyWithImpl<
              ConsultationRequestEntity, ConsultationRequestEntity>(
          this as ConsultationRequestEntity, $identity, $identity);
  @override
  String toString() {
    return ConsultationRequestEntityMapper.ensureInitialized()
        .stringifyValue(this as ConsultationRequestEntity);
  }

  @override
  bool operator ==(Object other) {
    return ConsultationRequestEntityMapper.ensureInitialized()
        .equalsValue(this as ConsultationRequestEntity, other);
  }

  @override
  int get hashCode {
    return ConsultationRequestEntityMapper.ensureInitialized()
        .hashValue(this as ConsultationRequestEntity);
  }
}

extension ConsultationRequestEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConsultationRequestEntity, $Out> {
  ConsultationRequestEntityCopyWith<$R, ConsultationRequestEntity, $Out>
      get $asConsultationRequestEntity => $base.as((v, t, t2) =>
          _ConsultationRequestEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConsultationRequestEntityCopyWith<
    $R,
    $In extends ConsultationRequestEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? timestamp,
      String? therapistId,
      String? patientId,
      bool? isConsultation,
      int? mode,
      int? duration,
      String? name,
      String? status});
  ConsultationRequestEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ConsultationRequestEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConsultationRequestEntity, $Out>
    implements
        ConsultationRequestEntityCopyWith<$R, ConsultationRequestEntity, $Out> {
  _ConsultationRequestEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConsultationRequestEntity> $mapper =
      ConsultationRequestEntityMapper.ensureInitialized();
  @override
  $R call(
          {Object? timestamp = $none,
          Object? therapistId = $none,
          Object? patientId = $none,
          Object? isConsultation = $none,
          Object? mode = $none,
          Object? duration = $none,
          Object? name = $none,
          Object? status = $none}) =>
      $apply(FieldCopyWithData({
        if (timestamp != $none) #timestamp: timestamp,
        if (therapistId != $none) #therapistId: therapistId,
        if (patientId != $none) #patientId: patientId,
        if (isConsultation != $none) #isConsultation: isConsultation,
        if (mode != $none) #mode: mode,
        if (duration != $none) #duration: duration,
        if (name != $none) #name: name,
        if (status != $none) #status: status
      }));
  @override
  ConsultationRequestEntity $make(CopyWithData data) =>
      ConsultationRequestEntity(
          timestamp: data.get(#timestamp, or: $value.timestamp),
          therapistId: data.get(#therapistId, or: $value.therapistId),
          patientId: data.get(#patientId, or: $value.patientId),
          isConsultation: data.get(#isConsultation, or: $value.isConsultation),
          mode: data.get(#mode, or: $value.mode),
          duration: data.get(#duration, or: $value.duration),
          name: data.get(#name, or: $value.name),
          status: data.get(#status, or: $value.status));

  @override
  ConsultationRequestEntityCopyWith<$R2, ConsultationRequestEntity, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ConsultationRequestEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
