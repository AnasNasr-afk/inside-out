class ParentChildResponseModel {
  final String parentPhone;
  final String parentEmail;
  final String childName;
  final int age;
  final String description;
  final String parentName;
  final String specialistName;
  final String specialistEmail;

  ParentChildResponseModel({
    required this.parentPhone,
    required this.parentEmail,
    required this.childName,
    required this.age,
    required this.description,
    required this.parentName,
    required this.specialistName,
    required this.specialistEmail,
  });

  factory ParentChildResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ParentChildResponseModel(
      parentPhone: json['parentPhone'] ?? '',
      parentEmail: json['parentEmail'] ?? '',
      childName: json['childName'] ?? '',
      age: json['age'] ?? 0,
      description: json['description'] ?? '',
      parentName: json['parentName'] ?? '',
      specialistName: json['specialistName'] ?? '',
      specialistEmail: json['specialistEmail'] ?? '',
    );
  }
}