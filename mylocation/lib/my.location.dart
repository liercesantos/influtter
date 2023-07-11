import 'package:geolocator/geolocator.dart';

class MyLocation {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Serviço de localização desativado.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw 'Permissão de localização negada permanentemente.';
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw 'Permissão de localização negada.';
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
