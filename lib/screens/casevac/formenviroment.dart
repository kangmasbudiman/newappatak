import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/casevac/uploadimage.dart';
import 'package:google_map_live/screens/casevac/viewcasevac.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/screens/imagelokasi/uploadimage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Formenviroment extends StatefulWidget {
  const Formenviroment({Key key}) : super(key: key);

  @override
  State<Formenviroment> createState() => _FormenviromentState();
}

class _FormenviromentState extends State<Formenviroment> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  LatLng currentPostion;
  Location _location = Location();
  Set<Marker> _markers = Set();

  Completer<GoogleMapController> _controller = Completer();
  void getLocation() async {
    setState(() {
      _isLoading = false;
    });

    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      lat = _locationResult.latitude.toString();
      long = _locationResult.longitude.toString();
      _isLoading = false;
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";
  String idgroup1 = "";
  String idgroup = "";
  String lat = "";
  String long = "";
  TextEditingController namaform = new TextEditingController();
  TextEditingController lokasi = new TextEditingController();
  TextEditingController jenispasien = new TextEditingController();
  TextEditingController levelurgency = new TextEditingController();
  TextEditingController tools = new TextEditingController();
  TextEditingController keadaanlokasi = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

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
    });
  }

  bool value = false;

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
                  'Berhasil Tersimpan',
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Viewcasevac()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pesangagal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Gagal Disimpan',
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

  bool loading = false;
  simpanvidiolokasi() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.casevac), body: {
      "iduser": idku,
      "pesan": namaform.text,
      "lokasi": lokasi.text,
      "jenispasien": jenispasien.text,
      "levelurgency": levelurgency.text,
      "tools": tools.text,
      "keadaanlokasi": keadaanlokasi.text,
      "keterangan": keterangan.text,
      "status": "1",
      "latitude": lat,
      "longitude": long,
      "idgroup": idgroup1,
      "kategori": 2.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesan();
      setState(() {
        loading = false;
        namaform.text = "";
        lokasi.text = "";
        jenispasien.text = "";
        levelurgency.text = "";
        tools.text = "";
        keadaanlokasi.text = "";
        keterangan.text = "";
      });
      namaform.text = '';
    } else {
      print("Data gagal");
    }
  }

  //pick image
  var vidiourl;
  void pickvidio() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        vidiourl = file.path;
      });
      print(vidiourl);
    } else {
      // User canceled the picker
    }
  }

  save() async {
    setState(() {
      loading = true;
    });

    final uri = Uri.parse(RestApi.casevac);
    var request = http.MultipartRequest("POST", uri);
    request.fields['iduser'] = idku;
    request.fields['pesan'] = namaform.text;
    request.fields['lokasi'] = lokasi.text;
    request.fields['jenispasien'] = jenispasien.text;
    request.fields['levelurgency'] = levelurgency.text;
    request.fields['tools'] = tools.text;
    request.fields['keadaanlokasi'] = keadaanlokasi.text;
    request.fields['keterangan'] = keterangan.text;
    request.fields['status'] = "1";
    request.fields['latitude'] = lat;
    request.fields['longitude'] = long;
    request.fields['idgroup'] = idgroup1;
    request.fields['kategori'] = 4.toString();

    var uploadvidio = await http.MultipartFile.fromPath("image", vidiourl);

    request.files.add(uploadvidio);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("upload berhasil");
      pesan();
      setState(() {
        loading = false;
        vidiourl = "Pilih Gambar";
      });
    } else {
      pesan();
    }
  }

  openCamera() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
      );
      if (pickedImage != null) {
        setState(() {
          vidiourl = pickedImage.path;
        });
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  opengalery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
      );
      if (pickedImage != null) {
        setState(() {
          vidiourl = pickedImage.path;
        });
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Form Enviroment"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: ListView(
                    children: [
                      Container(
                        height: 1,
                        width: 1,
                        child: Column(
                          children: [
                            //akan di hlangkan
                            /*
                            Container(
                              height: 60,
                              width: 160,
                              child: TextField(
                                cursorHeight: 10,
                                controller: lokasi,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  filled: true,
                                  fillColor: Colors.blue.shade100,
                                  border: OutlineInputBorder(),
                                  labelText: 'Lokasi',
                                  labelStyle: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                  hintText: 'Lokasi Kejadian',
                                  hintStyle: TextStyle(
                                      fontSize: 12.0, color: Colors.redAccent),
                                  suffixIcon: Icon(Icons.edit),
                                ),
                              ),
                            ),
                            */
                            /*
                            Container(
                              height: 60,
                              width: 160,
                              child: TextField(
                                cursorHeight: 15,
                                controller: jenispasien,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  filled: true,
                                  fillColor: Colors.blue.shade100,
                                  border: OutlineInputBorder(),
                                  labelText: 'Jenis Pasien',
                                  labelStyle: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                  hintText:
                                      'Jenis Pasien Rawat Jalan/ Rawat Inap',
                                  hintStyle: TextStyle(
                                      fontSize: 12.0, color: Colors.redAccent),
                                  suffixIcon: Icon(Icons.edit),
                                ),
                              ),
                            ),
                            */
                          ],
                        ),
                      ),
                      //hilangkan

                      //container gambar

                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.black),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  scale: 4,
                                  image: AssetImage(
                                    'assets/planet-earth.png',
                                  ),
                                  fit: BoxFit.none)),
                        ),
                        height: 130,
                        width: 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          cursorHeight: 15,
                          controller: namaform,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 5, left: 5, bottom: 5),
                            filled: true,
                            fillColor: Colors.blue.shade100,
                            border: OutlineInputBorder(),
                            labelText: 'Judul',
                            labelStyle:
                                TextStyle(fontSize: 12.0, color: Colors.black),
                            hintText: 'Judul',
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: Colors.redAccent),
                            suffixIcon: Icon(Icons.edit),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Container(
                        height: 150,
                        color: Colors.amber,
                        width: double.infinity,
                        child: TextField(
                          maxLines: 10,
                          cursorHeight: 15,
                          controller: keterangan,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 5, left: 5, bottom: 5),
                            filled: true,
                            fillColor: Colors.blue.shade100,
                            border: OutlineInputBorder(),
                            labelText: 'Keterangan',
                            labelStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                            hintText: 'Keterangan Lain',
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: Colors.redAccent),
                            suffixIcon: Icon(Icons.edit),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // pickvidio();
                                openCamera();
                              },
                              child: Text("Camera")),
                          ElevatedButton(
                              onPressed: () {
                                // pickvidio();
                                opengalery();
                              },
                              child: Text("Galery")),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: Text(vidiourl != null
                              ? vidiourl
                              : "Silahkan Pilih Gambar")),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 1,
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: InkWell(
                          onTap: () {
                            if (vidiourl == null) {
                              simpanvidiolokasi();
                            } else {
                              save();
                            }
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height / 15,
                              width: MediaQuery.of(context).size.width / 1,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                  child: Text("Simpan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white)))),
                        )),
                )
              ],
            ),
    );
  }
}
