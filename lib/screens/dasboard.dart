import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/akunku.dart';
import 'package:google_map_live/bestvidcall/home_page.dart';
import 'package:google_map_live/hasilmulti.dart';
import 'package:google_map_live/multipointdistance.dart';
import 'package:google_map_live/mymulticari.dart';
import 'package:google_map_live/newgoto/listgotocari.dart';
import 'package:google_map_live/newgoto/mapbox.dart';
import 'package:google_map_live/newgoto/selectdestination.dart';
import 'package:google_map_live/ringbeiring.dart';
import 'package:google_map_live/screens/casevac/Laporan.dart';
import 'package:google_map_live/screens/casevac/formbank.dart';
import 'package:google_map_live/screens/casevac/formcasevac.dart';
import 'package:google_map_live/screens/casevac/formenviroment.dart';
import 'package:google_map_live/screens/casevac/listcasevaccari.dart';
import 'package:google_map_live/screens/tampilcctv.dart';
import 'package:google_map_live/uploadavatar.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';

import 'package:google_map_live/map.dart';
import 'package:google_map_live/newgoto/home_screen.dart';
import 'package:google_map_live/newgoto/screens/search_places_screen.dart';
import 'package:google_map_live/restapi/restApi.dart';

import 'package:google_map_live/screens/allkeranjang.dart';
import 'package:google_map_live/screens/allkontak.dart';
import 'package:google_map_live/screens/calculate/calculate.dart';
import 'package:google_map_live/screens/casevac/addcasevac.dart';
import 'package:google_map_live/screens/casevac/viewcasevac.dart';
import 'package:google_map_live/screens/chatgroup.dart';
import 'package:google_map_live/screens/emergencybeacon.dart';
import 'package:google_map_live/screens/getbookmark.dart';
import 'package:google_map_live/screens/getfavorit.dart';
import 'package:google_map_live/screens/goto/goto.dart';
import 'package:google_map_live/screens/goto/searchplace.dart';
import 'package:google_map_live/screens/imagelokasi/addlokasiimage.dart';
import 'package:google_map_live/screens/imagelokasi/tambahimagecari.dart';
import 'package:google_map_live/screens/imagelokasi/viewmarker.dart';
import 'package:google_map_live/screens/liskontak.dart';
import 'package:google_map_live/screens/allemergencybecon.dart';
import 'package:google_map_live/screens/mapfavorit.dart';
import 'package:google_map_live/screens/redx/addredx.dart';
import 'package:google_map_live/screens/redx/viewredx.dart';
import 'package:google_map_live/screens/testscren.dart';
import 'package:google_map_live/screens/traking.dart';
import 'package:google_map_live/screens/vidio/addlokasividio.dart';
import 'package:google_map_live/screens/vidio/tambahvidio.dart';
import 'package:google_map_live/screens/vidio/tambahvidiocari.dart';
import 'package:google_map_live/screens/vidio/viewvidio.dart';
import 'package:google_map_live/ui/screen/home_screen.dart';
import 'package:google_map_live/utils/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import 'package:radial_menu/radial_menu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

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
  String avatar1 = "";
  String latitude = "";
  String longitude = "";
  String email = "";
  String email1 = "";
  String jabatan = "";
  String jabatan1 = "";

  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();
    idgroup = preferences.getString("idgroup").toString();
    email = preferences.getString("email").toString();
    jabatan = preferences.getString("jabatan").toString();
    setState(() {
      _isLoading = false;
      idku = id;

      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
      idgroup1 = idgroup;
      email1 = email;
      jabatan1 = jabatan;

      ambilgambar();
    });

    print("ini jabatanku");
    print(jabatan1);
  }

  bool loadingavatar = false;
  ambilgambar() async {
    // final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      loadingavatar = true;
    });

    final response = await http.post(Uri.parse(RestApi.getavatar), body: {
      "id": idku,
    });
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      int value = data['value'];
      String avatar = data['foto'];
      setState(() {
        avatar1 = avatar;
      });
      loadingavatar = false;
    }
  }

  LatLng currentPostion;
  Location _location = Location();

  int ty = 0;
  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        currentPostion =
            LatLng(_locationResult.latitude, _locationResult.longitude);
      });
    }
  }

  Set<Polygon> myPolygon() {
    //List<LatLng> polygonCoords = new List();
    var polygonCoords = new List<LatLng>();

    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08332357078792));
    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));

    //Set<Polygon> polygonSet = new Set();

    var polygonSet = Set<Polygon>();

    polygonSet.add(Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,
        strokeColor: Colors.red));

    return polygonSet;
  }

  keluar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove('id');
      preferences.remove('nama_lengkap');
      preferences.remove('no_wa');
      preferences.remove('idgroup');
      preferences.commit();
    });
    exit(0);
  }

  Future<void> konfirmasi() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Apakah anda yakin ingin keluar dari aplikasi ini',
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

                    keluar();
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

  Future<void> menuimage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CircularMenu(
          alignment: Alignment.center,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceInOut,
          toggleButtonIconColor: Colors.black,
          items: [
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addlokasiimage()));
              },
              icon: Icons.add,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Viewmarker()));
              },
              icon: Icons.video_collection,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Allimage()));
              },
              icon: Icons.list_alt_outlined,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                konfirmasideleteimage();
              },
              icon: Icons.delete_forever,
              color: Colors.black,
            ),
          ],
        );

        /* 
        AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Image"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Addlokasiimage()));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewmarker()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Map")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Allimage()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("List")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        konfirmasideleteimage();
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Delete all")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
*/
      },
    );
  }

  Future<void> menuvidio() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CircularMenu(
          alignment: Alignment.center,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceInOut,
          toggleButtonIconColor: Colors.black,
          items: [
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addlokasividio()));
              },
              icon: Icons.add,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Viewvidio()));
              },
              icon: Icons.video_collection,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Allvidio()));
              },
              icon: Icons.list_alt_outlined,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                konfirmasidelete();
              },
              icon: Icons.delete_forever,
              color: Colors.black,
            ),
          ],
        );
        /*
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          content: SingleChildScrollView(
            child:
            
             Column(
              children: [
                Text("Vidio"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        print("menu");
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Addlokasividio()));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewvidio()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Map")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Allvidio()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("List")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        konfirmasidelete();
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Delete All")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
        );
        */
      },
    );
  }

  Future<void> menugoto() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CircularMenu(
          alignment: Alignment.center,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceInOut,
          toggleButtonIconColor: Colors.black,
          items: [
            CircularMenuItem(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Selectdestination()));
              },
              icon: Icons.room_outlined,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Allgotolist()));
              },
              icon: Icons.list,
              color: Colors.black,
            ),
          ],
        );
        /*
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 1, right: 1, bottom: 6),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Go To"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Selectdestination()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Go To")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.amber),
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Allgotolist()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("List")),
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
        */
      },
    );
  }

  Future<void> menucasevac() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CircularMenu(
          alignment: Alignment.center,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceInOut,
          toggleButtonIconColor: Colors.black,
          items: [
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addcasevac()));
              },
              icon: Icons.add,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Viewcasevac()));
              },
              icon: Icons.video_collection,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Allcasevaclist()));
              },
              icon: Icons.list_alt_outlined,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                konfirmasideletecasevac();
              },
              icon: Icons.delete_forever,
              color: Colors.black,
            ),
          ],
        );

        /*
         AlertDialog(
          contentPadding: EdgeInsets.only(left: 1, right: 1, bottom: 6),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Casevac"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Addcasevac()));
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
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewcasevac()));
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
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Allcasevaclist()));
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("List")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        konfirmasideletecasevac();
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Delete All")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        */
      },
    );
  }

  Future<void> menuredx() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CircularMenu(
          alignment: Alignment.center,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceInOut,
          toggleButtonIconColor: Colors.black,
          items: [
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addredx()));
              },
              icon: Icons.add,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Viewredx()));
              },
              icon: Icons.video_collection,
              color: Colors.black,
            ),
            CircularMenuItem(
              onTap: () {
                konfiramasideleteredx();
              },
              icon: Icons.delete_forever,
              color: Colors.black,
            ),
          ],
        );

        /*
         AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Red X"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Addredx()));

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewredx()));
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
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        konfiramasideleteredx();
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        child: Center(child: Text("Delete")),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      */
      },
    );
  }

  delete() async {
    setState(() {
      loadingdeletevidio = true;
    });
    final response = await http.get(Uri.parse(RestApi.deleteallvidio));
    if (response.contentLength == 2) {
    } else {
      print(response.body);
      setState(() {
        loadingdeletevidio = false;
      });
    }
  }

  deleteredx() async {
    setState(() {
      loadingdeletevidio = true;
    });
    final response = await http.get(Uri.parse(RestApi.deleteallredx));
    if (response.contentLength == 2) {
    } else {
      print(response.body);
      setState(() {
        loadingdeletevidio = false;
      });
    }
  }

  deletecasevac() async {
    setState(() {
      loadingdeletevidio = true;
    });
    final response = await http.get(Uri.parse(RestApi.deleteallcasevac));
    if (response.contentLength == 2) {
    } else {
      print(response.body);
      setState(() {
        loadingdeletevidio = false;
      });
    }
  }

  deleteimage() async {
    setState(() {
      loadingdeletevidio = true;
    });
    final response = await http.get(Uri.parse(RestApi.deleteallimage));
    if (response.contentLength == 2) {
    } else {
      print(response.body);
      setState(() {
        loadingdeletevidio = false;
      });
    }
  }

  var loadingdeletevidio = false;
  Future<void> konfirmasideleteimage() async {
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
                              deleteimage();
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

  Future<void> konfirmasideletecasevac() async {
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
                              deletecasevac();
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

  Future<void> konfiramasideleteredx() async {
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
                              deleteredx();
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

  var loadingiconaddlocation = false;
  var loadingiconenablelocation = false;
  var loadingicondisablelocation = false;
  var loadingicontracking = false;
  var loadingiconbookmark = false;
  var loadingiconvideo = false;
  var loadingiconcasevac = false;
  var loadingiconchangemap = false;
  var loadingiconchatgroup = false;
  var loadingiconemergency = false;
  var loadingiconfavorit = false;
  var loadingiconimage = false;
  var loadingicongoto = false;
  var loadingiconkontak = false;
  var loadingiconredx = false;
  var loadingiconsharingmap = false;
  var loadingiconvidiocall = false;

  String iconaddlocation1 = "";
  String iconenablelocation1 = "";
  String icondisablelocation1 = "";
  String icontracking1 = "";
  String iconvideo1 = "";
  String iconbookmark1 = "";
  String iconcasevac1 = "";
  String iconchangemap1 = "";
  String iconchatgroup1 = "";
  String iconemergency1 = "";
  String iconfavorit1 = "";
  String icongoto1 = "";
  String iconimage1 = "";
  String iconkontak1 = "";
  String iconredx1 = "";
  String iconsharingmap1 = "";
  String iconvidiocall1 = "";
  String iconredbeiring1 = "";
  TextEditingController namaform = new TextEditingController();
  TextEditingController lokasi = new TextEditingController();
  TextEditingController jenispasien = new TextEditingController();
  TextEditingController levelurgency = new TextEditingController();
  TextEditingController tools = new TextEditingController();
  TextEditingController keadaanlokasi = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

  //penambahan untk data form bank
  var vidiourl;
  openCamera() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
      );
      if (pickedImage != null) {
        setState(() {
          vidiourl = pickedImage.path;
        });
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  opengalery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
      );
      if (pickedImage != null) {
        setState(() {
          vidiourl = pickedImage.path;
        });
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  save(String kodelaporan) async {
    setState(() {
      loading = true;
    });

    final uri = Uri.parse(RestApi.casevac);
    var request = http.MultipartRequest("POST", uri);
    request.fields['iduser'] = idku;
    request.fields['pesan'] = namaform.text;
    request.fields['lokasi'] = lokasi.text;
    request.fields['jenispasien'] = jenispasien.text;
    request.fields['levelurgency'] = levelurgency.text;
    request.fields['tools'] = tools.text;
    request.fields['keadaanlokasi'] = keadaanlokasi.text;
    request.fields['keterangan'] = keterangan.text;
    request.fields['status'] = "1";
    request.fields['latitude'] = currentPostion.latitude.toString();
    request.fields['longitude'] = currentPostion.longitude.toString();
    request.fields['idgroup'] = idgroup1;
    request.fields['kategori'] = kodelaporan;

    var uploadvidio = await http.MultipartFile.fromPath("image", vidiourl);

    request.files.add(uploadvidio);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("upload berhasil");
      pesan();
      setState(() {
        loading = false;
        vidiourl = "Pilih Gambar";
        namaform.text = "";
        keterangan.text = "";
      });
    } else {
      pesan();
    }
  }

  bool loading = false;
  simpanvidiolokasi(String kodelaporan) async {
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
      "latitude": currentPostion.latitude.toString(),
      "longitude": currentPostion.longitude.toString(),
      "idgroup": idgroup1,
      "kategori": kodelaporan,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesan();
      setState(() {
        loading = false;
        namaform.text = "";
        lokasi.text = "";
        jenispasien.text = "";
        levelurgency.text = "";
        tools.text = "";
        keadaanlokasi.text = "";
        keterangan.text = "";
      });
      namaform.text = '';
    } else {
      print("Data gagal");
    }
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Viewcasevac()));
              },
            ),
          ],
        );
      },
    );
  }

  //akhir form bank

  iconenablelocation() async {
    setState(() {
      loadingiconenablelocation = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconenablelocation));
    final iconenablelocation = jsonDecode(response.body);
    String a = iconenablelocation['file'];
    if (mounted) {
      iconenablelocation1 = a;
      loadingiconenablelocation = false;
    } else {}
    /*
        setState(() {
        iconenablelocation1 = a;
        loadingiconenablelocation = false;
      });
  */
  }

  geticonaddlocation() async {
    setState(() {
      loadingiconaddlocation = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconlocation));
    final iconaddlocation = jsonDecode(response.body);
    String iconc = iconaddlocation['file'];

    if (mounted) {
      setState(() {
        iconaddlocation1 = iconc;
        loadingiconaddlocation = false;
      });
    }
  }

  icondisablelocation() async {
    setState(() {
      loadingicondisablelocation = true;
    });
    final response = await http.get(Uri.parse(RestApi.icondisablelocation));
    final icondisablelocation = jsonDecode(response.body);
    String b = icondisablelocation['file'];
    if (mounted) {
      setState(() {
        icondisablelocation1 = b;
        loadingicondisablelocation = false;
      });
    }

//    setState(() {
//      icondisablelocation1 = b;
//      loadingicondisablelocation = false;
    //   });
  }

  icontracking() async {
    setState(() {
      loadingicontracking = true;
    });
    final response = await http.get(Uri.parse(RestApi.icontracking));
    final icontracking = jsonDecode(response.body);
    String d = icontracking['file'];
    if (mounted) {
      setState(() {
        icontracking1 = d;
        loadingicontracking = false;
      });
    }
  }

  iconvideo() async {
    setState(() {
      loadingiconvideo = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconvideo));
    final iconvideo = jsonDecode(response.body);
    String e = iconvideo['file'];
    if (mounted) {
      setState(() {
        iconvideo1 = e;
      });
    }
    setState(() {
      loadingiconvideo = false;
    });
  }

  iconimage() async {
    setState(() {
      loadingiconimage = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconimage));
    final iconimage = jsonDecode(response.body);
    String f = iconimage['file'];

    if (mounted) {
      setState(() {
        iconimage1 = f;
        loadingiconimage = false;
      });
    }
  }

  iconcasevac() async {
    setState(() {
      loadingiconcasevac = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconcasevac));
    final iconcasevac = jsonDecode(response.body);
    print(iconcasevac);
    String g = iconcasevac['file'];
    if (mounted) {
// your logic here
      setState(() {
        iconcasevac1 = g;
        loadingiconcasevac = false;
      });
    }
  }

  iconredx() async {
    setState(() {
      loadingiconredx = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconredx));
    final iconredx = jsonDecode(response.body);
    String h = iconredx['file'];
    if (mounted) {
      setState(() {
        iconredx1 = h;
        loadingiconredx = false;
      });
    }
  }

  icongoto() async {
    setState(() {
      loadingicongoto = true;
    });
    final response = await http.get(Uri.parse(RestApi.icongoto));
    final icongoto = jsonDecode(response.body);
    String i = icongoto['file'];
    if (mounted) {
// your logic here
      setState(() {
        icongoto1 = i;
        loadingicongoto = false;
      });
    }
    //setState(() {

    //});
  }

  iconsharingmap() async {
    setState(() {
      loadingiconsharingmap = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconsharingmap));
    final iconsharingmap = jsonDecode(response.body);
    String j = iconsharingmap['file'];
    if (mounted) {
      setState(() {
        iconsharingmap1 = j;
        loadingiconsharingmap = false;
      });
    }
  }

  iconbookmark() async {
    setState(() {
      loadingiconbookmark = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconbookmark));
    final iconbookmark = jsonDecode(response.body);
    String h = iconbookmark['file'];
    if (mounted) {
      setState(() {
        iconbookmark1 = h;
        loadingiconbookmark = false;
      });
    }
  }

  iconfavorit() async {
    setState(() {
      loadingiconfavorit = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconfavorit));
    final iconfavorit = jsonDecode(response.body);
    String i = iconfavorit['file'];
    if (mounted) {
      setState(() {
        iconfavorit1 = i;
        loadingiconfavorit = false;
      });
    }
  }

  iconkontak() async {
    setState(() {
      loadingiconkontak = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconkontak));
    final iconkontak = jsonDecode(response.body);
    String j = iconkontak['file'];
    if (mounted) {
      setState(() {
        iconkontak1 = j;
        loadingiconkontak = false;
      });
    }
  }

  iconchatgroup() async {
    setState(() {
      loadingiconchatgroup = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconchatgroup));
    final iconchatgroup = jsonDecode(response.body);
    String k = iconchatgroup['file'];
    if (mounted) {
      setState(() {
        iconchatgroup1 = k;
      });
    } else {}

    setState(() {
      loadingiconchatgroup = false;
    });
  }

  iconemergency() async {
    setState(() {
      loadingiconemergency = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconemergency));
    final iconemergency = jsonDecode(response.body);

    String l = iconemergency['file'];
    if (mounted) {
      setState(() {
        iconemergency1 = l;
      });
    }
    setState(() {
      loadingiconemergency = false;
    });
  }

  iconvidiocall() async {
    setState(() {
      loadingiconvidiocall = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconvidiocall));
    final iconvidiocall = jsonDecode(response.body);
    String m = iconvidiocall['file'];

    if (mounted) {
      setState(() {
        iconvidiocall1 = m;
      });
    }
    setState(() {
      loadingiconvidiocall = false;
    });
  }

  bool loadingiconredbeiring = false;
  iconredbeiring() async {
    setState(() {
      loadingiconredbeiring = true;
    });
    final response = await http.get(Uri.parse(RestApi.iconredbeiring));
    final iconredbeiring = jsonDecode(response.body);
    String rb = iconredbeiring['file'];
    if (mounted) {
      setState(() {
        iconredbeiring1 = rb;
      });
    }

    setState(() {
      loadingiconredbeiring = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getProfiles();
    getLocation();
    _listenLocation();
    _requestpermision();

    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
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
    geticonaddlocation();
    iconenablelocation();
    icondisablelocation();
    icontracking();
    iconimage();
    iconvideo();
    iconcasevac();
    iconredx();
    icongoto();
    iconsharingmap();
    iconbookmark();
    iconfavorit();
    iconkontak();
    iconchatgroup();
    iconemergency();
    iconvidiocall();
  }

  GoogleMapController mycontroller;

  Set<Marker> marke = {};
  var maptype = MapType.normal;
  void _onMapCreatedd(GoogleMapController controller) {
    mycontroller = controller;
  }

  Future<void> _gotoZoomin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _gotoZoomout() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _gotoLake() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationResult.latitude, _locationResult.longitude),
      zoom: 16,
    )));
  }

  bool tampilmenu = false;

  List<RadialMenuEntry> radialMenuEntries = [
    RadialMenuEntry(
        icon: Icons.restaurant, text: 'Restaurant', color: Colors.red),
    RadialMenuEntry(
        icon: Icons.hotel,
        text: 'Hotel',
        iconColor: Colors.lightBlue,
        textColor: Colors.amber),
    RadialMenuEntry(icon: Icons.pool, text: 'Pool', iconSize: 36),
    RadialMenuEntry(icon: Icons.shopping_cart, text: 'Shop'),
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference location = firestore.collection('location');
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("AMARTA"),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/atak_splash.png')),
                  color: Colors.black26),
            ),
            ExpansionTile(
              title: Text("Profil"),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Uploadavatar()));
                            },
                            child: Text('Upload Avatar')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Akunku()));
                            },
                            child: Text('Akun')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Allemergencybecon()));
                  },
                  child: Text(' List EmergencyBecon')),
            ),
            ExpansionTile(
              title: InkWell(
                  onTap: () {
                    menugoto();
                  },
                  child: Text('Go To ')),
            ),
            ExpansionTile(
              title: Text('Range Beiring'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Multidistance()));
                            },
                            child: Text('Calculate Distance')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Mymultipointcari()));
                            },
                            child: Text('View Calculate')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Casevac'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewcasevac()));
                            },
                            child: Text('View')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addcasevac()));
                            },
                            child: Text('Tambah')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Map User Sharing'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Alluser()));
                            },
                            child: Text('Sharing Map')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Bookmark & Favorit'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Getfavorit()));
                            },
                            child: Text('Favorit Map')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Getbookmark()));
                            },
                            child: Text('BookMark Map'))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('GeoChat'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Allkontak()));
                            },
                            child: Text('List Contact')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chatgroup()));
                            },
                            child: Text('Chat Group')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Liskontak()));
                            },
                            child: Text('Chat')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Vidio Stream'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addlokasividio()));
                            },
                            child: Text('Tambah Lokasi Vidio Stream')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Allvidio()));
                            },
                            child: Text('List Vidio')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewvidio()));
                            },
                            child: Text('View Vidio')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Image Lokasi'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewmarker()));
                            },
                            child: Text('View Image Galery')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addlokasiimage()));
                            },
                            child: Text('Tambah Image')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Allimage()));
                            },
                            child: Text('Daftar Lokasi')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  )),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'http://202.43.164.229/amartamedia/public/public/upload/slider/' +
                                      avatar1)),
                          color: Colors.orange,
                          shape: BoxShape.circle),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nama",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          nama_lengkap1,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          email1,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nomor Wa",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          no_wa1,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentPostion.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      /*
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.green,
              heroTag: "btn",
              onPressed: () {
                setState(() {
                  if (maptype == MapType.normal) {
                    this.maptype = MapType.hybrid;
                  } else {
                    this.maptype = MapType.normal;
                  }
                });
              },
              child: Icon(Icons.map_outlined),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.tealAccent,
              heroTag: "btn",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Vidiocall()));
              },
              child: Icon(Icons.missed_video_call_sharp),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Emergencybeacon()));
              },
              child: Image(image: AssetImage('assets/emergenciicon.png')),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: "btn2",
              onPressed: () {
                confirmasi();
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              heroTag: "btn2",
              onPressed: () {
                _gotoLake();
              },
              child: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),

      
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
*/

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          currentPostion == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  polygons: myPolygon(),
                  //   myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: currentPostion, zoom: 15),
                  mapType: maptype,
                  zoomControlsEnabled: false,
                  // zoomGesturesEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    //    mycontroller = controller;
                  },
                  //  myLocationEnabled: true,
                  markers: {
                      Marker(
                          markerId: MarkerId('id'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueMagenta),
                          position: currentPostion)
                    }),
          /* 
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6), blurRadius: 5)
                    ]),
                    height: 100,
                    width: 190,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Nama :",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Row(
                                children: [
                                  Text(
                                    nama_lengkap1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "No Wa :",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            '($no_wa1)',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Text(
                            currentPostion.toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          */
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.8), blurRadius: 5)
                    ]),
                    height: 40,
                    width: 40,
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              if (tampilmenu == false) {
                                tampilmenu = true;
                              } else {
                                tampilmenu = false;
                              }
                            });
                          },
                          child: Image.asset('assets/menuvertical.png')),
                      /*
                        IconButton(
                            onPressed: () {
                             
                              print(tampilmenu);
                            },
                            icon: Icon(Icons.menu))
                            */
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (tampilmenu != false)
            Positioned(
                right: 20,
                top: 60.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  height: 270,
                  width: 310,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /*
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Colors.black.withOpacity(0.15),
                                  child: loadingiconaddlocation
                                      ? Center()
                                      : Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*
                                              Image.network(
                                                'http://8.215.39.14/amarta/public/upload/icon/' +
                                                    iconaddlocation1,
                                                height: 30,
                                                width: 40,
                                              ),
*/

                                              Image.asset(
                                                'assets/icondashboard/iconlokasi.png',
                                                height: 30,
                                                width: 40,
                                              ),
                                              Text("Lokasi",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                  /*
                                        Text(
                                          'Add Lokasi',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.white),
                                        ),
                                        */
                                  onPressed: () async {
                                    _getLocation();
                                    setState(() {
                                      tampilmenu = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: " Lokasi Berhasil Ditambah");
                                  }),
                            ),
                   
                            */

                            SizedBox(width: 5),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingiconenablelocation
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        _listenLocation();
                                        setState(() {
                                          tampilmenu = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "GPS Telah Di Hidupkan");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconenablelocation1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/gpson.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("GPS ON",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingicondisablelocation
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        _stopListinglocation();
                                        setState(() {
                                          tampilmenu = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "GPS Telah Di Matikan");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  icondisablelocation1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/gpsoff.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("GPS OFF",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            /*
                            Container(
                              height: 60,
                              width: 70,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Colors.black.withOpacity(0.15),
                                  child: loadingiconvidiocall
                                      ? Center()
                                      : Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconvidiocall1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                              Image.asset(
                                                'assets/icondashboard/vidiocall.png',
                                                height: 30,
                                                width: 40,
                                              ),
                                              Text("Vidio Call",
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                    Fluttertoast.showToast(msg: "Vidio Call");
                                  }),
                            ),
                            */

                            Container(
                              height: 60,
                              width: 70,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (maptype == MapType.normal) {
                                      this.maptype = MapType.hybrid;
                                    } else {
                                      this.maptype = MapType.normal;
                                    }
                                  });
                                  setState(() {
                                    tampilmenu = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Merubah Type Map");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.transparent.withOpacity(0.5),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.map_sharp,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      Text("Map View",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingicontracking
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          tampilmenu = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Testscreen()));
                                        Fluttertoast.showToast(msg: "Tracking");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  icontracking1,
                                              height: 30,
                                              width: 40,
                                              ),
                                  */
                                            Image.asset(
                                              'assets/icondashboard/tracking.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Tracking",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ]),
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingiconvideo
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        menuvidio();
                                        setState(() {
                                          tampilmenu = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconvideo1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/vidio.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Video Report",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingiconimage
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        menuimage();
                                        setState(() {
                                          tampilmenu = false;
                                        });
                                        /*
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Addlokasiimage()));
                                      Fluttertoast.showToast(msg: "Add Image");
                                    */
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconimage1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/image.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Photo Report",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingiconcasevac
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        menucasevac();
                                        setState(() {
                                          tampilmenu = false;
                                        });
                                        Fluttertoast.showToast(msg: "Casevac");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconcasevac1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/casevac.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Casevac",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 70,
                              child: loadingiconchatgroup
                                  ? Center()
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Laporan()));
                                        Fluttertoast.showToast(msg: "Laporan");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                          Image.network(
                                            'http://8.215.39.14/amarta/public/upload/icon/' +
                                                iconchatgroup1,
                                            height: 30,
                                            width: 40,
                                          ),
                                          */
                                            Image.asset(
                                              'assets/reporting.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Reporting",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(width: 5),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*
                          Container(
                            height: 60,
                            width: 70,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Colors.black.withOpacity(0.15),
                                child: loadingicongoto
                                    ? Center()
                                    : Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  icongoto1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/goto.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Pergi Ke",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                onPressed: () async {
                                  setState(() {
                                    tampilmenu = false;
                                  });
                                  //menugoto();
                                  Fluttertoast.showToast(msg: "Go To");
                                }),
                          ),
                          */
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: loadingiconredx
                                ? Center()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        showModalBottomSheet(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.6),
                                            context: context,
                                            builder: (builder) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1,
                                                child: _isLoading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                            child: ListView(
                                                              children: [
                                                                Container(
                                                                  height: 1,
                                                                  width: 1,
                                                                  child: Column(
                                                                    children: [],
                                                                  ),
                                                                ),
                                                                //hilangkan

                                                                //container gambar

                                                                Container(
                                                                  child:
                                                                      FittedBox(
                                                                    child: Text(
                                                                      "Form ATM",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .indigo,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  height: 30,
                                                                  width: 60,
                                                                ),

                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  child:
                                                                      TextField(
                                                                    cursorHeight:
                                                                        15,
                                                                    controller:
                                                                        namaform,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Judul',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.black),
                                                                      hintText:
                                                                          'Judul',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.redAccent),
                                                                      suffixIcon:
                                                                          Icon(Icons
                                                                              .edit),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),

                                                                Container(
                                                                  height: 150,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      TextField(
                                                                    maxLines:
                                                                        10,
                                                                    cursorHeight:
                                                                        15,
                                                                    controller:
                                                                        keterangan,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Keterangan',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          color:
                                                                              Colors.black),
                                                                      hintText:
                                                                          'Keterangan Lain',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.redAccent),
                                                                      suffixIcon:
                                                                          Icon(Icons
                                                                              .edit),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.indigo, // Background color
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // pickvidio();
                                                                          openCamera();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.camera)),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.indigo, // Background color
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // pickvidio();
                                                                          opengalery();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.image_sharp)),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Center(
                                                                    child: Text(
                                                                        vidiourl !=
                                                                                null
                                                                            ? vidiourl
                                                                            : "Silahkan Pilih Gambar",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 1,
                                                            child: loading
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        InkWell(
                                                                    onTap: () {
                                                                      if (vidiourl ==
                                                                          null) {
                                                                        simpanvidiolokasi(
                                                                            "2");
                                                                      } else {
                                                                        save(
                                                                            "2");
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                15,
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                1,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .indigo,
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                10))),
                                                                        child: Center(
                                                                            child:
                                                                                Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)))),
                                                                  )),
                                                          )
                                                        ],
                                                      ),
                                              );
                                            });

                                        /*
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Formcasevac()));
*/

                                        tampilmenu = false;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconredx1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                          Image.asset(
                                            'assets/ATM.png',
                                            height: 30,
                                            width: 40,
                                          ),
                                          Text("ATM",
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: loadingiconsharingmap
                                ? Center()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        showModalBottomSheet(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.6),
                                            context: context,
                                            builder: (builder) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1,
                                                child: _isLoading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                            child: ListView(
                                                              children: [
                                                                Container(
                                                                  height: 1,
                                                                  width: 1,
                                                                  child: Column(
                                                                    children: [],
                                                                  ),
                                                                ),
                                                                //hilangkan

                                                                //container gambar

                                                                Container(
                                                                  child:
                                                                      FittedBox(
                                                                    child: Text(
                                                                      "Form Bank",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .indigo,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  height: 30,
                                                                  width: 60,
                                                                ),

                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  child:
                                                                      TextField(
                                                                    cursorHeight:
                                                                        15,
                                                                    controller:
                                                                        namaform,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Judul',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.black),
                                                                      hintText:
                                                                          'Judul',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.redAccent),
                                                                      suffixIcon:
                                                                          Icon(Icons
                                                                              .edit),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),

                                                                Container(
                                                                  height: 150,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      TextField(
                                                                    maxLines:
                                                                        10,
                                                                    cursorHeight:
                                                                        15,
                                                                    controller:
                                                                        keterangan,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Keterangan',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          color:
                                                                              Colors.black),
                                                                      hintText:
                                                                          'Keterangan Lain',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.redAccent),
                                                                      suffixIcon:
                                                                          Icon(Icons
                                                                              .edit),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.indigo, // Background color
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // pickvidio();
                                                                          openCamera();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.camera)),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.indigo, // Background color
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // pickvidio();
                                                                          opengalery();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.image_sharp)),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Center(
                                                                    child: Text(
                                                                        vidiourl !=
                                                                                null
                                                                            ? vidiourl
                                                                            : "Silahkan Pilih Gambar",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 1,
                                                            child: loading
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        InkWell(
                                                                    onTap: () {
                                                                      if (vidiourl ==
                                                                          null) {
                                                                        simpanvidiolokasi(
                                                                            "3");
                                                                      } else {
                                                                        save(
                                                                            "3");
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                15,
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                1,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .indigo,
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                10))),
                                                                        child: Center(
                                                                            child:
                                                                                Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)))),
                                                                  )),
                                                          )
                                                        ],
                                                      ),
                                              );
                                            });

                                        tampilmenu = false;
                                      });

/*
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Formbank()));
                                      Fluttertoast.showToast(msg: "Bank");

                                      */
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*
                                          Image.network(
                                            'http://8.215.39.14/amarta/public/upload/icon/' +
                                                iconsharingmap1,
                                            height: 30,
                                            width: 40,
                                          ),
                                          */
                                          Image.asset(
                                            'assets/bankbaru.png',
                                            height: 30,
                                            width: 40,
                                          ),
                                          Text("Bank",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: loadingiconbookmark
                                ? Center()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        showModalBottomSheet(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.6),
                                            context: context,
                                            builder: (builder) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1,
                                                child: _isLoading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        15),
                                                            child: ListView(
                                                              children: [
                                                                Container(
                                                                  height: 1,
                                                                  width: 1,
                                                                  child: Column(
                                                                    children: [],
                                                                  ),
                                                                ),
                                                                //hilangkan

                                                                //container gambar

                                                                Container(
                                                                  child:
                                                                      FittedBox(
                                                                    child: Text(
                                                                      "Form Public Safety",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .indigo,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  height: 30,
                                                                  width: 60,
                                                                ),

                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  child:
                                                                      TextField(
                                                                    cursorHeight:
                                                                        15,
                                                                    controller:
                                                                        namaform,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Judul',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.black),
                                                                      hintText:
                                                                          'Judul',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.redAccent),
                                                                      suffixIcon:
                                                                          Icon(Icons
                                                                              .edit),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),

                                                                Container(
                                                                  height: 150,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      TextField(
                                                                    maxLines:
                                                                        10,
                                                                    cursorHeight:
                                                                        15,
                                                                    controller:
                                                                        keterangan,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          'Keterangan',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          color:
                                                                              Colors.black),
                                                                      hintText:
                                                                          'Keterangan Lain',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.redAccent),
                                                                      suffixIcon:
                                                                          Icon(Icons
                                                                              .edit),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.indigo, // Background color
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // pickvidio();
                                                                          openCamera();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.camera)),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.indigo, // Background color
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // pickvidio();
                                                                          opengalery();
                                                                        },
                                                                        child: Icon(
                                                                            Icons.image_sharp)),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Center(
                                                                    child: Text(
                                                                        vidiourl !=
                                                                                null
                                                                            ? vidiourl
                                                                            : "Silahkan Pilih Gambar",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 1,
                                                            child: loading
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        InkWell(
                                                                    onTap: () {
                                                                      if (vidiourl ==
                                                                          null) {
                                                                        simpanvidiolokasi(
                                                                            "4");
                                                                      } else {
                                                                        save(
                                                                            "4");
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                15,
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                1,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .indigo,
                                                                            borderRadius: BorderRadius.all(Radius.circular(
                                                                                10))),
                                                                        child: Center(
                                                                            child:
                                                                                Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)))),
                                                                  )),
                                                          )
                                                        ],
                                                      ),
                                              );
                                            });

                                        tampilmenu = false;
                                      });
/*
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Formenviroment()));
                                      Fluttertoast.showToast(msg: "Laporan");
*/
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*
                                          Image.network(
                                            'http://8.215.39.14/amarta/public/upload/icon/' +
                                                iconbookmark1,
                                            height: 30,
                                            width: 40,
                                          ),
                                          */
                                          Image.asset(
                                            'assets/publicsafety.png',
                                            height: 30,
                                            width: 40,
                                          ),
                                          Center(
                                            child: Text("Public Safety",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: loadingiconchatgroup
                                ? Center()
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Chatgroup()));
                                      Fluttertoast.showToast(msg: "Chat Group");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*
                                          Image.network(
                                            'http://8.215.39.14/amarta/public/upload/icon/' +
                                                iconchatgroup1,
                                            height: 30,
                                            width: 40,
                                          ),
                                          */
                                          Image.asset(
                                            'assets/icondashboard/chatgroup.png',
                                            height: 30,
                                            width: 40,
                                          ),
                                          Text("Chat Group",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
/*
                          Container(
                            height: 60,
                            width: 70,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Colors.black.withOpacity(0.15),
                                child: loadingiconfavorit
                                    ? Center()
                                    : Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconfavorit1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/favorit.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Favorit",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                onPressed: () async {
                                  setState(() {
                                    tampilmenu = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Getfavorit()));
                                  Fluttertoast.showToast(msg: "Favorit Map");
                                }),
                          ),
                          */
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: loadingiconkontak
                                ? Center()
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Allkontak()));
                                      Fluttertoast.showToast(
                                          msg: "List Contact Map");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*
                                          Image.network(
                                            'http://8.215.39.14/amarta/public/upload/icon/' +
                                                iconkontak1,
                                            height: 30,
                                            width: 40,
                                          ),
                                          */
                                          Image.asset(
                                            'assets/icondashboard/contact.png',
                                            height: 30,
                                            width: 40,
                                          ),
                                          Text("Contact",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: loadingiconemergency
                                ? Center()
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Emergencybeacon()));
                                      Fluttertoast.showToast(
                                          msg: "Emergency Beacon");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*
                                          Image.network(
                                            'http://8.215.39.14/amarta/public/upload/icon/' +
                                                iconemergency1,
                                            height: 30,
                                            width: 40,
                                          ),
                                          */
                                          Image.asset(
                                            'assets/icondashboard/emergency.png',
                                            height: 30,
                                            width: 40,
                                          ),
                                          Text("Emergency",
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => Tampilcctv()));
                            },
                            child: Container(
                              height: 60,
                              width: 70,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                        height: 40,
                                        width: 40,
                                        image: AssetImage('assets/cctv.png')),
                                    Text("Vision Guard",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 60,
                            width: 70,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      height: 40,
                                      width: 40,
                                      image: AssetImage(
                                          'assets/ic_menu_quit.png')),
                                  Text("Exit",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(width: 5),
                          /*
                          Container(
                            height: 60,
                            width: 70,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Colors.black.withOpacity(0.15),
                                child: loadingiconvidiocall
                                    ? Center()
                                    : Container(
                                        child: Column(
                                          children: [
                                            /*
                                            Image.network(
                                              'http://8.215.39.14/amarta/public/upload/icon/' +
                                                  iconredbeiring1,
                                              height: 30,
                                              width: 40,
                                            ),
                                            */
                                            Image.asset(
                                              'assets/icondashboard/redbeiring.png',
                                              height: 30,
                                              width: 40,
                                            ),
                                            Text("Range Beiring",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                onPressed: () async {
                                  /*
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Ringbeiring()));*/
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Multidistance()));
//

                                  setState(() {
                                    tampilmenu = false;
                                  });
                                  Fluttertoast.showToast(msg: "Range Beiring");
                                }),
                          ),
*/

                          SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  _stopListinglocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(idku).set({
        'online': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }

    _locationSubscription?.cancel();

    setState(() {
      _locationSubscription = null;
    });
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      await FirebaseFirestore.instance.collection('location').doc(idku).set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'name': nama_lengkap1,
        'userid': idku,
        'no_wa': no_wa1,
        'online': 1,
      }, SetOptions(merge: true));
    });
  }

//menambahkan lokasi ke firebase
  void _getLocation() async {
    print(nama_lengkap1);
    print(idku);
    print(no_wa1);
    print(jabatan1);
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(idku).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': nama_lengkap1,
        'userid': idku,
        'no_wa': no_wa1,
        'online': 0,
        'jabatan': jabatan1,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  _requestpermision() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("OK");
    } else if (status.isDenied) {
      _requestpermision();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
