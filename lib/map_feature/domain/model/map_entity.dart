import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEntity{
  final LatLng entityPosition;
  final String entityName;

  const MapEntity({required this.entityName, required this.entityPosition});

}