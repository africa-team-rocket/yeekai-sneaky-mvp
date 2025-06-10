import 'package:yeebus_filthy_mvp/map_feature/domain/model/map_entity.dart';

enum GiftMarkerType { LOOT, HINT, EMPTY }
enum GiftEvent { CHRISTMAS, NEW_YEAR, EASTER_EGG, ST_VALENTINE }

class GiftMapEntity extends MapEntity{

  Gift gift;
  GiftMapEntity({required this.gift, required super.entityName, required super.entityPosition});

}

class Gift {

  String giftId;
  String title;
  String description;
  double lat;
  double lng;
  GiftMarkerType markerType;
  GiftEvent event;
  bool wasFound;

  Gift({
    required this.giftId,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.markerType,
    required this.event,
    required this.wasFound,
  });

  // Convertir un JSON en objet Gift
  Gift.fromJson(Map<String, dynamic> json)
      : giftId = json['giftId'],
        title = json['title'],
        description = json['description'],
        lat = double.tryParse(json['lat'].toString()) ?? 0.0,
        lng = double.tryParse(json['lng'].toString()) ?? 0.0,
        markerType = _parseMarkerType(json['markerType']),
        event = _parseEvent(json['event']),
        wasFound = json['wasFound'];

  // Convertir un objet Gift en JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['giftId'] = giftId;
    data['title'] = title;
    data['description'] = description;
    data['lat'] = lat;
    data['lng'] = lng;
    data['markerType'] = markerType.toString().split('.').last;
    data['event'] = event.toString().split('.').last;
    data['wasFound'] = wasFound;
    return data;
  }

  // Convertir une chaîne en MarkerType
  static GiftMarkerType _parseMarkerType(String type) {
    switch (type) {
      case 'LOOT':
        return GiftMarkerType.LOOT;
      case 'HINT':
        return GiftMarkerType.HINT;
      case 'EMPTY':
        return GiftMarkerType.EMPTY;
      default:
        throw ArgumentError('Unknown markerType: $type');
    }
  }

  // Convertir une chaîne en Event
  static GiftEvent _parseEvent(String event) {
    switch (event) {
      case 'CHRISTMAS':
        return GiftEvent.CHRISTMAS;
      case 'NEW_YEAR':
        return GiftEvent.NEW_YEAR;
      default:
        throw ArgumentError('Unknown event: $event');
    }
  }

  @override
  String toString() {
    return 'Gift{giftId: $giftId, title: $title, description: $description, lat: $lat, lng: $lng, markerType: $markerType, event: $event, wasFound: $wasFound}';
  }
}
