import 'package:dart_mappable/dart_mappable.dart';

part 'therapist_model.mapper.dart';

@MappableClass()
class TherapistModel with TherapistModelMappable {
  @MappableField(key: 'id')
  final String id;
  @MappableField(key: 'created_at')
  final DateTime createdAt;
  @MappableField(key: 'name')
  final String name;
  @MappableField(key: 'email')
  final String email;
  @MappableField(key: 'phone')
  final String phone;
  @MappableField(key: 'clinic_id')
  final String clinicId;
  @MappableField(key: 'approved')
  final bool approved;
  @MappableField(key: 'specialisation')
  final String specialisation;
  @MappableField(key: 'gender')
  final String gender;
  @MappableField(key: 'offered_therapies')
  final List<String> offeredTherapies;
  @MappableField(key: 'age')
  final int age;
  @MappableField(key: 'regulatory_body')
  final String regulatoryBody;
  @MappableField(key: 'start_availability_time')
  final String startAvailabilityTime;
  @MappableField(key: 'end_availability_time')
  final String endAvailabilityTime;


  TherapistModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.email,
    required this.phone,
    required this.clinicId,
    required this.approved,
    required this.specialisation,
    required this.gender,
    required this.offeredTherapies,
    required this.age,
    required this.regulatoryBody,
    required this.startAvailabilityTime,
    required this.endAvailabilityTime,
  });
}