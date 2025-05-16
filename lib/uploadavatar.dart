import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/screens/imagelokasi/viewmarker.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Uploadavatar extends StatefulWidget {
  final String id;
  const Uploadavatar({Key key, this.id}) : super(key: key);

  @override
  State<Uploadavatar> createState() => _UploadavatarState();
}

class _UploadavatarState extends State<Uploadavatar> {
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
    });

    // ambilgambar();
  }

  var vidiourl;
  void pickvidio() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        vidiourl = file.path;
      });
      print(vidiourl);
    } else {
      // User canceled the picker
    }
  }

  bool loading = false;

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
                  'Upload Berhasil',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Viewmarker()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> infogagal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Upload Avatar Tidak Berhasil',
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
              },
            ),
          ],
        );
      },
    );
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
                  'Upload Avatar Berhasil',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),
          ],
        );
      },
    );
  }

  save() async {
    setState(() {
      loading = true;
    });
    print("ini IDKU");
    print(idku);
    final uri = Uri.parse(RestApi.uploadavatar);
    var request = http.MultipartRequest("POST", uri);
    request.fields['id'] = idku;
    var uploadvidio = await http.MultipartFile.fromPath("foto", vidiourl);

    request.files.add(uploadvidio);
    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      print("upload berhasil");
      setState(() {
        loading = false;
      });
      info();
    } else {
      infogagal();
      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("File Upload Inprogrees"),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/atak_splash_blank.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pilih File yang akan digunakan sebagai avatar",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          pickvidio();
                        },
                        child: Text("Upload")),
                    Text(vidiourl != null ? vidiourl : "Select",
                        style: TextStyle(color: Colors.yellow)),
                    Text(
                      "Upload image",
                      style: TextStyle(color: Colors.yellow),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          save();
                        },
                        child: Text("save")),
                  ],
                ),
              ),
            ),
    );
  }
}
