class CurrentDestLocalEntity {
  final int? id;
  final String? placeId;
  final double? latitude;
  final double? longitude;
  final String? formatedAddress;
  final String label;
  final int definitive;
  final String iconUrl;
  final int? order;

  CurrentDestLocalEntity({
    this.id,
    this.order,
    this.placeId,
    this.latitude,
    this.longitude,
    this.formatedAddress,
    required this.label,
    required this.definitive,
    required this.iconUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place_id': placeId,
      'latitude': latitude,
      'longitude': longitude,
      'formated_address': formatedAddress,
      'label': label,
      'definitive': definitive,
      'icon_url': iconUrl,
      'order': order
    };
  }

  @override
  String toString() {
    return 'CurrentDestLocalEntity{id: $id, placeId: $placeId, latitude: $latitude, longitude: $longitude, formatedAddress: $formatedAddress, label: $label, definitive: $definitive, iconUrl: $iconUrl, order: $order}';
  }

  factory CurrentDestLocalEntity.fromMap(Map<String, dynamic> map) {
    return CurrentDestLocalEntity(
      id: map['id'] as int?,
      placeId: map['place_id'] as String?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      formatedAddress: map['formated_address'] as String?,
      label: map['label'] as String,
      definitive: map['definitive'] as int,
      iconUrl: map['icon_url'] as String,
      order: map['order'] as int?
    );
  }

  CurrentDestLocalEntity copyWith({
    int? id,
    String? placeId,
    double? latitude,
    double? longitude,
    String? formatedAddress,
    String? label,
    int? definitive,
    String? iconUrl,
    int? order
  }) {
    return CurrentDestLocalEntity(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formatedAddress: formatedAddress ?? this.formatedAddress,
      label: label ?? this.label,
      definitive: definitive ?? this.definitive,
      iconUrl: iconUrl ?? this.iconUrl,
      order: order ?? this.order,
    );
  }

}

