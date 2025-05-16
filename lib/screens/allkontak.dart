import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/akuntemen.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/japri.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

class Allkontak extends StatefulWidget {
  const Allkontak({Key key}) : super(key: key);

  @override
  State<Allkontak> createState() => _AllkontakState();
}

class _AllkontakState extends State<Allkontak> {
  Stream<QuerySnapshot<Map<String, dynamic>>> collectionstream =
      FirebaseFirestore.instance
          .collection('location')
          // .where('online', isEqualTo: 1)
          .snapshots();

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
    print("set state");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();
    idgroup = preferences.getString("idgroup").toString();
    email = preferences.getString("email").toString();
    jabatan = preferences.getString("jabatan").toString();
    print("ini data get profil all kontak");
    print(id);
    ambilgambar(id);
    setState(() {
      _isLoading = false;
      idku = id;
      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
      idgroup1 = idgroup;
      email1 = email;
    });
  }

  bool imageReady = false;
  bool loadingavatar = false;
  ambilgambar(String id) async {
    // final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      loadingavatar = true;
    });

    final response = await http.post(Uri.parse(RestApi.getavatar), body: {
      "id": id,
    });
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      int value = data['value'];
      String avatar = data['foto'];
      setState(() {
        avatar1 = avatar;
        print("ini idku sekarang");
        print(idku);
        print("ini avatarku");
        print(avatar1);
      });
      loadingavatar = false;
    }
  }

  @override
  void initState() {
    super.initState();

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
      appBar: new AppBar(
        title: new Text("Semua Kontak"),
      ),
      body: collectionstream == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height / 1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/atak_splash_blank.png'),
                      fit: BoxFit.cover)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          )),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            loadingavatar
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  'http://202.43.164.229/amartamedia/public/public/upload/slider/' +
                                                      avatar1)),
                                          color: Colors.orange,
                                          shape: BoxShape.circle),
                                    ),
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
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: StreamBuilder(
                        stream: collectionstream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  print(snapshot.data.docs[index]['userid']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      /*
                                      subtitle: Text(snapshot.data.docs[index]
                                          .data()['no_wa']),
                                          */
                                      title: Text(
                                        snapshot.data.docs[index]
                                            .data()['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (contex) =>
                                                          Akuntemen(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['userid'],
                                                            nama: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                          )));
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/ic_menu_help.png')),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Chetscreen(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['userid'],
                                                            nama: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
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
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
