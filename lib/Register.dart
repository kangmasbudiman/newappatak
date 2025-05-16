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

const List<String> _list = <String>['Leader', 'Sales', 'Admin'];

class Registeruser extends StatefulWidget {
  @override
  _RegisteruserState createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
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
  TextEditingController nip = new TextEditingController();
  String kodejabatan = "";
  String dropdownValue = _list.first;

  savePref(
    int value,
    id,
    String nama_lengkap,
    emel,
    no_wa,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setInt('id', id);
      preferences.setString('nama_lengkap', nama_lengkap);
      preferences.setString('email', emel);
      preferences.setString('no_wa', no_wa);
      preferences.commit();
    });
  }

  registrasi() async {
    print(email.text);
    print(password.text);

    final response = await http.post(Uri.parse(RestApi.register), body: {
      "email": email.text,
      "nama_lengkap": name.text,
      "no_wa": nowa.text,
      "password": password.text,
      "kode_ref": kode_ref.text,
      "nip": nip.text,
      "jabatan": kodejabatan,
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

    final uri = Uri.parse(RestApi.register);
    var request = http.MultipartRequest("POST", uri);

    request.fields['email'] = email.text;
    request.fields['nama_lengkap'] = name.text;
    request.fields['no_wa'] = nowa.text;
    request.fields['password'] = password.text;
    request.fields['kode_ref'] = kode_ref.text;
    request.fields['nip'] = nip.text;
    request.fields['jabatan'] = kodejabatan;
    var uploadvidio = await http.MultipartFile.fromPath("foto", vidiourl);

    request.files.add(uploadvidio);
    var response = await request.send();

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
                  'Registrasi Berhasil',
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
                    MaterialPageRoute(builder: (context) => Signin4Page()));
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
                      Text('Daftar Akun Baru',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent.shade700)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.red[500],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                                image: AssetImage('assets/avatar.png'))),
                      ),
                      TextFormField(
                        controller: nip,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _mainColor, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _underlineColor),
                          ),
                          labelText: 'NIP',
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                      TextField(
                        controller: password,
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.tealAccent.shade400,
                                  width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _underlineColor),
                          ),
                          labelText: 'Password',
                          // labelStyle: TextStyle(color: _color2),
                          labelStyle: TextStyle(color: Colors.amber),
                          suffixIcon: IconButton(
                              icon: Icon(_iconVisible,
                                  color: Colors.grey[400], size: 20),
                              onPressed: () {
                                _toggleObscureText();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Jabatan",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 16)),
                          DropdownButton(
                            dropdownColor: Colors.amber,
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 20,
                            style: const TextStyle(color: Colors.white),
                            underline: Container(
                              height: 2,
                              color: Colors.orange,
                            ),
                            onChanged: (String value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value;
                                if (value == "Leader") {
                                  kodejabatan = "1";
                                } else if (value == "Sales") {
                                  kodejabatan = "2";
                                } else {
                                  kodejabatan = "3";
                                }
                                print(kodejabatan);
                              });
                            },
                            items: _list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: kode_ref,
                        //  obscureText: _obscureText,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.tealAccent.shade400,
                                  width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _underlineColor),
                          ),
                          labelText: 'Kode Group',
                          // labelStyle: TextStyle(color: _color2),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

//awal mula foto profil

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
                              'Daftar',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Text("Sudah Punya Akun?  ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signin4Page()));
                            },
                            child: Text("Masuk Disini.!",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent.shade700)),
                          ),
                        ],
                      )

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
