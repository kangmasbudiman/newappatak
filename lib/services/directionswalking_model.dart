import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directionswalking {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;
  

  const Directionswalking({
    @required this.bounds,
    @required this.polylinePoints,
    @required this.totalDistance,
    @required this.totalDuration,
    
  });

  factory Directionswalking.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) return null;

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    String driving = '';
    String walkingduration = '';

    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      final step = data['legs'][0]['steps'][0];
      final mobil = data['legs'][0]['travel_mode'];

      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
     
      walkingduration = step['duration']['text'];
   
      print(distance);
      print(duration);
      print("_______________");
      print(driving);
      print(walkingduration);

      //  print(walk);
    }

    return Directionswalking(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
      
    );
  }
}
