import 'package:flutter/cupertino.dart';

// import '../../data/local/entities/search_hit_local_entity.dart';
// import '../../data/remote/rest/google_places/dto/place_search_hit_dto.dart';


abstract class SearchHitEntity {
  final String entityType;

  SearchHitEntity(this.entityType);

  factory SearchHitEntity.fromJson(Map<String, dynamic> json) {
    debugPrint("Avant tout voici le json : ");
    debugPrint(json.toString());
    if (json['entity_type'] == 'stop') {
      return SearchHitStop.fromJson(json);
    } else if (json['entity_type'] == 'route') {
      return SearchHitRoute.fromJson(json);
    } else {
      throw ArgumentError('Invalid entity_type: ${json['entity_type']}');
    }
  }

  // factory SearchHitEntity.fromDao(SearchHitLocalEntity dao) {
  //   if (dao.entityType == 'stop') {
  //     if (dao is SearchHitLocalStop) {
  //       return SearchHitStop(dao.entityType, dao.stopId, dao.stopName, dao.stopLat, dao.stopLon);
  //     } else {
  //       throw ArgumentError('Invalid entity_type: ${dao.entityType}');
  //     }
  //   } else if (dao.entityType == 'route') {
  //     if (dao is SearchHitLocalRoute) {
  //       return SearchHitRoute(dao.entityType, dao.routeId, dao.agencyId, dao.routeShortName, dao.routeLongName);
  //     } else {
  //       throw ArgumentError('Invalid entity_type: ${dao.entityType}');
  //     }
  //   } else if (dao.entityType == 'place') {
  //     if (dao is SearchHitLocalPlace) {
  //       return SearchHitPlace(dao.entityType, dao.title, dao.subTitle, dao.placeId, dao.reference, dao.description);
  //     } else {
  //       throw ArgumentError('Invalid entity_type: ${dao.entityType}');
  //     }
  //   } else {
  //     throw ArgumentError('Invalid entity_type: ${dao.entityType}');
  //   }
  // }
  //

  @override
  String toString() {
    return 'SearchHitEntity{entityType: $entityType}';
  }
}

class SearchHitStop extends SearchHitEntity {
  final int stopId;
  final String stopName;
  final double stopLat;
  final double stopLon;

  SearchHitStop(
      String entityType,
      this.stopId,
      this.stopName,
      this.stopLat,
      this.stopLon,
      ) : super(entityType);

  @override
  String toString() {
    return stopName;
  }

  factory SearchHitStop.fromJson(Map<String, dynamic> json) {
    debugPrint("Voici l'objet obtenu : ");
    debugPrint(SearchHitStop(
      json['entity_type'],
      json['stop_id'] as int,
      json['stop_name'],
      json['stop_lat'] as double,
      json['stop_lon'] as double,
    ).toString());

    return SearchHitStop(
      json['entity_type'],
      json['stop_id'] as int,
      json['stop_name'],
      json['stop_lat'] as double,
      json['stop_lon'] as double,
    );
  }
}

class SearchHitPlace extends SearchHitEntity {
  final String title;
  final String subTitle;
  final String placeId;
  final String reference;
  final String description;


  SearchHitPlace(String entityType, this.title, this.subTitle, this.placeId, this.reference, this.description) : super(entityType);



  // factory SearchHitPlace.fromDto(Predictions dto) {
  //   debugPrint("Voici l'objet obtenu : ");
  //   debugPrint(SearchHitPlace(
  //     "place",
  //     dto.structuredFormatting.mainText,
  //     dto.structuredFormatting.secondaryText,
  //     dto.placeId,
  //     dto.reference,
  //     dto.description
  //   ).toString());
  //
  //   return SearchHitPlace(
  //     "place",
  //     dto.structuredFormatting.mainText,
  //     dto.structuredFormatting.secondaryText,
  //     dto.placeId,
  //     dto.reference,
  //     dto.description
  //   );
  // }

  @override
  String toString() {
    return '$title, $title, $subTitle, $description}';
  }
}

class SearchHitRoute extends SearchHitEntity {
  final String routeId;
  final String agencyId;
  final String routeShortName;
  final String routeLongName;

  SearchHitRoute(
    String entityType,
    this.routeId,
    this.agencyId,
    this.routeShortName,
    this.routeLongName,
  ) : super(entityType);

  factory SearchHitRoute.fromJson(Map<String, dynamic> json) {

    debugPrint("Voici l'objet obtenu : ");
    debugPrint(SearchHitRoute(
      json['entity_type'],
      json['route_id'],
      json['agency_id'],
      json['route_short_name'],
      json['route_long_name'],
    ).toString());


  return SearchHitRoute(
    json['entity_type'],
    json['route_id'],
    json['agency_id'],
    json['route_short_name'],
    json['route_long_name'],
  );
  }

  @override
  String toString() {
    return '$routeShortName, $routeLongName';
  }
}
