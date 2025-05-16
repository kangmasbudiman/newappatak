import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/res/custom_colors.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/botomnavy.dart';
import 'package:google_map_live/signin4.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfil extends StatefulWidget {
  final String email;
  final String name;
  final String nowa;
  final String id;

  const EditProfil({Key key, this.email, this.id, this.name, this.nowa})
      : super(key: key);

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _underlineColor = Color(0xFFCCCCCC);
  Color _mainColor = Color(0xFF07ac12);
  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xff777777);
  Color _color3 = Color(0xFFaaaaaa);

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController nowa = new TextEditingController();
  TextEditingController kode_ref = new TextEditingController();

  registrasi() async {
    print(email.text);
    print(password.text);

    final response = await http.post(Uri.parse(RestApi.register), body: {
      "email": email.text,
      "nama_lengkap": name.text,
      "no_wa": nowa.text,
      "password": password.text,
      "kode_ref": kode_ref.text,
    });

    final data = jsonDecode(response.body);
    print(data);

    String value = data['value'];

    if (value == "1") {
      _pesanlogin();
    } else if (value == 5) {
      // _pesanterhubung();
    } else {
      // _pesangagallogin();
    }
  }

  Future<void> _pesanlogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Registratrion Success',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Signin4Page()));
              },
            ),
          ],
        );
      },
    );
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
  save() async {
    setState(() {
      loading = true;
    });

    final response = await http.post(Uri.parse(RestApi.updateprofil), body: {
      "id": widget.id,
      "name": name.text,
      "email": email.text,
      "nowa": nowa.text
    });

    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (response.statusCode == 200) {
      print("upload berhasil");
      setState(() {
        loading = false;
      });
      info();
    } else {
      print("upload tidak berhasil");
    }
  }

  keluar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove('id');
      preferences.remove('nama_lengkap');
      preferences.remove('no_wa');
      preferences.remove('idgroup');
      preferences.commit();
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Signin4Page()));
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
                  'Update Profil Berhasil',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                keluar();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _requestpermision();
    name.text = widget.name;
    email.text = widget.email;
    nowa.text = widget.nowa;

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
        backgroundColor: CustomColors.firebaseNavy,
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/atak_splash_blank.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //  Center(child: Im  age.asset('assets/867087.png', height: 130)),
                      SizedBox(height: 25),
                      Text('Edit Profil',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent.shade700)),
                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: name,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _mainColor, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _underlineColor),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: nowa,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _mainColor, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _underlineColor),
                          ),
                          labelText: 'No WhatsApp',
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _mainColor, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _underlineColor),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 20,
                      ),

//awal mula foto profil
/*
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            pickvidio();
                          },
                          child: Text("Pilih Gambar")),

                      SizedBox(
                        height: 15,
                      ),
                      Text(vidiourl != null ? vidiourl : "Select",
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.yellow)),
                      //akhirupload ptoto profil
*/
                      SizedBox(
                        height: 25,
                      ),
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) =>
                                  Colors.tealAccent.shade700,
                            ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            )),
                          ),
                          onPressed: () {
                            save();
                            //registrasi();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'Simpan',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )),

                      /*
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: 'Click signup', toastLength: Toast.LENGTH_SHORT);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  */
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _requestpermision() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("OK");
    } else if (status.isDenied) {
      _requestpermision();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
