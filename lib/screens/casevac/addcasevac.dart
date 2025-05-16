import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/casevac/viewcasevac.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Addcasevac extends StatefulWidget {
  const Addcasevac({Key key}) : super(key: key);

  @override
  State<Addcasevac> createState() => _AddcasevacState();
}

class _AddcasevacState extends State<Addcasevac> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  LatLng currentPostion;
  Location _location = Location();
  Set<Marker> _markers = Set();

  Completer<GoogleMapController> _controller = Completer();

  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";
  String idgroup1 = "";
  String idgroup = "";

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

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  String lat = "";
  String long = "";
  TextEditingController namaform = new TextEditingController();
  TextEditingController lokasi = new TextEditingController();
  TextEditingController jenispasien = new TextEditingController();
  TextEditingController levelurgency = new TextEditingController();
  TextEditingController tools = new TextEditingController();
  TextEditingController keadaanlokasi = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

  bool value = false;
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Viewcasevac()));
              },
            ),
          ],
        );
      },
    );
  }

  List<String> items = ['Level 1', 'Level 2', 'Level 3'];
  String selecteditem = 'Level 1';
// Step 1.
  String dropdownValue = 'Dog';
  Future<void> pesanbookmark() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(3),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Casevac",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 160,
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            width: 160,
                            color: Colors.amber,
                            child: TextField(
                              cursorHeight: 15,
                              controller: namaform,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 5, left: 5, bottom: 5),
                                filled: true,
                                fillColor: Colors.blue.shade100,
                                border: OutlineInputBorder(),
                                labelText: 'Nama Form',
                                labelStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                                hintText: 'Tulis Nama Form:',
                                hintStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.redAccent),
                                suffixIcon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
                            height: 30,
                            width: 160,
                            color: Colors.amber,
                            child: TextField(
                              cursorHeight: 15,
                              controller: lokasi,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 5, left: 5, bottom: 5),
                                filled: true,
                                fillColor: Colors.blue.shade100,
                                border: OutlineInputBorder(),
                                labelText: 'Lokasi',
                                labelStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                                hintText: 'Lokasi Kejadian',
                                hintStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.redAccent),
                                suffixIcon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 30,
                            width: 160,
                            color: Colors.amber,
                            child: TextField(
                              cursorHeight: 15,
                              controller: jenispasien,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 5, left: 5, bottom: 5),
                                filled: true,
                                fillColor: Colors.blue.shade100,
                                border: OutlineInputBorder(),
                                labelText: 'Jenis Pasien',
                                labelStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.black),
                                hintText:
                                    'Jenis Pasien Rawat Jalan/ Rawat Inap',
                                hintStyle: TextStyle(
                                    fontSize: 12.0, color: Colors.redAccent),
                                suffixIcon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
//container gambar

                    Container(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.black),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                scale: 1.5,
                                image: AssetImage(
                                  'assets/help.png',
                                ),
                                fit: BoxFit.none)),
                      ),
                      height: 100,
                      width: 160,
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 30,
                  color: Colors.amber,
                  child: TextField(
                    cursorHeight: 15,
                    controller: levelurgency,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Level Urgency',
                      labelStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black),
                      hintText: 'Level Urgency',
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.redAccent),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.amber,
                  child: TextField(
                    cursorHeight: 15,
                    controller: tools,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Tools',
                      labelStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black),
                      hintText: 'Peralatan Yang di Gunakan',
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.redAccent),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.amber,
                  child: TextField(
                    cursorHeight: 15,
                    controller: keadaanlokasi,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Lokasi penjemputan',
                      labelStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black),
                      hintText: 'Keadaan Lokasi Penjemputan',
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.redAccent),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.amber,
                  child: TextField(
                    cursorHeight: 15,
                    controller: keterangan,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Keterangan',
                      labelStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black),
                      hintText: 'Keterangan Lain',
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.redAccent),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                )
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

  bool loading = false;
  simpanvidiolokasi() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.casevac), body: {
      "iduser": idku,
      "pesan": namaform.text,
      "lokasi": lokasi.text,
      "jenispasien": jenispasien.text,
      "levelurgency": levelurgency.text,
      "tools": tools.text,
      "keadaanlokasi": keadaanlokasi.text,
      "keterangan": keterangan.text,
      "status": "1",
      "latitude": lat,
      "longitude": long,
      "idgroup": idgroup1,
      "kategori": 1.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesan();
      namaform.text = '';
    } else {
      print("Data gagal");
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getProfiles();
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

  int ty = 0;
  var maptype = MapType.normal;

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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onTap: (LatLng latLng) {
                      _markers.add(
                          Marker(markerId: MarkerId('mark'), position: latLng));
                      setState(() async {
                        lat = latLng.latitude.toString();
                        long = latLng.longitude.toString();
                        print("ini lokasi nya");
                        print(lat);
                        print(long);
                        pesanbookmark();
                      });
                    },
                    markers: Set<Marker>.of(_markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    mapType: maptype,
                    myLocationEnabled: true,
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
                //endzoom custom
              ],
            ),
    );
  }
}
