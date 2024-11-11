import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/commons/utils/toolbox.dart';

class UpdateUserLocationUseCase {
  double prevLat = 0.0;
  double prevLon = 0.0;

  StreamController<Resource<UserLocationData>> _locationStreamController =
      StreamController<Resource<UserLocationData>>();

  Stream<Resource<UserLocationData>> get locationStream =>
      _locationStreamController.stream.asBroadcastStream();

  void closeStream() {
    _locationStreamController.close();
  }

  Stream<Resource<UserLocationData>> execute() {
    startLocationUpdates();
    return _locationStreamController.stream.onErrorReturnWith(
        (error, stackTrace) => Resource.error('An error occurred : $error'));
  }

  void startLocationUpdates() async {
    // try {
    Toolbox.checkLocationPermission();

    var initialPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
    _locationStreamController.sink.add(Resource.success(
      UserLocationData(position: initialPosition, bearing: 0.0),
    ));

    prevLat = initialPosition.latitude;
    prevLon = initialPosition.longitude;

    var positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    );

    await for (var position in positionStream) {
      if (prevLat != position.latitude || prevLon != position.longitude) {
        var newBearing = Geolocator.bearingBetween(
            prevLat, prevLon, position.latitude, position.longitude);

        if (newBearing < 0) {
          newBearing += 360;
        }

        _locationStreamController.sink.add(
          Resource.success(
            UserLocationData(position: position, bearing: newBearing),
          ),
        );

        prevLat = position.latitude;
        prevLon = position.longitude;
      }
    }
    // } catch (e) {
    //   _locationStreamController.sink.add(Resource.error('An error occurred : $e'));
    // }
  }
}

class UserLocationData {
  final Position position;
  final double bearing;

  const UserLocationData({required this.position, required this.bearing});
}
