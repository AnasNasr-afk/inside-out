// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapist_model.dart';

class TherapistModelMapper extends ClassMapperBase<TherapistModel> {
  TherapistModelMapper._();

  static TherapistModelMapper? _instance;
  static TherapistModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapistModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapistModel';

  static String _$id(TherapistModel v) => v.id;
  static const Field<TherapistModel, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(TherapistModel v) => v.createdAt;
  static const Field<TherapistModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$name(TherapistModel v) => v.name;
  static const Field<TherapistModel, String> _f$name = Field('name', _$name);
  static String _$email(TherapistModel v) => v.email;
  static const Field<TherapistModel, String> _f$email = Field('email', _$email);
  static String _$phone(TherapistModel v) => v.phone;
  static const Field<TherapistModel, String> _f$phone = Field('phone', _$phone);
  static String _$clinicId(TherapistModel v) => v.clinicId;
  static const Field<TherapistModel, String> _f$clinicId =
      Field('clinicId', _$clinicId, key: r'clinic_id');
  static bool _$approved(TherapistModel v) => v.approved;
  static const Field<TherapistModel, bool> _f$approved =
      Field('approved', _$approved);
  static String _$specialisation(TherapistModel v) => v.specialisation;
  static const Field<TherapistModel, String> _f$specialisation =
      Field('specialisation', _$specialisation);
  static String _$gender(TherapistModel v) => v.gender;
  static const Field<TherapistModel, String> _f$gender =
      Field('gender', _$gender);
  static List<String> _$offeredTherapies(TherapistModel v) =>
      v.offeredTherapies;
  static const Field<TherapistModel, List<String>> _f$offeredTherapies =
      Field('offeredTherapies', _$offeredTherapies, key: r'offered_therapies');
  static int _$age(TherapistModel v) => v.age;
  static const Field<TherapistModel, int> _f$age = Field('age', _$age);
  static String _$regulatoryBody(TherapistModel v) => v.regulatoryBody;
  static const Field<TherapistModel, String> _f$regulatoryBody =
      Field('regulatoryBody', _$regulatoryBody, key: r'regulatory_body');
  static String _$startAvailabilityTime(TherapistModel v) =>
      v.startAvailabilityTime;
  static const Field<TherapistModel, String> _f$startAvailabilityTime = Field(
      'startAvailabilityTime', _$startAvailabilityTime,
      key: r'start_availability_time');
  static String _$endAvailabilityTime(TherapistModel v) =>
      v.endAvailabilityTime;
  static const Field<TherapistModel, String> _f$endAvailabilityTime = Field(
      'endAvailabilityTime', _$endAvailabilityTime,
      key: r'end_availability_time');

  @override
  final MappableFields<TherapistModel> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #name: _f$name,
    #email: _f$email,
    #phone: _f$phone,
    #clinicId: _f$clinicId,
    #approved: _f$approved,
    #specialisation: _f$specialisation,
    #gender: _f$gender,
    #offeredTherapies: _f$offeredTherapies,
    #age: _f$age,
    #regulatoryBody: _f$regulatoryBody,
    #startAvailabilityTime: _f$startAvailabilityTime,
    #endAvailabilityTime: _f$endAvailabilityTime,
  };

  static TherapistModel _instantiate(DecodingData data) {
    return TherapistModel(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        name: data.dec(_f$name),
        email: data.dec(_f$email),
        phone: data.dec(_f$phone),
        clinicId: data.dec(_f$clinicId),
        approved: data.dec(_f$approved),
        specialisation: data.dec(_f$specialisation),
        gender: data.dec(_f$gender),
        offeredTherapies: data.dec(_f$offeredTherapies),
        age: data.dec(_f$age),
        regulatoryBody: data.dec(_f$regulatoryBody),
        startAvailabilityTime: data.dec(_f$startAvailabilityTime),
        endAvailabilityTime: data.dec(_f$endAvailabilityTime));
  }

  @override
  final Function instantiate = _instantiate;

  static TherapistModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapistModel>(map);
  }

  static TherapistModel fromJson(String json) {
    return ensureInitialized().decodeJson<TherapistModel>(json);
  }
}

mixin TherapistModelMappable {
  String toJson() {
    return TherapistModelMapper.ensureInitialized()
        .encodeJson<TherapistModel>(this as TherapistModel);
  }

  Map<String, dynamic> toMap() {
    return TherapistModelMapper.ensureInitialized()
        .encodeMap<TherapistModel>(this as TherapistModel);
  }

  TherapistModelCopyWith<TherapistModel, TherapistModel, TherapistModel>
      get copyWith =>
          _TherapistModelCopyWithImpl<TherapistModel, TherapistModel>(
              this as TherapistModel, $identity, $identity);
  @override
  String toString() {
    return TherapistModelMapper.ensureInitialized()
        .stringifyValue(this as TherapistModel);
  }

  @override
  bool operator ==(Object other) {
    return TherapistModelMapper.ensureInitialized()
        .equalsValue(this as TherapistModel, other);
  }

  @override
  int get hashCode {
    return TherapistModelMapper.ensureInitialized()
        .hashValue(this as TherapistModel);
  }
}

extension TherapistModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapistModel, $Out> {
  TherapistModelCopyWith<$R, TherapistModel, $Out> get $asTherapistModel =>
      $base.as((v, t, t2) => _TherapistModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TherapistModelCopyWith<$R, $In extends TherapistModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get offeredTherapies;
  $R call(
      {String? id,
      DateTime? createdAt,
      String? name,
      String? email,
      String? phone,
      String? clinicId,
      bool? approved,
      String? specialisation,
      String? gender,
      List<String>? offeredTherapies,
      int? age,
      String? regulatoryBody,
      String? startAvailabilityTime,
      String? endAvailabilityTime});
  TherapistModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapistModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapistModel, $Out>
    implements TherapistModelCopyWith<$R, TherapistModel, $Out> {
  _TherapistModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapistModel> $mapper =
      TherapistModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get offeredTherapies => ListCopyWith(
          $value.offeredTherapies,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(offeredTherapies: v));
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          String? name,
          String? email,
          String? phone,
          String? clinicId,
          bool? approved,
          String? specialisation,
          String? gender,
          List<String>? offeredTherapies,
          int? age,
          String? regulatoryBody,
          String? startAvailabilityTime,
          String? endAvailabilityTime}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (name != null) #name: name,
        if (email != null) #email: email,
        if (phone != null) #phone: phone,
        if (clinicId != null) #clinicId: clinicId,
        if (approved != null) #approved: approved,
        if (specialisation != null) #specialisation: specialisation,
        if (gender != null) #gender: gender,
        if (offeredTherapies != null) #offeredTherapies: offeredTherapies,
        if (age != null) #age: age,
        if (regulatoryBody != null) #regulatoryBody: regulatoryBody,
        if (startAvailabilityTime != null)
          #startAvailabilityTime: startAvailabilityTime,
        if (endAvailabilityTime != null)
          #endAvailabilityTime: endAvailabilityTime
      }));
  @override
  TherapistModel $make(CopyWithData data) => TherapistModel(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      name: data.get(#name, or: $value.name),
      email: data.get(#email, or: $value.email),
      phone: data.get(#phone, or: $value.phone),
      clinicId: data.get(#clinicId, or: $value.clinicId),
      approved: data.get(#approved, or: $value.approved),
      specialisation: data.get(#specialisation, or: $value.specialisation),
      gender: data.get(#gender, or: $value.gender),
      offeredTherapies:
          data.get(#offeredTherapies, or: $value.offeredTherapies),
      age: data.get(#age, or: $value.age),
      regulatoryBody: data.get(#regulatoryBody, or: $value.regulatoryBody),
      startAvailabilityTime:
          data.get(#startAvailabilityTime, or: $value.startAvailabilityTime),
      endAvailabilityTime:
          data.get(#endAvailabilityTime, or: $value.endAvailabilityTime));

  @override
  TherapistModelCopyWith<$R2, TherapistModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapistModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
