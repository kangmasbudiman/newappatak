import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/core/models/modelpolygon.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/adduser.dart';
import 'package:google_map_live/screens/area.dart';
import 'package:google_map_live/ui/screen/home_screen.dart';
import 'package:google_map_live/utils/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Alluser extends StatefulWidget {
  const Alluser({Key key}) : super(key: key);

  @override
  State<Alluser> createState() => _AlluserState();
}

class _AlluserState extends State<Alluser> {
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

  //data area
  var loading = false;
  final listarea = new List<Modepolygon>();

  tampil() async {
    listarea.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(RestApi.getpolygon));
    if (response.contentLength == 2) {
    } else {
      final datapromo = jsonDecode(response.body);
      datapromo.forEach((api) {
        final p = new Modepolygon(api['id'], api['title']);
        listarea.add(p);
      });

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> pesanbookmark() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Berhasil Ditambahkan ke bookmark',
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
                  'Berhasil Ditambahkan ke favorit',
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

  int datafavorit = 0;
  setbookmark() async {
    final response = await http.post(Uri.parse(RestApi.setbookmark), body: {
       "idpolygon": datafavorit.toString(),
      "iduser": idku,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesanbookmark();
    } else {
      print("Data gagal");
    }
  }

  setfavorit() async {
    final response = await http.post(Uri.parse(RestApi.setfavorit), body: {
      "idpolygon": datafavorit.toString(),
      "iduser": idku
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesan();
    } else {
      print("Data gagal");
    }
  }

  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";

  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    tampil();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location_alt),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: listarea.length,
                  itemBuilder: (context, i) {
                    final data = listarea[i];
                    return ListTile(
                      enabled: true,
                      tileColor: Colors.blue,
                      title: Row(
                        children: [
                          Text(
                            "Nama Area :",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            data.title,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  datafavorit = data.id;
                                });
                                setfavorit();
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 30,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                datafavorit = data.id;
                              });
                              setbookmark();
                            },
                            child: Icon(
                              Icons.bookmark_added_outlined,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ));
  }
}
