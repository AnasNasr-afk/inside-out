import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChildProfile {
  final String name;
  final int age;
  final String medicalCase;

  const ChildProfile({
    this.name = '',
    this.age = 0,
    this.medicalCase = '',
  });

  bool get isPopulated => name.isNotEmpty || medicalCase.isNotEmpty;
}

final childProfileProvider = StateProvider<ChildProfile>(
  (ref) => const ChildProfile(),
);
