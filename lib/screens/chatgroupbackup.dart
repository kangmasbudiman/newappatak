import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/itemcard.dart';
import 'package:google_map_live/screens/tampilimagechat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Chatgroup extends StatefulWidget {
  final idgroup;
  const Chatgroup({Key key, this.idgroup}) : super(key: key);

  @override
  State<Chatgroup> createState() => _ChatgroupState();
}

class _ChatgroupState extends State<Chatgroup> {
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

  String email = "";
  String email1 = "";
  String jabatan = "";
  String jabatan1 = "";

  TextEditingController _pesancontroller = new TextEditingController();
  Future<String> getProfiles() async {
    print("ini dia");
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
      jabatan1 = jabatan;
    });
    print("ini idgroup ku dari chat group");
    print(idgroup1);
    tampilpesan(idgroup1);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference isipesan =
      FirebaseFirestore.instance.collection('pesangroup');
  String pengirim = "";

  Stream<QuerySnapshot<Map<String, dynamic>>> pesan = FirebaseFirestore.instance
      .collection('pesangroup')
      .orderBy("tanggal")
      .limit(1000)
      .snapshots();

  static var today = new DateTime.now();
  var formatedTanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime tanggal;
  var tanggalhariini = DateTime.now();
  int _status = 1;
  String url = "";

  File imageFile;
  Future getImage() async {
    setState(() {
      _status = 0;
    });
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);

        uploadimage();
      }
    });
  }

  Future uploadimage() async {
    String filename = Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$filename.jpg");
    var uploadTask = await ref.putFile(imageFile);

    String imageUrl = await uploadTask.ref.getDownloadURL();

    setState(() {
      url = imageUrl;
    });
  }

  tampilpesan(String idgroup) async {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pesanku')
          .orderBy("time", descending: true)
          .where("penerima", isEqualTo: "${idgroup}")
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data.docs[i];

              return Container(
                child: Text(x['namapengirim']),
              );
            });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();

    SystemChrome.setPreferredOrientations([
      //  DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      //  DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  image: DecorationImage(
                      image: AssetImage('assets/logoatak.png'),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  shape: BoxShape.circle),
            ),
            SizedBox(width: 5),
            Text(
              "Chat Group",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/atak_splash_blank.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height * 1,
        child: ListView(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: StreamBuilder(
                      stream: pesan,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Container(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              Timestamp time =
                                  snapshot.data.docs[index].data()['tanggal'];
                              DateTime now = time.toDate();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd – kk:mm').format(now);

                              return snapshot.data.docs[index].data()['foto'] !=
                                      ""
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Tampilimage(
                                                        url: snapshot
                                                            .data.docs[index]
                                                            .data()['foto'],
                                                      )));
                                        },
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()['foto'],
                                                        )),
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
                                                height: 160,
                                              ),
                                              Container(
                                                //width: 260,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "Pengirim :",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          snapshot.data
                                                                  .docs[index]
                                                                  .data()[
                                                              "namapengirim"],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      formattedDate,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListTile(
                                      title: Column(
                                        crossAxisAlignment: idku ==
                                                snapshot.data.docs[index]
                                                    .data()['userid']
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: idku ==
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()['userid']
                                                      ? Colors.white
                                                          .withOpacity(0.4)
                                                      : Colors.white
                                                          .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          .data()["pesan"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                    Container(
                                                      width: 260,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                "Pengirim :",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                snapshot.data
                                                                        .docs[index]
                                                                        .data()[
                                                                    "namapengirim"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            formattedDate,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.white.withOpacity(0.4),
                      border: Border.all(width: 2, color: Colors.white)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            child: TextField(
                              controller: _pesancontroller,
                              decoration: InputDecoration(
                                hintText: "Tulis ",
                                hintStyle: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {
                                isipesan.add({
                                  'pesan': _pesancontroller.text,
                                  'namapengirim': nama_lengkap1,
                                  'userid': idku,
                                  'foto': url,
                                  'kodegroup': idgroup1,
                                  'tanggal': DateTime.now(),
                                });

                                setState(() {
                                  _pesancontroller.text = '';
                                  url = "";
                                });
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
