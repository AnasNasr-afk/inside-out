// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapy_goal_model.dart';

class TherapyGoalModelMapper extends ClassMapperBase<TherapyGoalModel> {
  TherapyGoalModelMapper._();

  static TherapyGoalModelMapper? _instance;
  static TherapyGoalModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapyGoalModelMapper._());
      TherapyModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TherapyGoalModel';

  static DateTime _$performedOn(TherapyGoalModel v) => v.performedOn;
  static const Field<TherapyGoalModel, DateTime> _f$performedOn =
      Field('performedOn', _$performedOn, key: r'performed_on');
  static String? _$therapistId(TherapyGoalModel v) => v.therapistId;
  static const Field<TherapyGoalModel, String> _f$therapistId =
      Field('therapistId', _$therapistId, key: r'therapist_id', opt: true);
  static String _$therapyTypeId(TherapyGoalModel v) => v.therapyTypeId;
  static const Field<TherapyGoalModel, String> _f$therapyTypeId =
      Field('therapyTypeId', _$therapyTypeId, key: r'therapy_type_id');
  static List<TherapyModel> _$goals(TherapyGoalModel v) => v.goals;
  static const Field<TherapyGoalModel, List<TherapyModel>> _f$goals =
      Field('goals', _$goals);
  static List<TherapyModel> _$observations(TherapyGoalModel v) =>
      v.observations;
  static const Field<TherapyGoalModel, List<TherapyModel>> _f$observations =
      Field('observations', _$observations);
  static List<TherapyModel> _$regressions(TherapyGoalModel v) => v.regressions;
  static const Field<TherapyGoalModel, List<TherapyModel>> _f$regressions =
      Field('regressions', _$regressions);
  static List<TherapyModel> _$activities(TherapyGoalModel v) => v.activities;
  static const Field<TherapyGoalModel, List<TherapyModel>> _f$activities =
      Field('activities', _$activities);
  static int? _$duration(TherapyGoalModel v) => v.duration;
  static const Field<TherapyGoalModel, int> _f$duration =
      Field('duration', _$duration, opt: true);
  static String? _$therapistName(TherapyGoalModel v) => v.therapistName;
  static const Field<TherapyGoalModel, String> _f$therapistName =
      Field('therapistName', _$therapistName, key: r'name', opt: true);
  static String? _$therapistPhone(TherapyGoalModel v) => v.therapistPhone;
  static const Field<TherapyGoalModel, String> _f$therapistPhone =
      Field('therapistPhone', _$therapistPhone, key: r'phone', opt: true);
  static String? _$therapistEmail(TherapyGoalModel v) => v.therapistEmail;
  static const Field<TherapyGoalModel, String> _f$therapistEmail =
      Field('therapistEmail', _$therapistEmail, key: r'email', opt: true);
  static String? _$therapyType(TherapyGoalModel v) => v.therapyType;
  static const Field<TherapyGoalModel, String> _f$therapyType =
      Field('therapyType', _$therapyType, key: r'therapy_type', opt: true);
  static int? _$therapyMode(TherapyGoalModel v) => v.therapyMode;
  static const Field<TherapyGoalModel, int> _f$therapyMode =
      Field('therapyMode', _$therapyMode, key: r'therapy_mode', opt: true);
  static String? _$specialization(TherapyGoalModel v) => v.specialization;
  static const Field<TherapyGoalModel, String> _f$specialization =
      Field('specialization', _$specialization, opt: true);

  @override
  final MappableFields<TherapyGoalModel> fields = const {
    #performedOn: _f$performedOn,
    #therapistId: _f$therapistId,
    #therapyTypeId: _f$therapyTypeId,
    #goals: _f$goals,
    #observations: _f$observations,
    #regressions: _f$regressions,
    #activities: _f$activities,
    #duration: _f$duration,
    #therapistName: _f$therapistName,
    #therapistPhone: _f$therapistPhone,
    #therapistEmail: _f$therapistEmail,
    #therapyType: _f$therapyType,
    #therapyMode: _f$therapyMode,
    #specialization: _f$specialization,
  };

  static TherapyGoalModel _instantiate(DecodingData data) {
    return TherapyGoalModel(
        performedOn: data.dec(_f$performedOn),
        therapistId: data.dec(_f$therapistId),
        therapyTypeId: data.dec(_f$therapyTypeId),
        goals: data.dec(_f$goals),
        observations: data.dec(_f$observations),
        regressions: data.dec(_f$regressions),
        activities: data.dec(_f$activities),
        duration: data.dec(_f$duration),
        therapistName: data.dec(_f$therapistName),
        therapistPhone: data.dec(_f$therapistPhone),
        therapistEmail: data.dec(_f$therapistEmail),
        therapyType: data.dec(_f$therapyType),
        therapyMode: data.dec(_f$therapyMode),
        specialization: data.dec(_f$specialization));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapyGoalModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapyGoalModel>(map);
  }

  static TherapyGoalModel fromJson(String json) {
    return ensureInitialized().decodeJson<TherapyGoalModel>(json);
  }
}

mixin TherapyGoalModelMappable {
  String toJson() {
    return TherapyGoalModelMapper.ensureInitialized()
        .encodeJson<TherapyGoalModel>(this as TherapyGoalModel);
  }

  Map<String, dynamic> toMap() {
    return TherapyGoalModelMapper.ensureInitialized()
        .encodeMap<TherapyGoalModel>(this as TherapyGoalModel);
  }

  TherapyGoalModelCopyWith<TherapyGoalModel, TherapyGoalModel, TherapyGoalModel>
      get copyWith =>
          _TherapyGoalModelCopyWithImpl<TherapyGoalModel, TherapyGoalModel>(
              this as TherapyGoalModel, $identity, $identity);
  @override
  String toString() {
    return TherapyGoalModelMapper.ensureInitialized()
        .stringifyValue(this as TherapyGoalModel);
  }

  @override
  bool operator ==(Object other) {
    return TherapyGoalModelMapper.ensureInitialized()
        .equalsValue(this as TherapyGoalModel, other);
  }

  @override
  int get hashCode {
    return TherapyGoalModelMapper.ensureInitialized()
        .hashValue(this as TherapyGoalModel);
  }
}

extension TherapyGoalModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapyGoalModel, $Out> {
  TherapyGoalModelCopyWith<$R, TherapyGoalModel, $Out>
      get $asTherapyGoalModel => $base
          .as((v, t, t2) => _TherapyGoalModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TherapyGoalModelCopyWith<$R, $In extends TherapyGoalModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get goals;
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get observations;
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get regressions;
  ListCopyWith<$R, TherapyModel,
      TherapyModelCopyWith<$R, TherapyModel, TherapyModel>> get activities;
  $R call(
      {DateTime? performedOn,
      String? therapistId,
      String? therapyTypeId,
      List<TherapyModel>? goals,
      List<TherapyModel>? observations,
      List<TherapyModel>? regressions,
      List<TherapyModel>? activities,
      int? duration,
      String? therapistName,
      String? therapistPhone,
      String? therapistEmail,
      String? therapyType,
      int? therapyMode,
      String? specialization});
  TherapyGoalModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapyGoalModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapyGoalModel, $Out>
    implements TherapyGoalModelCopyWith<$R, TherapyGoalModel, $Out> {
  _TherapyGoalModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapyGoalModel> $mapper =
      TherapyGoalModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get goals => ListCopyWith(
          $value.goals, (v, t) => v.copyWith.$chain(t), (v) => call(goals: v));
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get observations => ListCopyWith($value.observations,
          (v, t) => v.copyWith.$chain(t), (v) => call(observations: v));
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get regressions => ListCopyWith($value.regressions,
          (v, t) => v.copyWith.$chain(t), (v) => call(regressions: v));
  @override
  ListCopyWith<$R, TherapyModel,
          TherapyModelCopyWith<$R, TherapyModel, TherapyModel>>
      get activities => ListCopyWith($value.activities,
          (v, t) => v.copyWith.$chain(t), (v) => call(activities: v));
  @override
  $R call(
          {DateTime? performedOn,
          Object? therapistId = $none,
          String? therapyTypeId,
          List<TherapyModel>? goals,
          List<TherapyModel>? observations,
          List<TherapyModel>? regressions,
          List<TherapyModel>? activities,
          Object? duration = $none,
          Object? therapistName = $none,
          Object? therapistPhone = $none,
          Object? therapistEmail = $none,
          Object? therapyType = $none,
          Object? therapyMode = $none,
          Object? specialization = $none}) =>
      $apply(FieldCopyWithData({
        if (performedOn != null) #performedOn: performedOn,
        if (therapistId != $none) #therapistId: therapistId,
        if (therapyTypeId != null) #therapyTypeId: therapyTypeId,
        if (goals != null) #goals: goals,
        if (observations != null) #observations: observations,
        if (regressions != null) #regressions: regressions,
        if (activities != null) #activities: activities,
        if (duration != $none) #duration: duration,
        if (therapistName != $none) #therapistName: therapistName,
        if (therapistPhone != $none) #therapistPhone: therapistPhone,
        if (therapistEmail != $none) #therapistEmail: therapistEmail,
        if (therapyType != $none) #therapyType: therapyType,
        if (therapyMode != $none) #therapyMode: therapyMode,
        if (specialization != $none) #specialization: specialization
      }));
  @override
  TherapyGoalModel $make(CopyWithData data) => TherapyGoalModel(
      performedOn: data.get(#performedOn, or: $value.performedOn),
      therapistId: data.get(#therapistId, or: $value.therapistId),
      therapyTypeId: data.get(#therapyTypeId, or: $value.therapyTypeId),
      goals: data.get(#goals, or: $value.goals),
      observations: data.get(#observations, or: $value.observations),
      regressions: data.get(#regressions, or: $value.regressions),
      activities: data.get(#activities, or: $value.activities),
      duration: data.get(#duration, or: $value.duration),
      therapistName: data.get(#therapistName, or: $value.therapistName),
      therapistPhone: data.get(#therapistPhone, or: $value.therapistPhone),
      therapistEmail: data.get(#therapistEmail, or: $value.therapistEmail),
      therapyType: data.get(#therapyType, or: $value.therapyType),
      therapyMode: data.get(#therapyMode, or: $value.therapyMode),
      specialization: data.get(#specialization, or: $value.specialization));

  @override
  TherapyGoalModelCopyWith<$R2, TherapyGoalModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapyGoalModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
