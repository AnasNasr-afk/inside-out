// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'therapist_entity.dart';

class TherapistEntityMapper extends ClassMapperBase<TherapistEntity> {
  TherapistEntityMapper._();

  static TherapistEntityMapper? _instance;
  static TherapistEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TherapistEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TherapistEntity';

  static String _$id(TherapistEntity v) => v.id;
  static const Field<TherapistEntity, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(TherapistEntity v) => v.createdAt;
  static const Field<TherapistEntity, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$name(TherapistEntity v) => v.name;
  static const Field<TherapistEntity, String> _f$name = Field('name', _$name);
  static String _$email(TherapistEntity v) => v.email;
  static const Field<TherapistEntity, String> _f$email =
      Field('email', _$email);
  static String _$phone(TherapistEntity v) => v.phone;
  static const Field<TherapistEntity, String> _f$phone =
      Field('phone', _$phone);
  static String _$clinicId(TherapistEntity v) => v.clinicId;
  static const Field<TherapistEntity, String> _f$clinicId =
      Field('clinicId', _$clinicId, key: r'clinic_id');
  static bool _$approved(TherapistEntity v) => v.approved;
  static const Field<TherapistEntity, bool> _f$approved =
      Field('approved', _$approved);
  static String _$specialisation(TherapistEntity v) => v.specialisation;
  static const Field<TherapistEntity, String> _f$specialisation =
      Field('specialisation', _$specialisation);
  static String _$gender(TherapistEntity v) => v.gender;
  static const Field<TherapistEntity, String> _f$gender =
      Field('gender', _$gender);
  static List<String> _$offeredTherapies(TherapistEntity v) =>
      v.offeredTherapies;
  static const Field<TherapistEntity, List<String>> _f$offeredTherapies =
      Field('offeredTherapies', _$offeredTherapies, key: r'offered_therapies');
  static int _$age(TherapistEntity v) => v.age;
  static const Field<TherapistEntity, int> _f$age = Field('age', _$age);
  static String _$regulatoryBody(TherapistEntity v) => v.regulatoryBody;
  static const Field<TherapistEntity, String> _f$regulatoryBody =
      Field('regulatoryBody', _$regulatoryBody, key: r'regulatory_body');
  static String _$startAvailabilityTime(TherapistEntity v) =>
      v.startAvailabilityTime;
  static const Field<TherapistEntity, String> _f$startAvailabilityTime = Field(
      'startAvailabilityTime', _$startAvailabilityTime,
      key: r'start_availability_time');
  static String _$endAvailabilityTime(TherapistEntity v) =>
      v.endAvailabilityTime;
  static const Field<TherapistEntity, String> _f$endAvailabilityTime = Field(
      'endAvailabilityTime', _$endAvailabilityTime,
      key: r'end_availability_time');

  @override
  final MappableFields<TherapistEntity> fields = const {
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

  static TherapistEntity _instantiate(DecodingData data) {
    return TherapistEntity(
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

  static TherapistEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TherapistEntity>(map);
  }

  static TherapistEntity fromJson(String json) {
    return ensureInitialized().decodeJson<TherapistEntity>(json);
  }
}

mixin TherapistEntityMappable {
  String toJson() {
    return TherapistEntityMapper.ensureInitialized()
        .encodeJson<TherapistEntity>(this as TherapistEntity);
  }

  Map<String, dynamic> toMap() {
    return TherapistEntityMapper.ensureInitialized()
        .encodeMap<TherapistEntity>(this as TherapistEntity);
  }

  TherapistEntityCopyWith<TherapistEntity, TherapistEntity, TherapistEntity>
      get copyWith =>
          _TherapistEntityCopyWithImpl<TherapistEntity, TherapistEntity>(
              this as TherapistEntity, $identity, $identity);
  @override
  String toString() {
    return TherapistEntityMapper.ensureInitialized()
        .stringifyValue(this as TherapistEntity);
  }

  @override
  bool operator ==(Object other) {
    return TherapistEntityMapper.ensureInitialized()
        .equalsValue(this as TherapistEntity, other);
  }

  @override
  int get hashCode {
    return TherapistEntityMapper.ensureInitialized()
        .hashValue(this as TherapistEntity);
  }
}

extension TherapistEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TherapistEntity, $Out> {
  TherapistEntityCopyWith<$R, TherapistEntity, $Out> get $asTherapistEntity =>
      $base.as((v, t, t2) => _TherapistEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TherapistEntityCopyWith<$R, $In extends TherapistEntity, $Out>
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
  TherapistEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TherapistEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TherapistEntity, $Out>
    implements TherapistEntityCopyWith<$R, TherapistEntity, $Out> {
  _TherapistEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TherapistEntity> $mapper =
      TherapistEntityMapper.ensureInitialized();
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
  TherapistEntity $make(CopyWithData data) => TherapistEntity(
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
  TherapistEntityCopyWith<$R2, TherapistEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TherapistEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
