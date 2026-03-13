import 'package:dart_mappable/dart_mappable.dart';


part 'therapy_entity.mapper.dart';

@MappableClass()
class TherapyEntity with TherapyEntityMappable {

  final String id;

  final String name;

  TherapyEntity({
    required this.id,
    required this.name,
  });


}