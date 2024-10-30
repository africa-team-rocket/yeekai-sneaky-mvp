import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map_feature/domain/model/map_entity.dart';

class Stop extends MapEntity {
  // PlaceName et StopName n'ont à vrai dire pas leur place ici, ça peut juste être "title" dans MapEntity
  // Mais on garde quand même comme ça car flemme de modifier, en plus, une fois connecté au back on aura
  // plus de contenu ici
  final String stopName;

  const Stop({required this.stopName, required super.entityPosition, required super.entityName});

  Stop copyWith({
    String? entityName,
    String? stopName,
    LatLng? entityPosition

  }){
    return Stop(
      entityName: entityName ?? this.entityName, stopName: stopName ?? this.stopName, entityPosition: entityPosition ?? this.entityPosition,
    );
  }

}