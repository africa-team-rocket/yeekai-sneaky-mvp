import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../presentation/map_screen/map_screen.dart';
import 'bus.dart';

class BusNearby{
  // Qu'est-ce qui m'empêche de juste utiliser des marqueurs à la place de ces objets ??
  // Je stocke plus facilement les infos nos reliés au marqueur peut-être ? par exemple lineId.
  final String busId;
  final String lineId;
  final int lineNumber;
  final LatLng position;
  final BusState state;
  final Marker busMarker;


  BusNearby({required this.busId, required this.lineId, required this.lineNumber, required this.position, required this.state, required this.busMarker});


  Future<BusNearby> copyWith({
    String? busId,
    String? lineId,
    int? lineNumber,
    LatLng? position,
    BusState? state,
    Marker? busMarker,
  }) async {
    return BusNearby(
      busId: busId ?? this.busId,
      lineId: lineId ?? this.lineId,
      lineNumber: lineNumber ?? this.lineNumber,
      position: position ?? this.position,
      state: state ?? this.state,
      busMarker: busMarker ?? await this.updateMarker(position ?? this.position),
    );
  }

  Future<Marker> updateMarker(LatLng newPosition) async {
    return Marker(
        markerId: MarkerId(this.busId),
        position: newPosition,
        icon: await BusMarkerIcon(
        lineNumber: this.lineNumber == 3 ? "003" : this.lineNumber.toString(),
    state: state,
    ).toBitmapDescriptor(logicalSize: const Size(72, 72), imageSize: const Size(72, 72)),
    );
  }

  // void getBusMarker() async {
  //   busMarker = Marker(
  //       markerId: MarkerId(this.busId),
  //       position: this.position,
  //       icon: await BusMarkerIcon(
  //         lineNumber: this.lineNumber.toString(),
  //         state: state,
  //       ).toBitmapDescriptor(logicalSize: const Size(72, 72), imageSize: const Size(72, 72))
  //   );
  // }

}