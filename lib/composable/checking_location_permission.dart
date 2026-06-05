import 'package:geolocator/geolocator.dart';

Future<bool> checkingLocationPermission() async {

  // use for checking the location-service enable
  bool serviceEnabled;
  // store LocationPermission enum value, that represent the type of location permission that user allow
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // when we invoking this method, Geolocator library will inject the asking-permission screen to our current-screen
    // purpose: to provide the permission choice to user
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return false;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return false;
  } 

  return true;

} 