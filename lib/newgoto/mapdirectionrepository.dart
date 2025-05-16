import 'package:dio/dio.dart';
import 'package:google_map_live/newgoto/mapdicrection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapdirectionrepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  Mapdirectionrepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Mapdirection> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk',
      },
    );
    print("ini hasil");
    print(response);
    // Check if response is successful
    if (response.statusCode == 200) {
      return Mapdirection.fromMap(response.data);
    }
    return null;
  }
}
