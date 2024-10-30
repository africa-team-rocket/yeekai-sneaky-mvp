// import 'package:flutter/material.dart';
// import 'package:widget_marker_google_map/widget_marker_google_map.dart';
//
//
// class AnimatedWidgetMarker extends StatefulWidget {
//   /// Wrap a [GoogleMap] with this [AnimatedWidgetMarker] widget
//   ///
//   /// pass the [Set] of [WidgetMarker] to [animatedWidgetMarkers]
//   ///
//   /// then take the [animatedWidgetMarkers] from it's builder method and supply it
//   /// to the [GoogleMap]'s [WidgetMarkers]
//   ///
//   /// this widget will then calculate and animate the [WidgetMarker] from
//   /// it's old position to the new position automatically in the [duration]
//   /// with a [curve]
//   AnimatedWidgetMarker({
//     super.key,
//
//     /// [Set] of [WidgetMarker]s to animate, same as in [GoogleMap]
//     required this.animatedWidgetMarkers,
//
//     /// [Set] of [WidgetMarker]s that are not animated, same as in [GoogleMap]
//     Set<WidgetMarker>? staticWidgetMarkers,
//
//     /// build your [GoogleMap] in this builder with the [animatedWidgetMarkers]
//     required this.builder,
//
//     /// default [duration] of 1 seconds
//     this.duration = const Duration(seconds: 1),
//
//     /// default [curve] of [Curves.ease]
//     this.curve = Curves.ease,
//   }) : staticWidgetMarkers = staticWidgetMarkers ?? <WidgetMarker>{};
//   final Set<WidgetMarker> animatedWidgetMarkers;
//   final Set<WidgetMarker> staticWidgetMarkers;
//   final Widget Function(BuildContext context, Set<WidgetMarker> animatedWidgetMarkers)
//   builder;
//   final Duration duration;
//   final Curve curve;
//
//   @override
//   State<AnimatedWidgetMarker> createState() => AnimatedWidgetMarkerState();
// }
//
// class AnimatedWidgetMarkerState extends State<AnimatedWidgetMarker>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Set<Animation<WidgetMarker>> _widgetMarkerAnimations;
//   late Set<WidgetMarker> _lastWidgetMarkerPositions;
//   late Set<Map<WidgetMarker, WidgetMarker>> _widgetMarkerPairs;
//   late Set<WidgetMarker> _currentWidgetMarkerPositions;
//
//   @override
//   void initState() {
//     super.initState();
//
//     /// initialize the last WidgetMarker positions as the input WidgetMarker positions
//     _lastWidgetMarkerPositions = widget.animatedWidgetMarkers;
//
//     /// initialize the current WidgetMarker positions as the input WidgetMarker positions
//     _currentWidgetMarkerPositions = widget.animatedWidgetMarkers;
//
//     /// create an animation controller with [duration]
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     );
//
//     /// create a list of WidgetMarker pairs of the same [WidgetMarkerId] according to the
//     /// input [WidgetMarkerPositions]
//     _widgetMarkerPairs = widget.animatedWidgetMarkers.map<Map<WidgetMarker, WidgetMarker>>((widgetMarker) {
//       return <WidgetMarker, WidgetMarker>{
//         widgetMarker: _lastWidgetMarkerPositions.firstWhere(
//               (lastWidgetMarker) => lastWidgetMarker.markerId == widgetMarker.markerId,
//           orElse: () => widgetMarker,
//         )
//       };
//     }).toSet();
//
//     /// create [WidgetMarkerTween] animations from the pair of WidgetMarkers
//     _widgetMarkerAnimations = _widgetMarkerPairs.map<Animation<WidgetMarker>>(
//           (pair) {
//         return WidgetMarkerTween(
//           begin: pair.values.first,
//           end: pair.keys.first,
//         ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
//       },
//     ).toSet();
//
//     /// add a listener to the animation controller which returns
//     /// [_currentWidgetMarkerPositions] from the builder
//     _controller.addListener(() {
//       setState(() {
//         _currentWidgetMarkerPositions = _widgetMarkerAnimations
//             .map(
//               (animation) => animation.value,
//         )
//             .toSet()
//           ..addAll(widget.staticWidgetMarkers);
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didUpdateWidget(covariant AnimatedWidgetMarker oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     /// when the widget updates check if the old WidgetMarker position is same as the
//     /// new one, if not, update it with the latest
//     /// and restart the animation controller
//     if (oldWidget.animatedWidgetMarkers != widget.animatedWidgetMarkers) {
//       _lastWidgetMarkerPositions = oldWidget.animatedWidgetMarkers;
//
//       /// update the list of WidgetMarker pairs of the same [WidgetMarkerId] according to the
//       /// input [WidgetMarkerPositions]
//       _widgetMarkerPairs = widget.animatedWidgetMarkers.map<Map<WidgetMarker, WidgetMarker>>((widgetMarker) {
//         return <WidgetMarker, WidgetMarker>{
//           widgetMarker: _lastWidgetMarkerPositions.firstWhere(
//                 (lastWidgetMarker) => lastWidgetMarker.markerId == widgetMarker.markerId,
//             orElse: () => widgetMarker,
//           )
//         };
//       }).toSet();
//
//       /// update the [WidgetMarkerTween] animations from the pair of updated WidgetMarkers
//       _widgetMarkerAnimations = _widgetMarkerPairs.map<Animation<WidgetMarker>>(
//             (pair) {
//           return WidgetMarkerTween(
//             begin: pair.values.first,
//             end: pair.keys.first,
//           ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
//         },
//       ).toSet();
//
//       _controller.reset();
//       _controller.forward();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(context, _currentWidgetMarkerPositions);
//   }
// }
//
// class WidgetMarkerTween extends Tween<WidgetMarker> {
//   /// this is the extension of [Tween] to be able to calculate begin and end
//   /// of the [WidgetMarker]'s state
//   ///
//   /// the [begin] and [end] are same as default [Tween] of type [WidgetMarker]
//   WidgetMarkerTween({
//     /// the begining state of the WidgetMarker
//     required super.begin,
//
//     /// the end state of the WidgetMarker
//     required super.end,
//   });
//
//   /// this function normalizes the rotation values within 360 degrees
//   ///
//   /// then converts negative values to positive equivalent angles
//   /// then calculates the shortest path for the rotation to calculate
//   /// (for example, it will go directly from +10 degrees to -10 degrees without
//   /// rotating full 340 degrees)
//   /// it will also calculate and choose the shortest path to rotate
//   /// (i.e. it wont rotate over 180 degrees, it will calculate and take another
//   /// direction instead)
//   double _calculateRotation(
//       double beginRotation, double endRotation, double t) {
//     beginRotation %= 360;
//     endRotation %= 360;
//
//     if (beginRotation < 0) beginRotation += 360;
//     if (endRotation < 0) endRotation += 360;
//
//     final diff = (beginRotation - endRotation).abs();
//     if (diff > 180) {
//       if (beginRotation > 180) {
//         beginRotation -= 360;
//       } else {
//         endRotation -= 360;
//       }
//     }
//     return beginRotation + (endRotation - beginRotation) * t;
//   }
//
//   @override
//   WidgetMarker lerp(double t) {
//     return WidgetMarker(
//       markerId: end!.markerId,
//       position: LatLng(
//         begin!.position.latitude +
//             (end!.position.latitude - begin!.position.latitude) * t,
//         begin!.position.longitude +
//             (end!.position.longitude - begin!.position.longitude) * t,
//       ),
//       widget: end!.widget,
//       // alpha: begin!.alpha + (end!.alpha - begin!.alpha) * t,
//       // anchor: end!.anchor,
//       draggable: end!.draggable,
//       // flat: end!.flat,
//       infoWindow: end!.infoWindow,
//       rotation: _calculateRotation(begin!.rotation, end!.rotation, t),
//       visible: end!.visible,
//       zIndex: begin!.zIndex + (end!.zIndex - begin!.zIndex) * t,
//     );
//   }
// }