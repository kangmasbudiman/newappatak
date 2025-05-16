import 'dart:async';
import 'dart:convert';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/map.dart';
import 'package:google_map_live/newgoto/mapdicrection.dart';
import 'package:google_map_live/newgoto/mapdirectionrepository.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/services/directions_repository.dart';
import 'package:google_map_live/services/directionswalking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Mapboxcasevac extends StatefulWidget {
  // final DetailsResult startposition;
  final DetailsResult endtposition;
  final LatLng posisi;
  final LatLng endposisi;

  const Mapboxcasevac(
      {Key key, //this.startposition,
      this.endtposition,
      this.endposisi,
      this.posisi})
      : super(key: key);

  @override
  State<Mapboxcasevac> createState() => _MapboxcasevacState();
}

class _MapboxcasevacState extends State<Mapboxcasevac> {
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
            CameraPosition(target: currentPostion, zoom: 15)));
      });
    });
  }

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
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
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos,
            onTap: () {
              print("oleh");
            });

        _destination = null;
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos,
            onTap: () {
              print("mantap");
            });
      });
    }
  }

  Directionswalking _infowalking;
  void ambiljarak() async {
    final directions = await Mapdirectionrepository().getDirections(
        origin: _origin.position, destination: _destination.position);
    setState(() => _info = directions);

    final directionswalking = await DirectionsRepository().getWalkingDirections(
        origin: _origin.position, destination: _destination.position);
    setState(() => _infowalking = directionswalking);
  }

  CameraPosition inisialcameraposition;
  Completer<GoogleMapController> _controller = Completer();
  Future<void> _gotoLake() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationResult.latitude, _locationResult.longitude),
      zoom: 16,
    )));
  }

  Future<void> _gotoOrigin() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.posisi.latitude, widget.posisi.longitude),
      zoom: 16,
    )));
  }

  Future<void> _gotoDestination() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.endposisi.latitude, widget.endposisi.longitude),
      zoom: 16,
    )));
  }

//_gotoDestination
  Future<void> _gotoZoomin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _gotoZoomout() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> pesan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Berhasil Tersimpan',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool loading = false;
  simpanvidiolokasi() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.tambahgoto), body: {
      "iduser": idku,
      "pesan": namalokasicontroller.text,
      "keterangan": keterangancontroller.text,
      "status": "1",
      "latitude": widget.endtposition.geometry.location.lng.toString(),
      "longitude": widget.endtposition.geometry.location.lng.toString(),
      "idgroup": idgroup1,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesan();
      namalokasicontroller.text = '';
    } else {
      print("Data gagal");
    }
  }

  TextEditingController namalokasicontroller = new TextEditingController();
  TextEditingController keterangancontroller = new TextEditingController();
  Future<void> info() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.amber,
                  child: TextField(
                    cursorHeight: 15,
                    controller: namalokasicontroller,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Nama Lokasi',
                      labelStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black),
                      hintText: 'Nama Lokasi',
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.redAccent),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.amber,
                  child: TextField(
                    cursorHeight: 15,
                    controller: keterangancontroller,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Keterangan',
                      labelStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black),
                      hintText: 'Keterangan',
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.redAccent),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                        ),
                        color: Colors.black),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                        ),
                        color: Colors.black),
                    child: Icon(
                      Icons.save_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    simpanvidiolokasi();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";
  String idgroup = "";
  String idgroup1 = "";

  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();
    idgroup = preferences.getString("idgroup").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
      idgroup1 = idgroup;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("ini data dari casevac");
    print(widget.endposisi);
    getLocation();

    getProfiles();

    setState(() {
      _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Start'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(widget.posisi.latitude, widget.posisi.longitude));

      _destination = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          info();
        },
        position: LatLng(widget.endposisi.latitude, widget.endposisi.longitude),
      );
    });
    ambiljarak();
  }

  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  int ty = 0;
  var maptype = MapType.normal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Text("Casevac Route"),
        actions: [
          TextButton(
              onPressed: () {
                _gotoOrigin();
                /*
                _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(
                            widget.posisi.latitude, widget.posisi.longitude)
                        //target: _origin.position, zoom: 14.5, tilt: 50.0)

                        )));
                        */
              },
              child: Text("Origin")),
          if (_destination != null)
            TextButton(
                onPressed: () {
                  _gotoDestination();
                },
                child: Text(
                  "Destination",
                  style: TextStyle(color: Colors.red),
                )),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.map_outlined,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              print("Ini Dia");
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
                const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  mapType: maptype,
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },

/*
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
*/
/*
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
*/

                  //  initialCameraPosition: inisialcameraposition,

                  initialCameraPosition: CameraPosition(
                    target: currentPostion,
                    zoom: 15,
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
                                    print("object");
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
                  height: 170,
                  width: 300,
                  offset: 50,
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
                            '${(_info.totalDistance)},${_info.totalDuration}',
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
                            '${(_infowalking.totalDistance)},${_infowalking.totalDuration}',
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
    );
  }
}
