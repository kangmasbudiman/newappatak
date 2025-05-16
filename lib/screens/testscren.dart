import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_map_live/services/directions_model.dart';
import 'package:google_map_live/services/directions_repository.dart';
import 'package:google_map_live/services/directionswalking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

class Testscreen extends StatefulWidget {
  const Testscreen({Key key}) : super(key: key);

  @override
  State<Testscreen> createState() => _TestscreenState();
}

class _TestscreenState extends State<Testscreen> {
  final LatLng _currentPosition =
      LatLng(-0.8971395757503112, 100.3507166778259);

  GoogleMapController mycontroller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specifi, specifyid) async {
    var markerIDval = specifyid;
    final MarkerId markerId = MarkerId(markerIDval);
    final Marker marker = Marker(
      markerId: markerId,
      infoWindow: InfoWindow(
        title: specifi['name'],
        snippet: specifi['no_wa'],
      ),
      position: LatLng(specifi['latitude'], specifi['longitude']),
    );

    if (isloading == true) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  LatLng currentPostion;
  Location _location = Location();

  final loc.Location location = loc.Location();
  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  Future<void> _gotoZoomin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _gotoZoomout() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  void addcostomicon(String jabatan) {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(30, 30)),
      jabatan == 1 ? "assets/security-guard.png" : "assets/teamwork(3).png",
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  getmarkerdata() async {
    await FirebaseFirestore.instance
        .collection('location')
        .where('online', isEqualTo: 1)
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        addcostomicon(event.docs[i]['jabatan']);
        var markerIDval = event.docs[i].id;

        final MarkerId markerId = MarkerId(markerIDval);

        final Marker marker = Marker(
          icon: event.docs[i]['jabatan'] == "1"
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
          onTap: () {
            _customInfoWindowController.addInfoWindow(
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.docs[i]['name'],
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        event.docs[i]['no_wa'],
                        style: TextStyle(fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Latitude :",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            event.docs[i]['latitude'].toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Longitude :",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            event.docs[i]['longitude'].toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Chetscreen(
                                                  id: event.docs[i]['userid'],
                                                  nama: event.docs[i]['name'],
                                                )));
                                  },
                                  child: Image.asset(
                                    'assets/ic_menu_chat.png',
                                    height: 25,
                                    width: 25,
                                  )),
                              InkWell(
                                  onTap: () {
                                    LatLng lokasi;

                                    setState(() {
                                      lokasi = LatLng(event.docs[i]['latitude'],
                                          event.docs[i]['longitude']);
                                    });
                                    _addMarker(lokasi);
                                  },
                                  child: Image.asset(
                                    'assets/ic_route.png',
                                    height: 25,
                                    width: 25,
                                  ))
                            ],
                          ),
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))))
                    ],
                  )),
                ),
                LatLng(event.docs[i]['latitude'], event.docs[i]['longitude']));

            /*
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chetscreen(
                          id: event.docs[i]['userid'],
                          nama: event.docs[i]['name'],
                        )));
*/
          },
          markerId: markerId,
          position:
              LatLng(event.docs[i]['latitude'], event.docs[i]['longitude']),
        );

        setState(() {
          markers[markerId] = marker;
        });

        //   initMarker(snapshot.data.docs[i].data(), snapshot.data.docs[i].id);

      }
    });

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('location')
            .where('online', isEqualTo: 1)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              var someData = snapshot.data.docs;
              print(someData);
            }
          }
          return Text("da");
        });
  }

  Future<void> _gotoLake() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationResult.latitude, _locationResult.longitude),
      zoom: 16,
    )));
  }

  List<Marker> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  addcostomicon();
    print(list);

    getmarkerdata();
    getLocation();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    @override
    void dispose() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      super.dispose();
    }
  }

  bool isloading = false;

  int ty = 0;

  var maptype = MapType.normal;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Marker _origin;
  Marker _destination;
  Directions _info;
  Directionswalking _infowalking;

  GoogleMapController _googleMapController;
  String getKilometers({String mi}) {
    // String aStr = mi.replaceAll(RegExp('mi'), '');
    // double kil = double.parse(aStr) * 1.60934;
    // String kilometers = kil.toStringAsFixed(2);
    // return '$kilometers Km';
    return mi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: Image(
                image: AssetImage("assets/iconmap.png"), width: 30, height: 30),
            onPressed: () {
              setState(() {
                if (maptype == MapType.normal) {
                  this.maptype = MapType.hybrid;
                } else {
                  this.maptype = MapType.normal;
                }
              });
            },
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.black,
            child:
                const Icon(Icons.clear_outlined, color: Colors.white, size: 30),
            onPressed: () {
              setState(() {
                // _origin = null;
                _destination = null;
                _info = null;
                _infowalking = null;
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                    onTap: _addMarker,
                    mapType: maptype,
                    zoomControlsEnabled: false,
                    myLocationEnabled: false,
                    markers: Set<Marker>.of(markers.values),
                    onCameraMove: (postition) {
                      _customInfoWindowController.onCameraMove();
                    },
                    /*
                   markers: {
                      // checking whether origin or destination is empty
                      if (_origin != null) _origin,
                      if (_destination != null) _destination
                    },
*/
                    polylines: {
                      // adding polyline for creating routes
                      if (_info != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          jointType: JointType.mitered,
                          points: [
                            LatLng(_origin.position.latitude,
                                _origin.position.longitude),
                            LatLng(_destination.position.latitude,
                                _destination.position.longitude)
                          ],
                        ),
                    },
                    /* 
                    onMapCreated: (controller) {
                      // adding the initial marker when the map starts
                      setState(() {
                        _origin = Marker(
                          markerId: const MarkerId('origin'),
                          infoWindow: const InfoWindow(title: 'Origin'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueOrange),
                          position: currentPostion,
                        );
                        // Reset destination
                        _destination = null;
                        // Reset info
                        _info = null;
                      });
                      _googleMapController = controller;
                    },
*/

                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _customInfoWindowController.googleMapController =
                          controller;
                      //   // _controller.complete(controller);
                      setState(() {
                        _origin = Marker(
                          markerId: const MarkerId('origin'),
                          position: currentPostion,
                        );
                        // Reset destination
                        _destination = null;
                        // Reset info
                        _info = null;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentPostion,
                      zoom: 16.0,
                    )),

                //zoom kontrol custom
                Positioned(
                  bottom: 87,
                  right: 4,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            height: 38,
                            width: 38,
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    _gotoLake();
                                  },
                                  icon: Icon(Icons.gps_fixed)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  right: 8,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          child: InkWell(
                            onTap: () async {
                              _gotoZoomin();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/zoomin.png')),
                                color: Colors.transparent,
                              ),
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  right: 10,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          child: InkWell(
                            onTap: () async {
                              _gotoZoomout();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/zoomout.png')),
                                color: Colors.transparent,
                              ),
                              height: 26,
                              width: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //endzoom custom

                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 150,
                  width: 300,
                  offset: 35,
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
                      child: Row(
                        children: [
                          Icon(Icons.directions_car, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${getKilometers(mi: _info.totalDistance)},${_info.totalDuration}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_infowalking != null)
                  Positioned(
                    top: 65.0,
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_walk,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${getKilometers(mi: _infowalking.totalDistance)},${_infowalking.totalDuration}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _addMarker(LatLng pos) async {
    // if (_origin == null || (_origin != null && _destination != null)) {
    // Origin is not set OR Origin/Destination are both set
    // Set origin

    // } else {
    // Origin is already set
    // Set destination
    _customInfoWindowController.hideInfoWindow();

    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });

    // Get directions
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin.position, destination: pos);
    setState(() => _info = directions);

    final directionswalking = await DirectionsRepository()
        .getWalkingDirections(origin: _origin.position, destination: pos);
    setState(() => _infowalking = directionswalking);

    // }
  }
}
