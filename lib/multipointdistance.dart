import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_map_live/hasil.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;

class Multidistance extends StatefulWidget {
  final String distance;
  const Multidistance({Key key, this.distance}) : super(key: key);

  @override
  State<Multidistance> createState() => _MultidistanceState();
}

class _MultidistanceState extends State<Multidistance> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kgooglePlex =
      CameraPosition(target: LatLng(33.738845, 73.084488), zoom: 14);

  final Set<Marker> _markers = {};

  final Set<Polyline> _polyline = {};

  List<LatLng> latlang = [];

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

  LatLng currentPostion;
  Location _location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final loc.Location location = loc.Location();
  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  List<dynamic> abc = [];
  String lat = "";
  String long = "";

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

  getaverage() {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double totalDistanceInM = 0;
    double totalDistanceInKm = 0;

    final listOfLatLngs = [
      LatLng(50.08155798581401, 8.24199914932251),
      LatLng(50.08053216096673, 8.242063522338867),
      LatLng(50.080614778545716, 8.243619203567505),
      LatLng(50.0816956787534, 8.243404626846313),
      LatLng(50.08155798581401, 8.24199914932251),
    ];

    double totalLat = 0.0;
    double totalLng = 0.0;
    for (int i = 0; i < (listOfLatLngs.length - 1); i++) {
      totalLat += listOfLatLngs[i].latitude;
      totalLng += listOfLatLngs[i].longitude;
    }
    print(
        "Average Latitude : ${totalLat / (listOfLatLngs.length - 1)} and Average Longitude : ${totalLng / (listOfLatLngs.length - 1)}");
  }

  TextEditingController namamypoint = new TextEditingController();

  Future<void> name() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Name Of Point',
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: namamypoint,
                  decoration: InputDecoration(hintText: "Pesan"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.pop(context);
                simpan();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> kosong() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Please Make Your CheckPoint',
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
                  'Save Success',
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Multidistance()));
              },
            ),
          ],
        );
      },
    );
  }

  simpan() async {
    final response = await http.post(Uri.parse(RestApi.savemymulti), body: {
      "idgroup": idgroup1,
      "name": namamypoint.text,
      "totaldistance": widget.distance,
      "iduser": idku,
    });
    final data = jsonDecode(response.body);
    print(data);
    if (response.contentLength == 2) {
    } else {
      hapus();
    }
  }

  hapus() async {
    final response =
        await http.post(Uri.parse(RestApi.deletemultipoint), body: {
      "iduser": idku,
    });
    final data = jsonDecode(response.body);
    print(data);
    if (response.contentLength == 2) {
    } else {
      pesan();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getProfiles();
    print(widget.distance);
    // getdistancefree();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: Colors.black,
        title: new Text(
          "Range Beiring",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              //  getaverage();

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Hasillatlang(list: latlang)));
            },
            child: Icon(Icons.forward),
          ),
          SizedBox(
            width: 5,
          ),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              //  getaverage();

              if (widget.distance == null) {
                kosong();
              } else {
                name();
              }
            },
            child: Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? (Center(
              child: CircularProgressIndicator(),
            ))
          : Stack(alignment: Alignment.center, children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPostion,
                  zoom: 16.0,
                ),
                onTap: _addMarker,
                zoomControlsEnabled: false,
                markers: _markers,
                // markers: Set<Marker>.of(markers.values),
                polylines: _polyline,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
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
            ]),
    );
  }

  void _addMarker(LatLng pos) async {
    // abc.add("{'lat': ${pos.latitude}, 'lng': ${pos.longitude}}");
    //  abc.add("{'lat': ${pos.latitude}}");
    // abc.add("{'lng': ${pos.longitude}}");

// abc.add(pos.latitude,pos.longitude);

    final response = await http.post(Uri.parse(RestApi.latlangring), body: {
      "iduser": idku,
      "latitude": pos.latitude.toString(),
      "longitude": pos.longitude.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);

    latlang.add(pos);

    for (int i = 0; i < latlang.length; i++) {
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: latlang[i],
          icon: BitmapDescriptor.defaultMarker));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId("1"),
        points: latlang,
      ));
    }
  }
}
