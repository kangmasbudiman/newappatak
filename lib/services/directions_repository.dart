import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_map_live/services/directionswalking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
       // 'mode':'walking',
        'key': 'AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk',
      },
    );



    print("ini data dari google");
    print(response.data);
    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }

  //penambahan mode jalan kaki
Future<Directionswalking> getWalkingDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    final responsewalking = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode':'walking',
        'key': 'AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk',
      },
    );



    print("ini data dari walking");
    print(responsewalking.data);
    // Check if response is successful
    if (responsewalking.statusCode == 200) {
      return Directionswalking.fromMap(responsewalking.data);
    }
    return null;
  }













}
