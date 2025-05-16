import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/vidio/viewvidio.dart';

import 'package:http/http.dart' as http;

class Uploadvidio extends StatefulWidget {
  final int id;
  const Uploadvidio({Key key, this.id}) : super(key: key);

  @override
  State<Uploadvidio> createState() => _UploadvidioState();
}

class _UploadvidioState extends State<Uploadvidio> {
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
                  'Upload Vidio Succes',
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
                    MaterialPageRoute(builder: (context) => Viewvidio()));
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
                  'Upload Vidio Succes',
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
                    MaterialPageRoute(builder: (context) => Viewvidio()));
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

    final uri = Uri.parse(RestApi.uploadvidio);
    var request = http.MultipartRequest("POST", uri);
    request.fields['idvidio'] = widget.id.toString();
    var uploadvidio = await http.MultipartFile.fromPath("vidio", vidiourl);

    request.files.add(uploadvidio);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("upload berhasil");
      setState(() {
        loading = false;
        info();
      });
    } else {
      print("upload tidak berhasil");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pilih vidio yang akan di upload",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 15))),
                      onPressed: () {
                        pickvidio();
                      },
                      child: Text("Upload")),
                  Text(vidiourl != null ? vidiourl : "Select"),
                  Text("Upload vidio"),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 15))),
                      onPressed: () {
                        save();
                      },
                      child: Text("save")),
                ],
              ),
            ),
    );
  }
}
