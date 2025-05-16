import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_map_live/multipolyline.dart';
import 'package:google_map_live/redbeiringcari.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/services/directions_model.dart';
import 'package:google_map_live/services/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Ringbeiring extends StatefulWidget {
  const Ringbeiring({Key key}) : super(key: key);

  @override
  State<Ringbeiring> createState() => _RingbeiringState();
}

class _RingbeiringState extends State<Ringbeiring> {
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

  getmarkerdata() async {
    await FirebaseFirestore.instance
        .collection('location')
        .where('online', isEqualTo: 1)
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        var markerIDval = event.docs[i].id;
        final MarkerId markerId = MarkerId(markerIDval);

        final Marker marker = Marker(
          onTap: () {
            print("ini lokasi");
            _customInfoWindowController.addInfoWindow(
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        event.docs[i]['name'],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      RaisedButton(
                          child: Text("Chating"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chetscreen(
                                          id: event.docs[i]['userid'],
                                          nama: event.docs[i]['name'],
                                        )));
                          })
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
          /*
          infoWindow: InfoWindow(
            title: event.docs[i]['name'],
            snippet: event.docs[i]['no_wa'],
          ),
          */
          position:
              LatLng(event.docs[i]['latitude'], event.docs[i]['longitude']),
        );
        setState(() {
          markers[markerId] = marker;
        });

        //   initMarker(snapshot.data.docs[i].data(), snapshot.data.docs[i].id);

      }
    });

    _pesan() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);

                          // Fluttertoast.showToast(msg: " Add Red X");
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          child: Center(child: Text("Add")),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          child: Center(child: Text("View")),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue),
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

  Marker marker1 = Marker(
    markerId: MarkerId('Marker1'),
    position: LatLng(32.195476, 74.2023563),
    infoWindow: InfoWindow(title: 'Business 1'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );
  Marker marker2 = Marker(
    markerId: MarkerId('Marker2'),
    position: LatLng(31.110484, 72.384598),
    infoWindow: InfoWindow(title: 'Business 2'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );

  List<Marker> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = [marker1, marker2];
    print(list);
    getmarkerdata();
    getProfiles();
    getLocation();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
  }

  int ty = 0;
  var maptype = MapType.normal;
  bool isloading = false;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  // new features added
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 16,
  );

  // defining google maps variables to use
  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;

  // disposing google maps controller when the screen closes
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // a function to convert milles into kilometers
  String getKilometers({String mi}) {
    // String aStr = mi.replaceAll(RegExp('mi'), '');
    // double kil = double.parse(aStr) * 1.60934;
    // String kilometers = kil.toStringAsFixed(2);
    // return '$kilometers Km';
    return mi;
  }

  TextEditingController namalokasiicontroller = new TextEditingController();
  double latitude;
  double longitude;
  double latitudedes;
  double longitudedes;

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

  bool loading = false;

  simpandetaildestination(int id) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.latlangring), body: {
      "idring": id.toString(),
      "latitude": latitudedes.toString(),
      "longitude": longitudedes.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      namalokasiicontroller.text = '';

      setState(() {
        latitude = null;
        latitudedes = null;
        longitude = null;
        longitudedes = null;
      });
      pesanberhasil();
    } else {
      print("Data gagal");
    }
  }

  simpandetail(int id) async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.latlangring), body: {
      "idring": id.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      namalokasiicontroller.text = '';
      simpandetaildestination(id);
    } else {
      print("Data gagal");
    }
  }

  simpan() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.addredbiring), body: {
      "idgroup": idgroup1,
      "nama": namalokasiicontroller.text,
      "distance":
          '${getKilometers(mi: _info.totalDistance)}, ${_info.totalDuration}',
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "latitudedes": latitudedes.toString(),
      "longitudedes": longitudedes.toString(),
    });

    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    int idring = data['idringbiring'];
    print("ini data idring terakhir");
    print(idring);
    if (value == 1) {
      namalokasiicontroller.text = '';
      simpandetail(idring);
    } else {
      print("Data gagal");
    }
  }

  Future<void> pesanberhasil() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Text(
                'Save Point Success',
                textAlign: TextAlign.center,
              ),
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
            child: Column(
              children: [
                Text(
                  'Pesan',
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: namalokasiicontroller,
                  decoration: InputDecoration(hintText: "Pesan"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('SIMPAN'),
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

  var loadingdeletevidio = false;

  delete() async {
    setState(() {
      loadingdeletevidio = true;
    });
    final response = await http.get(Uri.parse(RestApi.deleteredbiring));
    if (response.contentLength == 2) {
    } else {
      print(response.body);
      setState(() {
        loadingdeletevidio = false;
      });
      pesansukses();
    }
  }

  Future<void> pesansukses() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Success Deleted"),
                SizedBox(
                  height: 15,
                ),
                loadingdeletevidio
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              child: Center(child: Text("OK")),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.red),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              child: Center(child: Text("No")),
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

  Future<void> konfirmasidelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Are You Sure ??"),
                SizedBox(
                  height: 15,
                ),
                loadingdeletevidio
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              delete();
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              child: Center(child: Text("Yes")),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.red),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              child: Center(child: Text("No")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.black,
            child: const Icon(Icons.map_outlined),
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
          SizedBox(width: 5),
          FloatingActionButton(
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.black,
            child: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Ringbeiringview()));
            },
          ),
          SizedBox(width: 5),
          FloatingActionButton(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            child: const Icon(Icons.delete),
            onPressed: () {
              konfirmasidelete();
            },
          ),
          SizedBox(width: 5),
          /*
          FloatingActionButton(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.black,
            child: const Icon(Icons.line_style),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Multipoly()));
            },
          ),
          */
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? Center(child: CircularProgressIndicator())
          : Stack(alignment: Alignment.center, children: [
              GoogleMap(
                mapType: maptype,
                // markers: Set<Marker>.of(markers.values),
                // onMapCreated: (GoogleMapController controller) {
                //   _customInfoWindowController.googleMapController = controller;
                //   // _controller.complete(controller);
                // },
                initialCameraPosition: CameraPosition(
                  target: currentPostion,
                  zoom: 16.0,
                ),
                // onTap: (postition) {
                //   _customInfoWindowController.hideInfoWindow();
                // },
                // onCameraMove: (postition) {
                //   _customInfoWindowController.onCameraMove();
                // },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) {
                  // adding the initial marker when the map starts
                  /*
                  setState(() {
                  
                    _origin = Marker(
                      markerId: const MarkerId('origin'),
                      infoWindow: const InfoWindow(title: 'Origin'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      position: currentPostion,
                    );
                    // Reset destination
                    _destination = null;

                    // Reset info
                    _info = null;
                  });

                  */
                  _googleMapController = controller;
                },
                markers: {
                  // checking whether origin or destination is empty
                  if (_origin != null) _origin,
                  if (_destination != null) _destination
                },
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
                            _destination.position.longitude),
                      ],
                    ),
                },
                onTap: _addMarker,
              ),

              // the widget for displaying distance and time in a stacked view
              if (_info != null)
                Positioned(
                  top: 20.0,
                  child: Container(
                    height: 70,
                    width: 200,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${getKilometers(mi: _info.totalDistance)}, ${_info.totalDuration}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pesan();
                          },
                          child: Container(
                            height: 35,
                            width: 150,
                            child: Center(
                                child: Text(
                              "Save",
                              style: TextStyle(fontSize: 15),
                            )),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ]),
    );
  }

  // a function to add marker
  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _destination = null;
        _info = null;

        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin.position, destination: pos);
      /*
      setState(
        () => _info = directions,
      );
*/
      setState(() {
        _info = directions;
        latitude = _origin.position.latitude;
        longitude = _origin.position.longitude;
        latitudedes = _destination.position.latitude;
        longitudedes = _destination.position.longitude;
      });
    }
  }
}
