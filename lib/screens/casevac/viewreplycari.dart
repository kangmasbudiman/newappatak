import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_map_live/core/models/listvidiolokasicari.dart';
import 'package:google_map_live/core/models/listviewreply.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/vidio/playvidio.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:http/http.dart' as http;

class Allreply extends StatefulWidget {
  final String idcasevac;

  const Allreply({Key key, this.idcasevac}) : super(key: key);

  @override
  _AllreplyState createState() => _AllreplyState();
}

class _AllreplyState extends State<Allreply> {
  //Theme Data

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Other Variables
  bool showPassword = false;

  //UI Variables
  OutlineInputBorder allTFBorder;
  double lat;
  double lon;

  var loadingvidio = false;
  final listvidio = new List<Listviewreply>();

  var loadingdokter = false;

  List<Listviewreply> _list = [];
  List<Listviewreply> _search = [];

  getCurrentLocation() async {
    setState(() {
      loadingvidio = true;
    });

    _list.clear();
    setState(() {
      loadingdokter = true;
    });

    final responsee = await http.post(Uri.parse(RestApi.hasilreply),
        body: {"idcasevac": widget.idcasevac});

    if (responsee.statusCode == 200) {
      final datadokter = jsonDecode(responsee.body);
      print(datadokter);
      setState(() {
        for (Map i in datadokter) {
          _list.add(Listviewreply.fromJson(i));
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
      if (f.nama.contains(text) || f.nama.contains(text)) _search.add(f);
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
                backgroundColor: Colors.green,
                title: Text("All Reply",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Kali',
                    ))),
            body: ListView(
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
                            height: MediaQuery.of(context).size.height / 1.8,
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
                                                          const EdgeInsets.all(
                                                              4.0),
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
                                                              height: 70,
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
                                                                          BorderRadius.all(
                                                                              Radius.circular(
                                                                        10,
                                                                      ))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "Replied From :",
                                                                              style: TextStyle(fontFamily: 'Kali', fontSize: 18),
                                                                            ),
                                                                            Text(dt.nama,
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontFamily: 'Kali',
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                            dt.reply,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Kali',
                                                                            )),
                                                                                 Text(
                                                                            dt.created_at,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Kali',
                                                                            )),
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
                                                  if (dr == null) {
                                                    return Center(
                                                      child: Text("No Reply"),
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4.0),
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
                                                                height: 90,
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
                                                                          4.0),
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
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Replied From : ",
                                                                                style: TextStyle(fontFamily: 'Kali', fontSize: 18),
                                                                              ),
                                                                              Text(dr.nama,
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontFamily: 'Kali',
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Text(
                                                                              dr.reply,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'Kali',
                                                                              )),
                                                                                          Text(
                                                                              dr.created_at,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'Kali',
                                                                              )),
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
                                                  }
                                                })))
                        //Column(children: newsList)
                      ],
                    ),
                  ),
                )
              ],
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
