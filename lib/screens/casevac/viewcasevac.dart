import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/newgoto/mapbox.dart';
import 'package:google_map_live/newgoto/mapboxcasevac.dart';
import 'package:google_map_live/newgoto/mapboxgoto.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/casevac/detailcasevac.dart';
import 'package:google_map_live/screens/casevac/viewreplycari.dart';
import 'package:google_map_live/services/directions_model.dart';
import 'package:google_map_live/services/directions_repository.dart';
import 'package:google_map_live/services/directionswalking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Viewcasevac extends StatefulWidget {
  const Viewcasevac({Key key}) : super(key: key);

  @override
  State<Viewcasevac> createState() => _ViewcasevacState();
}

class _ViewcasevacState extends State<Viewcasevac> {
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

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<Marker> list = [];
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
      getmarkerdarimysql();
    });
  }

  TextEditingController reply = new TextEditingController();
  save(markerIDval) async {
    print(markerIDval);
    print(idku);
    print(reply.text);
    print(nama_lengkap1);
    final response = await http.post(Uri.parse(RestApi.reply), body: {
      "id": markerIDval,
      "idreplied": idku,
      "reply": reply.text,
      "nama": nama_lengkap1,
    });

    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    int id = data['id'];
    if (value == 1) {
      _pesanberhasil();
      setState(() {
        reply.text = "";
      });
    } else {}
  }

  Future<void> _pesanberhasil() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Reply Success',
                  style: TextStyle(
                    fontSize: 15,
                  ),
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

  Future<void> _reply(String markerIDval) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                TextField(
                  controller: reply,
                  decoration: InputDecoration(hintText: "Reply / Coment"),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        //   Navigator.pop(context);
                        save(markerIDval);
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Reply")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Allreply(
                                      idcasevac: markerIDval,
                                    )));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("View")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> konfirmasi(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Apakah anda yakin ingin menghapus',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child:
                      Icon(Icons.check_circle, size: 35, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);

                    deleteimagelokasi(id);
                  },
                ),
                TextButton(
                  child: Icon(Icons.cancel, size: 35, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  deleteimagelokasi(String id) async {
    final response = await http.post(Uri.parse(RestApi.deletebycasevac), body: {
      "id": id,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    int idvidio = data['idvidio'];

    if (value == 1) {
      info();
    } else {
      print("Data gagal");
    }
  }

  Future<void> info() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Delete Berhasil',
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
                    MaterialPageRoute(builder: (context) => Viewcasevac()));
              },
            ),
          ],
        );
      },
    );
  }

  getmarkerdarimysql() async {
    //  final response = await http.get(Uri.parse(RestApi.getcasevac));
    final response = await http.post(Uri.parse(RestApi.getcasevacall), body: {
      "idgroup": idgroup1,
      "kodesort":"1"
    });
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/help.png",
      );

      for (int i = 0; i < data.length; i++) {
        var markerIDval = data[i]['id'].toString();
        var namalengkap = data[i]['nama_lengkap'];
        var lat = data[i]['latitude'];
        var long = data[i]['longitude'];
        var pesan = data[i]['pesan'];
        var lokasi = data[i]['lokasi'];
        var jenispasien = data[i]['jenispasien'];
        var levelurgency = data[i]['levelurgency'];
        var tools = data[i]['tools'];
        var keadaanlokasi = data[i]['keadaanlokasi'];
        var keterangan = data[i]['keterangan'];
        var foto = data[i]['foto'];
        var tgl = data[i]['created_at'];

        final MarkerId markerId = MarkerId(markerIDval);

        final Marker marker = Marker(
            markerId: markerId,
            icon: markerbitmap,
            position: LatLng(double.parse(lat), double.parse(long)),
            onTap: () {
              _customInfoWindowController.addInfoWindow(
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 365,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.amber)),
                        child: Container(
                          height: 190,
                          width: 365,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 365,
                                    child: Center(
                                      child: Text(
                                        namalengkap==null?"-":namalengkap,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text("Latitude :",
                                          style: TextStyle(fontSize: 18)),
                                      Text(lat, style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Longitude :",
                                          style: TextStyle(fontSize: 18)),
                                      Text(long,
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Keterangan: ",
                                          style: TextStyle(fontSize: 18)),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Detailcasevac(
                                                        namalengkap:
                                                            nama_lengkap,
                                                        lat: lat,
                                                        long: long,
                                                        pesan: pesan,
                                                        lokasi: lokasi,
                                                        jenispasien:
                                                            jenispasien,
                                                        levelurgency:
                                                            levelurgency,
                                                        tools: tools,
                                                        keadaanlokasi:
                                                            keadaanlokasi,
                                                        keterangan: keterangan,
                                                        tgl: tgl,
                                                        foto: foto,
                                                      )));
                                        },
                                        child: Container(
                                          child: Icon(Icons.details,
                                              color: Colors.white),
                                          height: 30,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(pesan, style: TextStyle(fontSize: 18)),

                                  //penambahan

                                  //akhirpenambahan

                                  /*
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          LatLng lokasi;
                                          setState(() {
                                            lokasi = LatLng(double.parse(lat),
                                                double.parse(long));
                                          });
                                          _addMarker(lokasi);
                                        },
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "Calculate\n Distance",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.blue,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 6),
                                                    color: Colors.grey,
                                                    blurRadius: 5)
                                              ]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          _reply(markerIDval);
                                        },
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "Comment",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.green[200],
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 6),
                                                    color: Colors.grey,
                                                    blurRadius: 5)
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => (Mapboxgoto(
                                                    startposition:
                                                        currentPostion,
                                                    endtposition: LatLng(
                                                        double.parse(lat),
                                                        double.parse(long)),
                                                  ))));
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Go To",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.red[200],
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 6),
                                                color: Colors.grey,
                                                blurRadius: 5)
                                          ]),
                                    ),
                                  ),
  */
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text("Posted: ",
                                        style: TextStyle(color: Colors.white)),
                                    Text(tgl,
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    /*
                                    LatLng lokasi;
                                    setState(() {
                                      lokasi = LatLng(double.parse(lat),
                                          double.parse(long));
                                    });
                                    _addMarker(lokasi);
*/
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Mapboxcasevac(
                                                  //startposition:startposition ,
                                                  posisi: currentPostion,
                                                  endposisi: LatLng(
                                                      double.parse(lat),
                                                      double.parse(long)),
                                                )));
                                  },
                                  child: Container(
                                    child: Center(
                                        child: Image.asset(
                                      'assets/ic_route.png',
                                      height: 25,
                                      width: 25,
                                    )),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                InkWell(
                                  onTap: () {
                                    _reply(markerIDval);
                                  },
                                  child: Container(
                                    child: Center(
                                        child: Image.asset(
                                      'assets/ic_menu_chat.png',
                                      height: 25,
                                      width: 25,
                                    )),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => (Mapboxgoto(
                                                  startposition: currentPostion,
                                                  endtposition: LatLng(
                                                      double.parse(lat),
                                                      double.parse(long)),
                                                ))));
                                  },
                                  child: Container(
                                    child: Center(
                                        child: Image.asset(
                                      'assets/ic_mgrs_goto.png',
                                      height: 25,
                                      width: 25,
                                    )),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    konfirmasi(markerIDval);
                                  },
                                  child: Center(
                                    child: Container(
                                      height: 40,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black,
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  LatLng(double.parse(lat), double.parse(long)));
            });
        setState(() {
          markers[markerId] = marker;
        });
      }
    }
  }

  List<LatLng> posisitujuan = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
    //  getmarkerdarimysql();
    getLocation();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

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

  Future<void> _gotoLake() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationResult.latitude, _locationResult.longitude),
      zoom: 16,
    )));
  }

  Future<void> _gotoZoomin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _gotoZoomout() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  bool isloading = false;
  int ty = 0;
  var maptype = MapType.normal;
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
              setState(() {
                // _origin = null;
                _destination = null;
                _info = null;
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
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: maptype,
                  markers: Set<Marker>.of(markers.values),
/*
                  onMapCreated: (GoogleMapController controller) {
                    // _controller.complete(controller);
                    _customInfoWindowController.googleMapController =
                        controller;
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
                  ),
                  //onTap: _addMarker,
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
                  onTap: (postition) {
                    _customInfoWindowController.hideInfoWindow();
                  },
*/

                  onCameraMove: (postition) {
                    _customInfoWindowController.onCameraMove();
                  },
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
                  height: 200,
                  width: 365,
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
    posisitujuan.add(pos);

    _customInfoWindowController.hideInfoWindow();

    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });
    for (var item in posisitujuan) {
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin.position, destination: pos);
      setState(() => _info = directions);

      final directionswalking = await DirectionsRepository()
          .getWalkingDirections(origin: _origin.position, destination: pos);
      setState(() => _infowalking = directionswalking);
    }
  }
}
