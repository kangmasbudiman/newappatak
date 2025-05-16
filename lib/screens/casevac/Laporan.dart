import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_map_live/core/models/listcasevac.dart';
import 'package:google_map_live/core/models/listcasevacatm.dart';
import 'package:google_map_live/core/models/listcasevacbank.dart';
import 'package:google_map_live/core/models/listcasevacenviroment.dart';

import 'package:google_map_live/newgoto/mapboxcasevac.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/casevac/viewatm.dart';
import 'package:google_map_live/screens/casevac/viewbank.dart';
import 'package:google_map_live/screens/casevac/viewcasevac.dart';
import 'package:google_map_live/screens/casevac/viewenviroment.dart';

import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  var loadingvidio = false;
  final listvidio = new List<Listcasevac>();

  var loadingdokter = false;
//casevac
  List<Listcasevac> _list = [];
  List<Listcasevac> _search = [];
//atm
  List<Listcasevacatm> _listatm = [];
  List<Listcasevacatm> _searchatm = [];
//bank
  List<Listcasevacbank> _listbank = [];
  List<Listcasevacbank> _searchbank = [];

//enviroment
  List<Listcasevacenviroment> _listenviroment = [];
  List<Listcasevacenviroment> _searchenviroment = [];

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

      getCurrentLocation("1");
      getatm("1");
      getbank("1");
      getenviroment("1");
    });
  }

  getCurrentLocation(String kodesort) async {
    setState(() {
      loadingvidio = true;
    });

    _list.clear();
    setState(() {
      loadingdokter = true;
    });
    final response = await http.post(Uri.parse(RestApi.getcasevac), body: {
      "idgroup": idgroup1,
      "kodesort": kodesort,
    });
    if (response.statusCode == 200) {
      final datadokter = jsonDecode(response.body);
      print("ini data casevac");
      print(datadokter);

      setState(() {
        for (Map i in datadokter) {
          _list.add(Listcasevac.fromJson(i));
          loadingdokter = false;
        }
      });
    } else {
      setState(() {
        loadingdokter = false;
      });
    }
  }

  getatm(String kodesort) async {
    setState(() {
      loadingvidio = true;
    });

    _listatm.clear();
    setState(() {
      loadingdokter = true;
    });
    final responseatm = await http.post(Uri.parse(RestApi.getatm), body: {
      "idgroup": idgroup1,
      "kodesort": kodesort,
    });
    if (responseatm.statusCode == 200) {
      final dataatm = jsonDecode(responseatm.body);
      print("ini data atm");
      print(dataatm);

      setState(() {
        for (Map i in dataatm) {
          _listatm.add(Listcasevacatm.fromJson(i));
          loadingdokter = false;
        }
      });
    } else {
      setState(() {
        loadingdokter = false;
      });
    }
  }

  getbank(String kodesort) async {
    setState(() {
      loadingvidio = true;
    });

    _listbank.clear();
    setState(() {
      loadingdokter = true;
    });
    final responsebank = await http.post(Uri.parse(RestApi.getbank), body: {
      "idgroup": idgroup1,
      "kodesort": kodesort,
    });
    if (responsebank.statusCode == 200) {
      final databank = jsonDecode(responsebank.body);
      print("ini data bank");
      print(databank);
      setState(() {
        for (Map i in databank) {
          _listbank.add(Listcasevacbank.fromJson(i));
          loadingdokter = false;
        }
      });
    } else {
      setState(() {
        loadingdokter = false;
      });
    }
  }

  getenviroment(String kodesort) async {
    setState(() {
      loadingvidio = true;
    });

    _listenviroment.clear();
    setState(() {
      loadingdokter = true;
    });
    final responseenviroment =
        await http.post(Uri.parse(RestApi.getenviroment), body: {
      "idgroup": idgroup1,
      "kodesort": kodesort,
    });
    if (responseenviroment.statusCode == 200) {
      final dataenviroment = jsonDecode(responseenviroment.body);
      print("ini data enviroment");
      print(dataenviroment);
      setState(() {
        for (Map i in dataenviroment) {
          _listenviroment.add(Listcasevacenviroment.fromJson(i));
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
  TextEditingController controlleratm = new TextEditingController();
  TextEditingController controllerbank = new TextEditingController();
  TextEditingController controllerenviroment = new TextEditingController();

  _onsearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.pesan.contains(text) || f.pesan.contains(text)) _search.add(f);
    });
    setState(() {});
  }

  _onsearchatm(String text) async {
    _searchatm.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _listatm.forEach((f) {
      if (f.pesan.contains(text) || f.pesan.contains(text)) _searchatm.add(f);
    });
    setState(() {});
  }

  _onsearchbank(String text) async {
    _searchbank.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _listbank.forEach((f) {
      if (f.pesan.contains(text) || f.pesan.contains(text)) _searchbank.add(f);
    });
    setState(() {});
  }

  _onsearchenviroment(String text) async {
    _searchenviroment.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _listenviroment.forEach((f) {
      if (f.pesan.contains(text) || f.pesan.contains(text))
        _searchenviroment.add(f);
    });
    setState(() {});
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
    getProfiles();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: new Text("Laporan"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.print))],
          bottom: TabBar(
            tabs: [
              Tab(
                text: ("Casevac"),
              ),
              Tab(
                text: ("ATM"),
              ),
              Tab(
                text: ("Bank"),
              ),
              Tab(
                text: ("Enviroment"),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      
                      children: [
                         InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Viewcasevac()));
                          },
                          child: Container(child: Icon(Icons.map_rounded,size:50,color:Colors.orange),)),
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
                                hintText: "Cari",
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                          child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              height: 140,
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
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          dt.nama_lengkap == null
                                                                              ? "-"
                                                                              : dt.nama_lengkap,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Kali',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "Keterangan",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Kali',
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                            dt.keterangan == null
                                                                                ? "-"
                                                                                : dt.keterangan,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Kali',
                                                                            )),
                                                                        Text(
                                                                            "______________"),
                                                                        Row(
                                                                          children: [
                                                                            Text(dt.jenispasien == null
                                                                                ? "-"
                                                                                : dt.jenispasien),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(dt.levelurgency == null
                                                                                ? "-"
                                                                                : dt.levelurgency),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                            "Lokasi"),
                                                                        Text(dt.keadaanlokasi ==
                                                                                null
                                                                            ? "-"
                                                                            : dt.keadaanlokasi)
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            print("ini itu ");
                                                                            // konfirmasi(dt.id.toString());
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete_forever,
                                                                            size:
                                                                                40,
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
                                                              height: 140,
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
                                                                        9.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          dr.nama_lengkap == null
                                                                              ? "-"
                                                                              : dr.nama_lengkap,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Kali',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "Keterangan",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Kali',
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                            dr.keterangan == null
                                                                                ? "-"
                                                                                : dr.keterangan,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Kali',
                                                                            )),
                                                                        Text(
                                                                            "______________"),
                                                                        Row(
                                                                          children: [
                                                                            Text(dr.jenispasien == null
                                                                                ? ""
                                                                                : dr.jenispasien),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(dr.levelurgency == null
                                                                                ? "-"
                                                                                : dr.levelurgency),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                            "Lokasi"),
                                                                        Text(dr.keadaanlokasi ==
                                                                                null
                                                                            ? "-"
                                                                            : dr.keadaanlokasi)
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            print("ini itu ");
                                                                            //  konfirmasi(dr.id.toString());
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete_forever,
                                                                            size:
                                                                                40,
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
          )),
          //atm awal
          Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Viewatm()));
                          },
                          child: Container(child: Icon(Icons.map_rounded,size:50,color:Colors.orange),)),
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
                            controller: controlleratm,
                            onChanged: _onsearchatm,
                            autofocus: true,
                            decoration: InputDecoration(
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                hintText: "Cari",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.clear();
                                    _onsearchatm('');
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
                                        _searchatm.length != 0 ||
                                                controlleratm.text.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: _searchatm.length,
                                                itemBuilder: (context, i) {
                                                  final dt = _searchatm[i];

                                                  return InkWell(
                                                    onTap: () {},
                                                    child: Padding(
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
                                                                          9.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                              width: MediaQuery.of(context).size.width / 4,
                                                                              height: MediaQuery.of(context).size.height / 8,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: dt.foto == null ? AssetImage('assets/itm.png') : NetworkImage('http://202.43.164.229/amartamedia/public/public/upload/slider/' + dt.foto)))),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    "Judul",
                                                                                    style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(dt.pesan == null ? "-" : dt.pesan,
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'Kali',
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(
                                                                                "Keterangan",
                                                                                style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                              ),
                                                                              Text(dt.keterangan == null ? "-" : dt.keterangan,
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontFamily: 'Kali',
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () => Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Mapboxcasevac(
                                                                                          //startposition:startposition ,
                                                                                          posisi: currentPostion,
                                                                                          endposisi: LatLng(double.parse(dt.latitude), double.parse(dt.longitude)),
                                                                                        ))),
                                                                            child:
                                                                                Icon(Icons.location_on, size: 30),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : ListView.builder(
                                                itemCount: _listatm.length,
                                                itemBuilder: (context, i) {
                                                  final dr = _listatm[i];

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
                                                                          BorderRadius.all(
                                                                              Radius.circular(
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
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            width: MediaQuery.of(context).size.width /
                                                                                4,
                                                                            height: MediaQuery.of(context).size.height /
                                                                                8,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: dr.foto == null ? AssetImage('assets/itm.png') : NetworkImage('http://202.43.164.229/amartamedia/public/public/upload/slider/' + dr.foto)))),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "Judul",
                                                                                  style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(dr.pesan == null ? "-" : dr.pesan,
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontFamily: 'Kali',
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text(
                                                                              "Keterangan",
                                                                              style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                            ),
                                                                            Text(dr.keterangan == null ? "-" : dr.keterangan,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontFamily: 'Kali',
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            print(dr.latitude);
                                                                            print(dr.longitude);

                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Mapboxcasevac(
                                                                                          //startposition:startposition ,
                                                                                          posisi: currentPostion,
                                                                                          endposisi: LatLng(double.parse(dr.latitude), double.parse(dr.longitude)),
                                                                                        )));
                                                                          },
                                                                          child: Icon(
                                                                              Icons.location_on,
                                                                              size: 30),
                                                                        ),
                                                                      ],
                                                                    )
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
          //atm akhir
          //bank awal
          Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                         InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Viewbank()));
                          },
                          child: Container(child: Icon(Icons.map_rounded,size:50,color:Colors.orange),)),
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
                            controller: controllerbank,
                            onChanged: _onsearchbank,
                            autofocus: true,
                            decoration: InputDecoration(
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                hintText: "Cari",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.clear();
                                    _onsearchbank('');
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
                                        _searchbank.length != 0 ||
                                                controlleratm.text.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: _searchbank.length,
                                                itemBuilder: (context, i) {
                                                  final dt = _searchbank[i];

                                                  return InkWell(
                                                    onTap: () {},
                                                    child: Padding(
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
                                                                          9.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                              width: MediaQuery.of(context).size.width / 4,
                                                                              height: MediaQuery.of(context).size.height / 8,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: dt.foto == null ? AssetImage('assets/bank-solid-240.png') : NetworkImage('http://202.43.164.229/amartamedia/public/public/upload/slider/' + dt.foto)))),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    "Judul",
                                                                                    style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(dt.pesan == null ? "-" : dt.pesan,
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'Kali',
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(
                                                                                "Keterangan",
                                                                                style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                              ),
                                                                              Text(dt.keterangan == null ? "-" : dt.keterangan,
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontFamily: 'Kali',
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () => Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Mapboxcasevac(
                                                                                          //startposition:startposition ,
                                                                                          posisi: currentPostion,
                                                                                          endposisi: LatLng(double.parse(dt.latitude), double.parse(dt.longitude)),
                                                                                        ))),
                                                                            child:
                                                                                Icon(Icons.location_on, size: 30),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : ListView.builder(
                                                itemCount: _listbank.length,
                                                itemBuilder: (context, i) {
                                                  final dr = _listbank[i];

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
                                                                          BorderRadius.all(
                                                                              Radius.circular(
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
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            width: MediaQuery.of(context).size.width /
                                                                                4,
                                                                            height: MediaQuery.of(context).size.height /
                                                                                8,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: dr.foto == null ? AssetImage('assets/bank-solid-240.png') : NetworkImage('http://202.43.164.229/amartamedia/public/public/upload/slider/' + dr.foto)))),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "Judul",
                                                                                  style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(dr.pesan == null ? "-" : dr.pesan,
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontFamily: 'Kali',
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text(
                                                                              "Keterangan",
                                                                              style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                            ),
                                                                            Text(dr.keterangan == null ? "-" : dr.keterangan,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontFamily: 'Kali',
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            print(dr.latitude);
                                                                            print(dr.longitude);

                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Mapboxcasevac(
                                                                                          //startposition:startposition ,
                                                                                          posisi: currentPostion,
                                                                                          endposisi: LatLng(double.parse(dr.latitude), double.parse(dr.longitude)),
                                                                                        )));
                                                                          },
                                                                          child: Icon(
                                                                              Icons.location_on,
                                                                              size: 30),
                                                                        ),
                                                                      ],
                                                                    )
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
          //bank akhir
          Center(
              child: Container(
            height: MediaQuery.of(context).size.height / 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                         InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Viewenviroment()));
                          },
                          child: Container(child: Icon(Icons.map_rounded,size:50,color:Colors.orange),)),
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
                            controller: controllerenviroment,
                            onChanged: _onsearchenviroment,
                            autofocus: true,
                            decoration: InputDecoration(
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                hintText: "Cari",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.clear();
                                    _onsearchenviroment('');
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
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: loadingdokter
                                ? Center()
                                : Container(
                                    child:
                                        _searchenviroment.length != 0 ||
                                                controllerenviroment
                                                    .text.isNotEmpty
                                            ? ListView.builder(
                                                itemCount:
                                                    _searchenviroment.length,
                                                itemBuilder: (context, i) {
                                                  final dt =
                                                      _searchenviroment[i];

                                                  return InkWell(
                                                    onTap: () {},
                                                    child: Padding(
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
                                                                          9.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                              width: MediaQuery.of(context).size.width / 4,
                                                                              height: MediaQuery.of(context).size.height / 8,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: dt.foto == null ? AssetImage('assets/planet-earth.png') : NetworkImage('http://202.43.164.229/amartamedia/public/public/upload/slider/' + dt.foto)))),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    "Judul",
                                                                                    style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(dt.pesan == null ? "-" : dt.pesan,
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontFamily: 'Kali',
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(
                                                                                "Keterangan",
                                                                                style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                              ),
                                                                              Text(dt.keterangan == null ? "-" : dt.keterangan,
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontFamily: 'Kali',
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () => Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Mapboxcasevac(
                                                                                          //startposition:startposition ,
                                                                                          posisi: currentPostion,
                                                                                          endposisi: LatLng(double.parse(dt.latitude), double.parse(dt.longitude)),
                                                                                        ))),
                                                                            child:
                                                                                Icon(Icons.location_on, size: 30),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : ListView.builder(
                                                itemCount:
                                                    _listenviroment.length,
                                                itemBuilder: (context, i) {
                                                  final dr = _listenviroment[i];

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
                                                                          BorderRadius.all(
                                                                              Radius.circular(
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
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            width: MediaQuery.of(context).size.width /
                                                                                4,
                                                                            height: MediaQuery.of(context).size.height /
                                                                                8,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), image: DecorationImage(fit: BoxFit.cover, image: dr.foto == null ? AssetImage('assets/planet-earth.png') : NetworkImage('http://202.43.164.229/amartamedia/public/public/upload/slider/' + dr.foto)))),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "Judul",
                                                                                  style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(dr.pesan == null ? "-" : dr.pesan,
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontFamily: 'Kali',
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text(
                                                                              "Keterangan",
                                                                              style: TextStyle(fontFamily: 'Kali', fontSize: 15),
                                                                            ),
                                                                            Text(dr.keterangan == null ? "-" : dr.keterangan,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontFamily: 'Kali',
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            print(dr.latitude);
                                                                            print(dr.longitude);

                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Mapboxcasevac(
                                                                                          //startposition:startposition ,
                                                                                          posisi: currentPostion,
                                                                                          endposisi: LatLng(double.parse(dr.latitude), double.parse(dr.longitude)),
                                                                                        )));
                                                                          },
                                                                          child: Icon(
                                                                              Icons.location_on,
                                                                              size: 30),
                                                                        ),
                                                                      ],
                                                                    )
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ]),
      ),
    );
  }
}
