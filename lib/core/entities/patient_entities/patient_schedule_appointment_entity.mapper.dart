// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'patient_schedule_appointment_entity.dart';

class PatientScheduleAppointmentEntityMapper
    extends ClassMapperBase<PatientScheduleAppointmentEntity> {
  PatientScheduleAppointmentEntityMapper._();

  static PatientScheduleAppointmentEntityMapper? _instance;
  static PatientScheduleAppointmentEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = PatientScheduleAppointmentEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PatientScheduleAppointmentEntity';

  static DateTime _$timestamp(PatientScheduleAppointmentEntity v) =>
      v.timestamp;
  static const Field<PatientScheduleAppointmentEntity, DateTime> _f$timestamp =
      Field('timestamp', _$timestamp);
  static String _$patientId(PatientScheduleAppointmentEntity v) => v.patientId;
  static const Field<PatientScheduleAppointmentEntity, String> _f$patientId =
      Field('patientId', _$patientId, key: r'patient_id');
  static String _$therapistId(PatientScheduleAppointmentEntity v) =>
      v.therapistId;
  static const Field<PatientScheduleAppointmentEntity, String> _f$therapistId =
      Field('therapistId', _$therapistId, key: r'therapist_id');
  static int _$mode(PatientScheduleAppointmentEntity v) => v.mode;
  static const Field<PatientScheduleAppointmentEntity, int> _f$mode =
      Field('mode', _$mode);
  static int _$duration(PatientScheduleAppointmentEntity v) => v.duration;
  static const Field<PatientScheduleAppointmentEntity, int> _f$duration =
      Field('duration', _$duration);
  static String _$appointmentName(PatientScheduleAppointmentEntity v) =>
      v.appointmentName;
  static const Field<PatientScheduleAppointmentEntity, String>
      _f$appointmentName =
      Field('appointmentName', _$appointmentName, key: r'name');
  static String _$serviceType(PatientScheduleAppointmentEntity v) =>
      v.serviceType;
  static const Field<PatientScheduleAppointmentEntity, String> _f$serviceType =
      Field('serviceType', _$serviceType, key: r'service_type');

  @override
  final MappableFields<PatientScheduleAppointmentEntity> fields = const {
    #timestamp: _f$timestamp,
    #patientId: _f$patientId,
    #therapistId: _f$therapistId,
    #mode: _f$mode,
    #duration: _f$duration,
    #appointmentName: _f$appointmentName,
    #serviceType: _f$serviceType,
  };

  static PatientScheduleAppointmentEntity _instantiate(DecodingData data) {
    return PatientScheduleAppointmentEntity(
        timestamp: data.dec(_f$timestamp),
        patientId: data.dec(_f$patientId),
        therapistId: data.dec(_f$therapistId),
        mode: data.dec(_f$mode),
        duration: data.dec(_f$duration),
        appointmentName: data.dec(_f$appointmentName),
        serviceType: data.dec(_f$serviceType));
  }

  @override
  final Function instantiate = _instantiate;

  static PatientScheduleAppointmentEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PatientScheduleAppointmentEntity>(map);
  }

  static PatientScheduleAppointmentEntity fromJson(String json) {
    return ensureInitialized()
        .decodeJson<PatientScheduleAppointmentEntity>(json);
  }
}

mixin PatientScheduleAppointmentEntityMappable {
  String toJson() {
    return PatientScheduleAppointmentEntityMapper.ensureInitialized()
        .encodeJson<PatientScheduleAppointmentEntity>(
            this as PatientScheduleAppointmentEntity);
  }

  Map<String, dynamic> toMap() {
    return PatientScheduleAppointmentEntityMapper.ensureInitialized()
        .encodeMap<PatientScheduleAppointmentEntity>(
            this as PatientScheduleAppointmentEntity);
  }

  PatientScheduleAppointmentEntityCopyWith<PatientScheduleAppointmentEntity,
          PatientScheduleAppointmentEntity, PatientScheduleAppointmentEntity>
      get copyWith => _PatientScheduleAppointmentEntityCopyWithImpl(
          this as PatientScheduleAppointmentEntity, $identity, $identity);
  @override
  String toString() {
    return PatientScheduleAppointmentEntityMapper.ensureInitialized()
        .stringifyValue(this as PatientScheduleAppointmentEntity);
  }

  @override
  bool operator ==(Object other) {
    return PatientScheduleAppointmentEntityMapper.ensureInitialized()
        .equalsValue(this as PatientScheduleAppointmentEntity, other);
  }

  @override
  int get hashCode {
    return PatientScheduleAppointmentEntityMapper.ensureInitialized()
        .hashValue(this as PatientScheduleAppointmentEntity);
  }
}

extension PatientScheduleAppointmentEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PatientScheduleAppointmentEntity, $Out> {
  PatientScheduleAppointmentEntityCopyWith<$R, PatientScheduleAppointmentEntity,
          $Out>
      get $asPatientScheduleAppointmentEntity => $base.as((v, t, t2) =>
          _PatientScheduleAppointmentEntityCopyWithImpl(v, t, t2));
}

abstract class PatientScheduleAppointmentEntityCopyWith<
    $R,
    $In extends PatientScheduleAppointmentEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {DateTime? timestamp,
      String? patientId,
      String? therapistId,
      int? mode,
      int? duration,
      String? appointmentName,
      String? serviceType});
  PatientScheduleAppointmentEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PatientScheduleAppointmentEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PatientScheduleAppointmentEntity, $Out>
    implements
        PatientScheduleAppointmentEntityCopyWith<$R,
            PatientScheduleAppointmentEntity, $Out> {
  _PatientScheduleAppointmentEntityCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PatientScheduleAppointmentEntity> $mapper =
      PatientScheduleAppointmentEntityMapper.ensureInitialized();
  @override
  $R call(
          {DateTime? timestamp,
          String? patientId,
          String? therapistId,
          int? mode,
          int? duration,
          String? appointmentName,
          String? serviceType}) =>
      $apply(FieldCopyWithData({
        if (timestamp != null) #timestamp: timestamp,
        if (patientId != null) #patientId: patientId,
        if (therapistId != null) #therapistId: therapistId,
        if (mode != null) #mode: mode,
        if (duration != null) #duration: duration,
        if (appointmentName != null) #appointmentName: appointmentName,
        if (serviceType != null) #serviceType: serviceType
      }));
  @override
  PatientScheduleAppointmentEntity $make(CopyWithData data) =>
      PatientScheduleAppointmentEntity(
          timestamp: data.get(#timestamp, or: $value.timestamp),
          patientId: data.get(#patientId, or: $value.patientId),
          therapistId: data.get(#therapistId, or: $value.therapistId),
          mode: data.get(#mode, or: $value.mode),
          duration: data.get(#duration, or: $value.duration),
          appointmentName:
              data.get(#appointmentName, or: $value.appointmentName),
          serviceType: data.get(#serviceType, or: $value.serviceType));

  @override
  PatientScheduleAppointmentEntityCopyWith<$R2,
      PatientScheduleAppointmentEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PatientScheduleAppointmentEntityCopyWithImpl($value, $cast, t);
}
