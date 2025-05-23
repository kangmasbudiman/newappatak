import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/core/models/listimagelokasicari.dart';

import 'package:google_map_live/core/models/listvidiolokasicari.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/imagelokasi/daftarimage.dart';
import 'package:google_map_live/screens/imagelokasi/uploadimage.dart';
import 'package:google_map_live/screens/vidio/playvidio.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Allimage extends StatefulWidget {
  @override
  _AllimageState createState() => _AllimageState();
}

class _AllimageState extends State<Allimage> {
  //Theme Data

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Other Variables
  bool showPassword = false;

  //UI Variables
  OutlineInputBorder allTFBorder;
  double lat;
  double lon;

  var loadingvidio = false;
  final listvidio = new List<Listimagecari>();

  var loadingdokter = false;

  List<Listimagecari> _list = [];
  List<Listimagecari> _search = [];

  getCurrentLocation(String kodesort) async {
    setState(() {
      loadingvidio = true;
    });

    _list.clear();
    setState(() {
      loadingdokter = true;
    });

    //final responsee = await http.get(Uri.parse(RestApi.getimage));

    final responsee =
        await http.post(Uri.parse(RestApi.getimagedenganphoto), body: {
      "idgroup": idgroup1,
      "kodesort": kodesort,
    });

    if (responsee.statusCode == 200) {
      final datadokter = jsonDecode(responsee.body);
      print(datadokter);
      setState(() {
        for (Map i in datadokter) {
          _list.add(Listimagecari.fromJson(i));
          loadingdokter = false;
        }
      });
    } else {
      setState(() {
        loadingdokter = false;
      });
    }
  }

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
      getCurrentLocation("1");
    });
  }

  TextEditingController controller = new TextEditingController();
  _onsearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.namalokasi.contains(text) || f.namalokasi.contains(text))
        _search.add(f);
    });
    setState(() {});
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
    final response = await http.post(Uri.parse(RestApi.deletebyimage), body: {
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
                  'Delete Image Berhasil',
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
                getProfiles();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getProfiles();
    //getCurrentLocation("1");
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

  _initUI() {
    allTFBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: Colors.blue, width: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              leading: new IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, boxShadow: []),
                  child: new Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
              backgroundColor: Colors.black,
              title: Text("Daftar Image Lokasi",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Kali',
                  )),
              actions: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          getCurrentLocation("1");
                        },
                        icon: Icon(Icons.download)),
                    SizedBox(
                      width: 2,
                    ),
                    IconButton(
                        onPressed: () {
                          getCurrentLocation("2");
                        },
                        icon: Icon(Icons.upload)),
                  ],
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/atak_splash_blank.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Color(0xffb6b6b6),
                                    offset: Offset(
                                      3,
                                      3,
                                    ),
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(
                                  10,
                                ))),
                            height: 60,
                            padding: EdgeInsets.all(4.0),
                            margin: EdgeInsets.all(8.0),
                            child: new TextField(
                              controller: controller,
                              onChanged: _onsearch,
                              autofocus: true,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  hintText: "Cari Lokasi",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.clear();
                                      _onsearch('');
                                    },
                                    icon: Icon(Icons.search),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        style: BorderStyle.none,
                                      ))),
                            ),
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: loadingdokter
                                  ? Center()
                                  : Container(
                                      child:
                                          _search.length != 0 ||
                                                  controller.text.isNotEmpty
                                              ? ListView.builder(
                                                  itemCount: _search.length,
                                                  itemBuilder: (context, i) {
                                                    final dt = _search[i];

                                                    return InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 7,
                                                            ),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 60,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            blurRadius:
                                                                                2,
                                                                            color:
                                                                                Color(0xffb6b6b6),
                                                                            offset:
                                                                                Offset(
                                                                              3,
                                                                              3,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                          10,
                                                                        ))),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Lokasi",
                                                                            style:
                                                                                TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                              dt.namalokasi,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'Kali',
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => Uploadimages(
                                                                                        id: dt.id,
                                                                                      )));
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .photo_album,
                                                                          size:
                                                                              40,
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => Uploadimages(
                                                                                        id: dt.id,
                                                                                      )));
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add_photo_alternate_outlined,
                                                                          size:
                                                                              40,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    );
                                                  })
                                              : ListView.builder(
                                                  itemCount: _list.length,
                                                  itemBuilder: (context, i) {
                                                    final dr = _list[i];

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          print("asdasd");
                                                        },
                                                        child: Container(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 7,
                                                            ),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 60,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            blurRadius:
                                                                                2,
                                                                            color:
                                                                                Color(0xffb6b6b6),
                                                                            offset:
                                                                                Offset(
                                                                              3,
                                                                              3,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                          10,
                                                                        ))),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          9.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Nama Lokasi",
                                                                            style:
                                                                                TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                              dr.namalokasi,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'Kali',
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              /*
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Daftarimage(
                                                                                            idimage: dr.id,
                                                                                          )));
*/

                                                                              konfirmasi(dr.id.toString());
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
/*
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Uploadimages(
                                                                                            id: dr.id,
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.add_photo_alternate_outlined,
                                                                              size: 40,
                                                                            ),
                                                                          ),
*/
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    );
                                                  })))
                          //Column(children: newsList)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  void showMessage({String message = "Something wrong", Duration duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
