import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/core/models/listemergencycari.dart';

import 'package:google_map_live/core/models/listvidiolokasicari.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/detailemergencybecon.dart';
import 'package:google_map_live/screens/vidio/playvidio.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:http/http.dart' as http;

class Allemergencybecon extends StatefulWidget {
  @override
  _AllemergencybeconState createState() => _AllemergencybeconState();
}

class _AllemergencybeconState extends State<Allemergencybecon> {
  //Theme Data

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Other Variables
  bool showPassword = false;

  //UI Variables
  OutlineInputBorder allTFBorder;
  double lat;
  double lon;

  var loadingvidio = false;
  final listvidio = new List<Listemergencycari>();

  var loadingdokter = false;

  List<Listemergencycari> _list = [];
  List<Listemergencycari> _search = [];

  getCurrentLocation() async {
    print("ini datanya");

    _list.clear();
    setState(() {
      loadingdokter = true;
    });

    final responsee = await http.get(Uri.parse(RestApi.getemergencybecon));
    if (responsee.statusCode == 200) {
      final datadokter = jsonDecode(responsee.body);
      print("ini data emergency");
      print(datadokter);
      setState(() {
        for (Map i in datadokter) {
          _list.add(Listemergencycari.fromJson(i));
          loadingdokter = false;
        }
      });
    } else {
      setState(() {
        loadingdokter = false;
      });
    }
  }



  TextEditingController controller = new TextEditingController();
  _onsearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.laporan.contains(text) || f.laporan.contains(text)) _search.add(f);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
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

  Future<void> konfirmasi(int id) async {
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

                    _hapus(id);
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

  _hapus(int id) async {
    final response =
        await http.post(Uri.parse(RestApi.deleteemergencybecon), body: {
      "id": id.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'].toString();
    if (value == "1") {
      pesan();
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
                  'Delete Success',
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
                getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
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
                title: Text("All EmergencyBecon",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Kali',
                    ))),
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
                                  hintText: "Search",
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
                              height: MediaQuery.of(context).size.height / 1.1,
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

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
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
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            Detailemergency(
                                                                              laporan: dt.laporan,
                                                                              foto: dt.foto,
                                                                            )));
                                                              },
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
                                                                            dt.nama,
                                                                            style:
                                                                                TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                              dt.laporan,
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
                                                                              konfirmasi(dt.id);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              size: 40,
                                                                            ),
                                                                          ),
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
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            Detailemergency(
                                                                              laporan: dr.laporan,
                                                                              foto: dr.foto,
                                                                            )));
                                                              },
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
                                                                            dr.nama,
                                                                            style:
                                                                                TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                          ),
                                                                          Text(
                                                                              dr.laporan,
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
                                                                              konfirmasi(dr.id);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              size: 40,
                                                                            ),
                                                                          ),
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
