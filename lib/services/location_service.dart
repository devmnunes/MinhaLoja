import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String?> getCurrentCity() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      // GPS desligado
      return null;
    }
 
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {

      // Usuário negou
      return null;
    }
 
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
 
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
 
    if (placemarks.isEmpty) return null;
    final p = placemarks.first;
 
    return p.locality?.isNotEmpty == true
        ? p.locality
        : (p.subAdministrativeArea?.isNotEmpty == true ? p.subAdministrativeArea : null);
  }
}