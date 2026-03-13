import 'package:dart_mappable/dart_mappable.dart';


part 'therapy_model.mapper.dart';

@MappableClass()
class TherapyModel with TherapyModelMappable {

  final String id;

  final String name;

  TherapyModel({
    required this.id,
    required this.name,
  });

}