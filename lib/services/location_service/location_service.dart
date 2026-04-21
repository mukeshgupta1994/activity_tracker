import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static Future<Position?> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      if (permission == LocationPermission.denied) {
        return null;
      }
      if (permission == LocationPermission.unableToDetermine) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> checkIsLocationPermissionEnabled() async {
    final permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.whileInUse:
        return true;
      case LocationPermission.always:
        return true;
      default:
        return false;
    }
  }

  static Future<bool> checkIsLocationServiceEnabled() async =>
      await Geolocator.isLocationServiceEnabled();

  static Future<bool> enableLocationPermission() async {
    final rPermission = await Geolocator.requestPermission();
    if (rPermission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }
    switch (rPermission) {
      case LocationPermission.whileInUse:
        return true;
      case LocationPermission.always:
        return true;
      default:
        return false;
    }
  }

  static Future<bool> enableLocationService() async {
    final isEnabled = await checkIsLocationServiceEnabled();
    if (!isEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }
}
