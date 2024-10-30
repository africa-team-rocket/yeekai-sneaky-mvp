import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_entity.dart';

class Place extends MapEntity {
  // PlaceName et StopName n'ont à vrai dire pas leur place ici, ça peut juste être "title" dans MapEntity
  // Mais on garde quand même comme ça car flemme de modifier, en plus, une fois connecté au back on aura
  // plus de contenu ici
  final String placeName;

  const Place({required this.placeName, required super.entityPosition, required super.entityName});

  Place copyWith({
    String? entityName,
    String? placeName,
    LatLng? entityPosition
  }){
    return Place(
      entityName: entityName ?? this.entityName, placeName: placeName ?? this.placeName, entityPosition: entityPosition ?? this.entityPosition,
    );
  }

}