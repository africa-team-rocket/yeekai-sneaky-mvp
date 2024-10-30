import 'package:google_maps_flutter/google_maps_flutter.dart';

class Line {
  final int lineId;
  final String arrival;
  final String departure;
  final String lineNumber;
  final String fareRange;
  final String description;
  final int rating;
  final List<LatLng> onwardShape;
  final List<LatLng>? backwardShape;

  const Line({this.backwardShape, required this.onwardShape, required this.lineId, required this.arrival,required this.departure, required this.lineNumber, required this.description, required this.rating, required this.fareRange});

}