class SignupRequestModel {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber; // ← was 'phone'
  final String city;        // ← missing
  final String street;      // ← missing
  final List<Child> children; // ← was single Child, now a List

  SignupRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.city,
    required this.street,
    required this.children,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'city': city,
    'street': street,
    'children': children.map((c) => c.toJson()).toList(),
  };
}

class Child {
  final int id;
  final String name;
  final int age;
  final String description; // ← was 'caseType'

  Child({
    this.id = 0,
    required this.name,
    required this.age,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'description': description,
  };
}