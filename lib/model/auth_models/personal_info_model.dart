
import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/core/entities/auth_entities/personal_info_entity.dart';

part 'personal_info_model.mapper.dart';

// Model class to store patient's personal information which will be used on UI
// This class can have toEntity and fromEntity methods to convert to and from entity

@MappableClass()
class PersonalInfoModel with PersonalInfoModelMappable  {

  final String patientId;
  final String patientName;
  final int age;
  final bool isAdult;
  final String phoneNo;
  final String email;
  final String guardianName;
  final String guardianRelation;
  final String gender;
  final String country;

  PersonalInfoModel({
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.isAdult,
    required this.phoneNo,
    required this.email,
    required this.guardianName,
    required this.guardianRelation,
    required this.country,
    required this.gender,
  });


  PersonalInfoEntity toEntity() {
    return PersonalInfoEntity(
      patientId: patientId,
      patientName: patientName,
      age: age,
      isAdult: isAdult,
      phoneNo: phoneNo,
      email: email,
      guardianName: guardianName,
      guardianRelation: guardianRelation,
      country: country,
      gender: gender,
    );
  }
}