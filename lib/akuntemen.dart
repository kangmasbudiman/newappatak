import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/screens/imagelokasi/viewmarker.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Akuntemen extends StatefulWidget {
  final String id;
  final String nama;
  const Akuntemen({Key key, this.id, this.nama}) : super(key: key);

  @override
  State<Akuntemen> createState() => _AkuntemenState();
}

class _AkuntemenState extends State<Akuntemen> {
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

  bool loadingavatar = false;

  ambilgambar() async {
    setState(() {
      loadingavatar = true;
    });
    // final loc.LocationData _locationResult = await location.getLocation();

    final response = await http.post(Uri.parse(RestApi.getavatar1), body: {
      "id": widget.id,
    });
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      int value = data['value'];
      String avatar = data['file'];
      String email = data['email'];
      String no_wa = data['no_wa'];
      String nama_lengkap = data['nama_lengkap'];

      setState(() {
        avatar1 = avatar;
        email1 = email;
        nama_lengkap1 = nama_lengkap;
        no_wa1 = no_wa;
      });
    }
    loadingavatar = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ambilgambar();
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
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
          title: Text("Kontak", style: TextStyle(color: Colors.white)),
          backwardsCompatibility: false,
          backgroundColor: Colors.transparent),
      body: loadingavatar
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // child: Text(avatar1),
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
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chetscreen(
                                                id: widget.id,
                                                nama: widget.nama,
                                              )));
                                },
                                child: Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          scale: 3,
                                          image: AssetImage(
                                              'assets/ic_menu_chat.png')),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      border: Border.all(
                                          width: 2, color: Colors.white)),
                                ),
                              ),
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
                      top: 270,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          loadingavatar
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      /*
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'http://8.215.39.14/amarta/public/upload/event/' +
                                            avatar1)),
                                            */
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
                        ],
                      )),
                      */
                ],
              ),
            ),
    );
  }
}
