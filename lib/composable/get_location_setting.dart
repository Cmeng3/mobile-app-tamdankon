import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';


LocationSettings getLocationSetting() {

  if (defaultTargetPlatform == TargetPlatform.android) {
    return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
        // (Optional) Set foreground notification config to keep the app alive 
        // when going to the background
        // purpose: continue fetching location during app is in background, or maybe fully terminate
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
          "Example app will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: false,
        )
    );
  } else if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
      accuracy: LocationAccuracy.high,
      activityType: ActivityType.fitness,
      distanceFilter: 1,
      pauseLocationUpdatesAutomatically: true,
      // Only set to true if our app will be started up in the background.
      showBackgroundLocationIndicator: false,
    );
  } else {
    return LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
  }

}

