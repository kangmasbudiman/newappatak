import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/multipointdistance.dart';
import 'package:google_map_live/restapi/restApi.dart';

import 'dart:math' show cos, sqrt, asin;
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hasillatlang extends StatefulWidget {
  final List<dynamic> list;
  const Hasillatlang({Key key, this.list}) : super(key: key);

  @override
  State<Hasillatlang> createState() => _HasillatlangState();
}

class _HasillatlangState extends State<Hasillatlang> {
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";
  String idgroup1 = "";
  String idgroup = "";
  bool _isLoading = false;
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
    print(idku);
    getdistance();
  }

  getdistance() async {
    final response = await http.post(Uri.parse(RestApi.getlatlangrange), body: {
      "iduser": idku,
    });

    // final response = await http.get(Uri.parse(RestApi.getredx));

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      print("ini data dari responRestApi");
      print(data);

      double calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 -
            c((lat2 - lat1) * p) / 2 +
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
        return 12742 * asin(sqrt(a));
      }

      final Distance distance = Distance();
      double totalDistanceInM = 0;
      double totalDistanceInKm = 0;

      for (var i = 0; i < data.length - 1; i++) {
        totalDistanceInM += distance(LatLng( double.parse(data[i]["lat"])    ,double.parse(data[i]["lng"]) ),
            LatLng(double.parse(data[i + 1]["lat"])        , double.parse(data[i + 1]["lng"])      ));

        totalDistanceInKm += distance.as(
          LengthUnit.Kilometer,
          LatLng(    double.parse(data[i]["lat"]) ,double.parse(data[i]["lng"]) ),
          LatLng(double.parse(data[i + 1]["lat"]), double.parse(data[i + 1]["lng"])   ),
        );
      }
      setState(() {
        jarak = totalDistanceInKm.floor().toString();
      });
      print(totalDistanceInKm.floor());
    }
  }

  List<dynamic> coba = [];
  String jarak = "";

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
                  'Clear Success',
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
      "totaldistance": jarak,
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
    getProfiles();

    // ambildataku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total Distance:",
              style: TextStyle(fontSize: 35, color: Colors.red),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jarak,
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
                Text(
                  "  KM",
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                //hapus();
                //   name();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Multidistance(
                      distance: jarak,
                    )));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Save ",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Icon(
                        Icons.archive_sharp,
                        color: Colors.white,
                        size: 30,
                      )
                    ],
                  ),
                  height: 50,
                  width: double.infinity,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
