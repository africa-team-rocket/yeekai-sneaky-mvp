import 'package:geolocator/geolocator.dart';

class Toolbox{

  static Future<bool> checkLocationPermission() async{
    bool isServiceEnabled;
    LocationPermission locationPermission;

    // Check if service is enabled
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isServiceEnabled){
      throw Exception("Location not enabled");
    }

    locationPermission = await Geolocator.checkPermission();

    if(locationPermission == LocationPermission.deniedForever){
      throw Exception("Location permission is denied forever");
    }else if(locationPermission == LocationPermission.denied){

      locationPermission = await Geolocator.requestPermission();

      if(locationPermission == LocationPermission.denied){
        throw Exception("Location permission is denied");
      }
    }
    return true;
  }

  static String capitalizeWords(String input) {
    if (input.isEmpty) {
      return input;
    }

    final words = input.split(' '); // Divise la chaîne en mots

    final capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word; // Si le mot est vide, conservez-le tel quel
      }
    });

    return capitalizedWords.join(' '); // Reconstitue la chaîne avec des espaces
  }

}