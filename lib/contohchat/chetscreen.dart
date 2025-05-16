import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/contohchat/firebasehelp.dart';
import 'package:google_map_live/contohchat/tammpilpesan.dart';
import 'package:google_map_live/screens/tampilimagechat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Chetscreen extends StatefulWidget {
  final String id;
  final String nama;

  const Chetscreen({Key key, this.id, this.nama}) : super(key: key);

  @override
  State<Chetscreen> createState() => _ChetscreenState();
}

class _ChetscreenState extends State<Chetscreen> {
  Service service = Service();
  var loginUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  final storeMessage = FirebaseFirestore.instance;
  TextEditingController message = new TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;

    if (user != null) {
      loginUser = user;
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

  var formatedTanggal =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  DateTime tanggal;
  var tanggalhariini = DateTime.now();

  String url = "";

  File imageFile;
  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);

        uploadimage();
        //   pesan();
      }
    });
  }

  bool loading = false;

  Future uploadimage() async {
    setState(() {
      loading = true;
    });

    String filename = Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$filename.jpg");
    var uploadTask = await ref.putFile(imageFile);

    String imageUrl = await uploadTask.ref.getDownloadURL();

    setState(() {
      url = imageUrl;
      loading = false;
      print("selesai loading");
    });
    print(imageUrl);
  }

  Future<void> pesan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Text(
                'Upload Data',
                textAlign: TextAlign.center,
              ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

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
              widget.nama,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (loading == true)
            Positioned(
              top: 200.0,
              child: Container(
                height: 70,
                width: 200,
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Loading',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/atak_splash_blank.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height * 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        reverse: true,
                        child: Container(
                            height: MediaQuery.of(context).size.height / 1.2,
                            child: tampilpesan(widget.id)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                    child: TextField(
                                        controller: message,
                                        decoration: InputDecoration(
                                          hintText: "Tulis Pesan",
                                          hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ))),
                              ),
                            ),
                            loading
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CircularProgressIndicator(),
                                  )
                                : Row(
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
                                            storeMessage
                                                .collection('pesanku')
                                                .doc()
                                                .set({
                                              "msg": message.text.trim(),
                                              "userid": idku,
                                              "pengirim": nama_lengkap1,
                                              "time": DateTime.now(),
                                              "penerima": widget.id,
                                              'foto': url,
                                            });

                                            message.clear();

                                            setState(() {
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  tampilpesan(String id) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pesanku')
          .orderBy("time", descending: true)
          .where("penerima", isEqualTo: "${id}")
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

            Timestamp time = x['time'];
            DateTime now = time.toDate();
            String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

            return x['foto'] != ""
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Tampilimage(
                                      url: x['foto'],
                                    )));
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        x['foto'],
                                      )),
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))),
                              height: 160,
                              width: 200,
                            ),
                            Container(
                              //width: 260,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
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
                      crossAxisAlignment: idku == x['userid']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: idku == x['userid']
                                    ? Colors.white.withOpacity(0.4)
                                    : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    x['msg'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }

  
}

class Tampilpesan extends StatelessWidget {
  const Tampilpesan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {}
}
