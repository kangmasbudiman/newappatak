import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/EditProfil.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/screens/imagelokasi/viewmarker.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Akunku extends StatefulWidget {
  final String id;
  const Akunku({Key key, this.id}) : super(key: key);

  @override
  State<Akunku> createState() => _AkunkuState();
}

class _AkunkuState extends State<Akunku> {
  final loc.Location location = loc.Location();
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

  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();
    idgroup = preferences.getString("idgroup").toString();
    email = preferences.getString("email").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
      idgroup1 = idgroup;
      email1 = email;
      print(email1);
    });
    ambilgambar();
  }

  bool loadingavatar = false;

  ambilgambar() async {
    setState(() {
      loadingavatar = true;
    });
    final loc.LocationData _locationResult = await location.getLocation();

    final response = await http.post(Uri.parse(RestApi.getavatar), body: {
      "id": idku,
    });
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      int value = data['value'];
      String avatar = data['file'];
      setState(() {
        avatar1 = avatar;
        latitude = _locationResult.latitude.toString();
        longitude = _locationResult.longitude.toString();
      });
    }
    print(avatar1);
    setState(() {
      loadingavatar = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getProfiles();
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
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
          title: Text("Akun", style: TextStyle(color: Colors.white)),
          backwardsCompatibility: false,
          backgroundColor: Colors.transparent),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/atak_splash_blank.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        loadingavatar
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'http://8.215.39.14/amarta/public/upload/event/' +
                                                  avatar1)),
                                      color: Colors.orange,
                                      shape: BoxShape.circle),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfil(
                                              name: nama_lengkap1,
                                              email: email1,
                                              nowa: no_wa1,
                                              id: idku,
                                            )));
                              },
                              child: Container(
                                height: 35,
                                width: 50,
                                child: Icon(Icons.edit_outlined),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                            ),
                          ],
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              email1,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                              "Latitude",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              latitude,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Longitude",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              longitude,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  height: 250,
                  //  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 2, color: Colors.white)),
                ),
              ),
            ),
/*
            Positioned(
                top: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [loadingavatar?Center(child: CircularProgressIndicator(),):
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'http://8.215.39.14/amarta/public/upload/event/' +
                                      avatar1)),
                          color: Colors.orange,
                          shape: BoxShape.circle),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nama",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(":", style: TextStyle(color: Colors.white)),
                        Text(
                          nama_lengkap1,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nomor Wa",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(":", style: TextStyle(color: Colors.white)),
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
                          "Latitude",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(":", style: TextStyle(color: Colors.white)),
                        Text(
                          latitude,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Longitude",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(":", style: TextStyle(color: Colors.white)),
                        Text(
                          longitude,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                )
                ),
                */
          ],
        ),
      ),
    );
  }
}
