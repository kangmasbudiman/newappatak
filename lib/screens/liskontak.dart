import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_map_live/screens/japri.dart';

class Liskontak extends StatefulWidget {
  const Liskontak({Key key}) : super(key: key);

  @override
  State<Liskontak> createState() => _LiskontakState();
}

class _LiskontakState extends State<Liskontak> {
  Stream<QuerySnapshot<Map<String, dynamic>>> collectionstream =
      FirebaseFirestore.instance
          .collection('location')
          .where('online', isEqualTo: 1)
          .snapshots();


 @override
  void initState() {
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
      body: collectionstream == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: collectionstream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(snapshot.data.docs[index]['userid']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chetscreen(
                                      id: snapshot.data.docs[index]['userid'],
                                      nama: snapshot.data.docs[index]['name'],
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            subtitle:
                                Text(snapshot.data.docs[index].data()['no_wa']),
                            title: Text(
                              snapshot.data.docs[index].data()['name'],
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            trailing: Icon(Icons.person),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
