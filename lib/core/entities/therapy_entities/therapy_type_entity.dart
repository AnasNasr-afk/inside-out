
import 'package:dart_mappable/dart_mappable.dart';

part 'therapy_type_entity.mapper.dart';

@MappableClass()
class TherapyTypeEntity with TherapyTypeEntityMappable {

  @MappableField(key: 'id')
  final String therapyId;

  @MappableField(key: 'created_at')
  final DateTime createdAt;

  @MappableField(key: 'name')
  final String name;

  @MappableField(key: 'description')
  final String description;

  TherapyTypeEntity({
    required this.therapyId,
    required this.createdAt,
    required this.name,
    required this.description,
  });

} 