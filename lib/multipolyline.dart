import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Multipoly extends StatefulWidget {
  final String idring;
  final String distance;
  const Multipoly({Key key, this.idring, this.distance}) : super(key: key);

  @override
  State<Multipoly> createState() => _MultipolyState();
}

class _MultipolyState extends State<Multipoly> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kgooglePlex =
      CameraPosition(target: LatLng(33.738845, 73.084488), zoom: 14);

  final Set<Marker> _markers = {};

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Polyline> _polyline = {};

  List<LatLng> latlang = [
    LatLng(33.738845, 73.084488),
    LatLng(33.567997728, 72.635997456),
    LatLng(33.567997728, 71.635997456),
  ];

  List<LatLng> listlang = [];

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
      // getmarkerdarimysql();
    });
  }

  getmarkerdarimysql() async {
    //  final response = await http.get(Uri.parse(RestApi.getcasevac));
    final response = await http.post(Uri.parse(RestApi.getlatlangrange), body: {
      "iduser": widget.idring,
    });

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/help.png",
      );
      print("ini dataku");
      print(data);
      for (int i = 0; i < data.length; i++) {
        var markerIDval = data[i]['id'].toString();
        // var namalengkap = data[i]['nama'];
        var lat = data[i]['lat'];
        var long = data[i]['lng'];

        final MarkerId markerId = MarkerId(markerIDval);
         _markers.add(Marker(
            markerId: MarkerId(i.toString()),
          position: LatLng(double.parse(lat), double.parse(long)),
            icon: BitmapDescriptor.defaultMarker));



       /*
        final Marker marker = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(double.parse(lat), double.parse(long)),
        );
        */

        listlang.add(
          LatLng(double.parse(lat), double.parse(long)),
        );
        setState(() {
        //  markers[markerId] = _marker;
        });
        _polyline.add(Polyline(
          polylineId: PolylineId("1"),
          points: listlang,
        ));
      }
      print("akhir data");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getProfiles();
    getmarkerdarimysql();
    /*
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
*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                markers: _markers,
                // markers: Set<Marker>.of(markers.values),
                polylines: _polyline,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
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
                        "Distance",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.distance,
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
            ]),
    );
  }
}
