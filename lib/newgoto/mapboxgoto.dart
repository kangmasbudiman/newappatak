import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_live/map.dart';
import 'package:google_map_live/newgoto/mapdicrection.dart';
import 'package:google_map_live/newgoto/mapdirectionrepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class Mapboxgoto extends StatefulWidget {
  final LatLng startposition;
  final LatLng endtposition;

  const Mapboxgoto({Key key, this.startposition, this.endtposition})
      : super(key: key);

  @override
  State<Mapboxgoto> createState() => _MapboxgotoState();
}

class _MapboxgotoState extends State<Mapboxgoto> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  LatLng currentPostion;
  // Location _location = Location();
  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });

    location.onLocationChanged.listen((newLoc) {
      LocationData _newlocasidata = newLoc;
      setState(() {
        currentPostion =
            LatLng(_newlocasidata.latitude, _newlocasidata.longitude);
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPostion, zoom: 14.5, tilt: 20.0)));
      });
    });
  }

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Mapdirection _info;

  void start() {
    print("ini lah dia");
    getLocation();
    print(currentPostion);
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }

  void ambiljarak() async {
    final directions = await Mapdirectionrepository().getDirections(
        origin: _origin.position, destination: _destination.position);
    setState(() => _info = directions);
  }

  CameraPosition inisialcameraposition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    //inisialcameraposition = CameraPosition(zoom: 15, target: currentPostion);
    setState(() {
      _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Start'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: widget.startposition);

      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: widget.endtposition,
      );
    });
    ambiljarak();
  }

  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Text("Goto From"),
        actions: [
          TextButton(
              onPressed: () {
                _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: _origin.position, zoom: 15, tilt: 20.0)));
              },
              child: Text("Origin")),
          if (_destination != null)
            TextButton(
                onPressed: () {
                  _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: _destination.position,
                          zoom: 15,
                          tilt: 20.0)));
                },
                child: Text(
                  "Destination",
                  style: TextStyle(color: Colors.red),
                )),
        ],
      ),
      body: currentPostion == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  //  initialCameraPosition: inisialcameraposition,

                  initialCameraPosition: CameraPosition(
                    target: currentPostion,
                    zoom: 19,
                    tilt: 5,
                  ),

                  polylines: {
                    if (_info != null)
                      Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          //jointType: JointType.mitered,
                          points: _info.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList()),
                  },
                  markers: {
                    if (_origin != null) _origin,
                    if (_destination != null) _destination,
                    Marker(
                      markerId: MarkerId("Current"),
                      position: currentPostion,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow),
                    ),
                  },
                  //  onTap: _addMarker,
                ),
                if (_info != null)
                  Positioned(
                    top: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: Text(
                        '${(_info.totalDistance)}, ${_info.totalDuration}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      /*
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
              child: Icon(Icons.center_focus_strong),
              onPressed: () {
                print(_info);
                _googleMapController.animateCamera(_info != null
                    ? CameraUpdate.newLatLngBounds(_info.bounds, 100)
                    : CameraUpdate.newCameraPosition(
                        CameraPosition(target: currentPostion, zoom: 15)));
              }),
          SizedBox(
            width: 5,
          ),
          InkWell(
              child: Container(
                height: 50,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.assistant_navigation), Text("Start")],
                ),
              ),
              onTap: () {
                start();
              }),
        ],
      ),
      */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
