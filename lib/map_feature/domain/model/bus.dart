import 'line.dart';
import 'map_entity.dart';

class Bus extends MapEntity {
  final BusState state;
  final int capacity;
  final Line line;

  // Va changer très souvent
  final bool isAccessible;

  const Bus(
      {required this.state,
      required this.capacity,
      required this.line,
      required this.isAccessible,
      required super.entityPosition,
      required super.entityName});
}

enum BusState {
  // ignore: constant_identifier_names
  CROWDED,
  // ignore: constant_identifier_names
  HALFCROWDED,
  // ignore: constant_identifier_names
  EMPTY,
  // ignore: constant_identifier_names
  UNKNOWN,
}
