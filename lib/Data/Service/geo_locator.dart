import 'dart:async';
import 'package:geolocator/geolocator.dart';

const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

class GeoLocatorService {
  static late LocationPermission permission;

  Stream<Position> getCurrentLocation =
      Geolocator.getPositionStream(locationSettings: locationSettings);

  static Future<void> getInitialLocation() async {
    Future.delayed(const Duration(seconds: 8), () async {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
      if (permission == LocationPermission.deniedForever) {
        /// Permissions are denied forever, handle appropriately.
        return Future.error(
          'Location permissions are permanently denied, we cannot request'
          ' permissions.',
        );
      }
    });
  }
}
