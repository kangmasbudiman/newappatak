import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/map.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

class Detailmypoint extends StatefulWidget {
  final int id;

  const Detailmypoint({Key key, this.id}) : super(key: key);

  @override
  State<Detailmypoint> createState() => _DetailmypointState();
}

class _DetailmypointState extends State<Detailmypoint> {
  var loading = false;
  final Set<Marker> _markers = {};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  final Set<Polyline> _polyline = {};

  List<LatLng> listlatlang = [];

  getdata() async {
    setState(() {
      loading = true;
    });

    //final responsee = await http.get(Uri.parse(RestApi.getvidio));
    final responsee =
        await http.post(Uri.parse(RestApi.getdetilmymulti), body: {
      "idmymulti": widget.id.toString(),
    });

    if (responsee.statusCode == 200) {
      final data = jsonDecode(responsee.body);
      print("ini id detailmymulti");
      print(data);
      for (int i = 0; i < data.length; i++) {
        var markerIDval = data[i]['id'].toString();

        var lat = data[i]['lat'];
        var long = data[i]['lng'];
        var pesan = data[i]['pesan'];
        var tgl = data[i]['created_at'];
        var a = LatLng(lat, long);
        listlatlang.add(a);

        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(
              lat,
              long,
            ),
            icon: BitmapDescriptor.defaultMarker));
        setState(() {});
      }
      _polyline.add(Polyline(
        polylineId: PolylineId("1"),
        points: listlatlang,
      ));
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  LatLng currentPostion;
  final loc.Location location = loc.Location();
  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  Future<void> _gotoLake() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationResult.latitude, _locationResult.longitude),
      zoom: 16,
    )));
    setState(() {
      _markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          markerId: MarkerId('loc'),
          position:
              LatLng(_locationResult.latitude, _locationResult.longitude)));
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

  int ty = 0;
  var maptype = MapType.normal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.black,
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
            foregroundColor: Colors.black,
            child: Center(
              child: Image(
                  image: AssetImage("assets/iconrumah.png"),
                  width: 30,
                  height: 30),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                    markers: _markers,
                    mapType: maptype,
                    polylines: _polyline,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    //  markers: Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      //   // _controller.complete(controller);
                    },
                    initialCameraPosition:
                        CameraPosition(zoom: 15, target: currentPostion)),
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
              ],
            ),
    );
  }
}
