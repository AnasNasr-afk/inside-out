// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'consultation_request_model.dart';

class ConsultationRequestModelMapper
    extends ClassMapperBase<ConsultationRequestModel> {
  ConsultationRequestModelMapper._();

  static ConsultationRequestModelMapper? _instance;
  static ConsultationRequestModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = ConsultationRequestModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ConsultationRequestModel';

  static DateTime? _$timestamp(ConsultationRequestModel v) => v.timestamp;
  static const Field<ConsultationRequestModel, DateTime> _f$timestamp =
      Field('timestamp', _$timestamp, opt: true);
  static String? _$therapistId(ConsultationRequestModel v) => v.therapistId;
  static const Field<ConsultationRequestModel, String> _f$therapistId =
      Field('therapistId', _$therapistId, key: r'therapist_id', opt: true);
  static String? _$patientId(ConsultationRequestModel v) => v.patientId;
  static const Field<ConsultationRequestModel, String> _f$patientId =
      Field('patientId', _$patientId, key: r'patient_id', opt: true);
  static bool? _$isConsultation(ConsultationRequestModel v) => v.isConsultation;
  static const Field<ConsultationRequestModel, bool> _f$isConsultation = Field(
      'isConsultation', _$isConsultation,
      key: r'is_consultation', opt: true);
  static int? _$mode(ConsultationRequestModel v) => v.mode;
  static const Field<ConsultationRequestModel, int> _f$mode =
      Field('mode', _$mode, opt: true);
  static int? _$duration(ConsultationRequestModel v) => v.duration;
  static const Field<ConsultationRequestModel, int> _f$duration =
      Field('duration', _$duration, opt: true);
  static String? _$name(ConsultationRequestModel v) => v.name;
  static const Field<ConsultationRequestModel, String> _f$name =
      Field('name', _$name, opt: true);
  static String? _$status(ConsultationRequestModel v) => v.status;
  static const Field<ConsultationRequestModel, String> _f$status =
      Field('status', _$status, opt: true);

  @override
  final MappableFields<ConsultationRequestModel> fields = const {
    #timestamp: _f$timestamp,
    #therapistId: _f$therapistId,
    #patientId: _f$patientId,
    #isConsultation: _f$isConsultation,
    #mode: _f$mode,
    #duration: _f$duration,
    #name: _f$name,
    #status: _f$status,
  };

  static ConsultationRequestModel _instantiate(DecodingData data) {
    return ConsultationRequestModel(
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

  static ConsultationRequestModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConsultationRequestModel>(map);
  }

  static ConsultationRequestModel fromJson(String json) {
    return ensureInitialized().decodeJson<ConsultationRequestModel>(json);
  }
}

mixin ConsultationRequestModelMappable {
  String toJson() {
    return ConsultationRequestModelMapper.ensureInitialized()
        .encodeJson<ConsultationRequestModel>(this as ConsultationRequestModel);
  }

  Map<String, dynamic> toMap() {
    return ConsultationRequestModelMapper.ensureInitialized()
        .encodeMap<ConsultationRequestModel>(this as ConsultationRequestModel);
  }

  ConsultationRequestModelCopyWith<ConsultationRequestModel,
          ConsultationRequestModel, ConsultationRequestModel>
      get copyWith => _ConsultationRequestModelCopyWithImpl<
              ConsultationRequestModel, ConsultationRequestModel>(
          this as ConsultationRequestModel, $identity, $identity);
  @override
  String toString() {
    return ConsultationRequestModelMapper.ensureInitialized()
        .stringifyValue(this as ConsultationRequestModel);
  }

  @override
  bool operator ==(Object other) {
    return ConsultationRequestModelMapper.ensureInitialized()
        .equalsValue(this as ConsultationRequestModel, other);
  }

  @override
  int get hashCode {
    return ConsultationRequestModelMapper.ensureInitialized()
        .hashValue(this as ConsultationRequestModel);
  }
}

extension ConsultationRequestModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConsultationRequestModel, $Out> {
  ConsultationRequestModelCopyWith<$R, ConsultationRequestModel, $Out>
      get $asConsultationRequestModel => $base.as((v, t, t2) =>
          _ConsultationRequestModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConsultationRequestModelCopyWith<
    $R,
    $In extends ConsultationRequestModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {DateTime? timestamp,
      String? therapistId,
      String? patientId,
      bool? isConsultation,
      int? mode,
      int? duration,
      String? name,
      String? status});
  ConsultationRequestModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ConsultationRequestModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConsultationRequestModel, $Out>
    implements
        ConsultationRequestModelCopyWith<$R, ConsultationRequestModel, $Out> {
  _ConsultationRequestModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConsultationRequestModel> $mapper =
      ConsultationRequestModelMapper.ensureInitialized();
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
  ConsultationRequestModel $make(CopyWithData data) => ConsultationRequestModel(
      timestamp: data.get(#timestamp, or: $value.timestamp),
      therapistId: data.get(#therapistId, or: $value.therapistId),
      patientId: data.get(#patientId, or: $value.patientId),
      isConsultation: data.get(#isConsultation, or: $value.isConsultation),
      mode: data.get(#mode, or: $value.mode),
      duration: data.get(#duration, or: $value.duration),
      name: data.get(#name, or: $value.name),
      status: data.get(#status, or: $value.status));

  @override
  ConsultationRequestModelCopyWith<$R2, ConsultationRequestModel, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ConsultationRequestModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
