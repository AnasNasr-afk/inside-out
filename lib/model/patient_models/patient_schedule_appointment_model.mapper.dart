// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'patient_schedule_appointment_model.dart';

class PatientScheduleAppointmentModelMapper
    extends ClassMapperBase<PatientScheduleAppointmentModel> {
  PatientScheduleAppointmentModelMapper._();

  static PatientScheduleAppointmentModelMapper? _instance;
  static PatientScheduleAppointmentModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = PatientScheduleAppointmentModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PatientScheduleAppointmentModel';

  static String _$patientId(PatientScheduleAppointmentModel v) => v.patientId;
  static const Field<PatientScheduleAppointmentModel, String> _f$patientId =
      Field('patientId', _$patientId);
  static String _$therapistId(PatientScheduleAppointmentModel v) =>
      v.therapistId;
  static const Field<PatientScheduleAppointmentModel, String> _f$therapistId =
      Field('therapistId', _$therapistId);
  static String _$serviceType(PatientScheduleAppointmentModel v) =>
      v.serviceType;
  static const Field<PatientScheduleAppointmentModel, String> _f$serviceType =
      Field('serviceType', _$serviceType);
  static String _$date(PatientScheduleAppointmentModel v) => v.date;
  static const Field<PatientScheduleAppointmentModel, String> _f$date =
      Field('date', _$date);
  static String _$slot(PatientScheduleAppointmentModel v) => v.slot;
  static const Field<PatientScheduleAppointmentModel, String> _f$slot =
      Field('slot', _$slot);
  static String _$appointmentName(PatientScheduleAppointmentModel v) =>
      v.appointmentName;
  static const Field<PatientScheduleAppointmentModel, String>
      _f$appointmentName = Field('appointmentName', _$appointmentName);

  @override
  final MappableFields<PatientScheduleAppointmentModel> fields = const {
    #patientId: _f$patientId,
    #therapistId: _f$therapistId,
    #serviceType: _f$serviceType,
    #date: _f$date,
    #slot: _f$slot,
    #appointmentName: _f$appointmentName,
  };

  static PatientScheduleAppointmentModel _instantiate(DecodingData data) {
    return PatientScheduleAppointmentModel(
        patientId: data.dec(_f$patientId),
        therapistId: data.dec(_f$therapistId),
        serviceType: data.dec(_f$serviceType),
        date: data.dec(_f$date),
        slot: data.dec(_f$slot),
        appointmentName: data.dec(_f$appointmentName));
  }

  @override
  final Function instantiate = _instantiate;

  static PatientScheduleAppointmentModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PatientScheduleAppointmentModel>(map);
  }

  static PatientScheduleAppointmentModel fromJson(String json) {
    return ensureInitialized()
        .decodeJson<PatientScheduleAppointmentModel>(json);
  }
}

mixin PatientScheduleAppointmentModelMappable {
  String toJson() {
    return PatientScheduleAppointmentModelMapper.ensureInitialized()
        .encodeJson<PatientScheduleAppointmentModel>(
            this as PatientScheduleAppointmentModel);
  }

  Map<String, dynamic> toMap() {
    return PatientScheduleAppointmentModelMapper.ensureInitialized()
        .encodeMap<PatientScheduleAppointmentModel>(
            this as PatientScheduleAppointmentModel);
  }

  PatientScheduleAppointmentModelCopyWith<PatientScheduleAppointmentModel,
          PatientScheduleAppointmentModel, PatientScheduleAppointmentModel>
      get copyWith => _PatientScheduleAppointmentModelCopyWithImpl(
          this as PatientScheduleAppointmentModel, $identity, $identity);
  @override
  String toString() {
    return PatientScheduleAppointmentModelMapper.ensureInitialized()
        .stringifyValue(this as PatientScheduleAppointmentModel);
  }

  @override
  bool operator ==(Object other) {
    return PatientScheduleAppointmentModelMapper.ensureInitialized()
        .equalsValue(this as PatientScheduleAppointmentModel, other);
  }

  @override
  int get hashCode {
    return PatientScheduleAppointmentModelMapper.ensureInitialized()
        .hashValue(this as PatientScheduleAppointmentModel);
  }
}

extension PatientScheduleAppointmentModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PatientScheduleAppointmentModel, $Out> {
  PatientScheduleAppointmentModelCopyWith<$R, PatientScheduleAppointmentModel,
          $Out>
      get $asPatientScheduleAppointmentModel => $base.as(
          (v, t, t2) => _PatientScheduleAppointmentModelCopyWithImpl(v, t, t2));
}

abstract class PatientScheduleAppointmentModelCopyWith<
    $R,
    $In extends PatientScheduleAppointmentModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? patientId,
      String? therapistId,
      String? serviceType,
      String? date,
      String? slot,
      String? appointmentName});
  PatientScheduleAppointmentModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PatientScheduleAppointmentModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PatientScheduleAppointmentModel, $Out>
    implements
        PatientScheduleAppointmentModelCopyWith<$R,
            PatientScheduleAppointmentModel, $Out> {
  _PatientScheduleAppointmentModelCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PatientScheduleAppointmentModel> $mapper =
      PatientScheduleAppointmentModelMapper.ensureInitialized();
  @override
  $R call(
          {String? patientId,
          String? therapistId,
          String? serviceType,
          String? date,
          String? slot,
          String? appointmentName}) =>
      $apply(FieldCopyWithData({
        if (patientId != null) #patientId: patientId,
        if (therapistId != null) #therapistId: therapistId,
        if (serviceType != null) #serviceType: serviceType,
        if (date != null) #date: date,
        if (slot != null) #slot: slot,
        if (appointmentName != null) #appointmentName: appointmentName
      }));
  @override
  PatientScheduleAppointmentModel $make(CopyWithData data) =>
      PatientScheduleAppointmentModel(
          patientId: data.get(#patientId, or: $value.patientId),
          therapistId: data.get(#therapistId, or: $value.therapistId),
          serviceType: data.get(#serviceType, or: $value.serviceType),
          date: data.get(#date, or: $value.date),
          slot: data.get(#slot, or: $value.slot),
          appointmentName:
              data.get(#appointmentName, or: $value.appointmentName));

  @override
  PatientScheduleAppointmentModelCopyWith<$R2, PatientScheduleAppointmentModel,
      $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PatientScheduleAppointmentModelCopyWithImpl($value, $cast, t);
}
