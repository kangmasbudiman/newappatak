//import 'package:chat_app/UI/Dialogs/create_room.dart';
//import 'package:chat_app/UI/Dialogs/join_room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_live/bestvidcall/Dialogs/create_room.dart';
import 'package:google_map_live/bestvidcall/Dialogs/join_room.dart';
import 'package:google_map_live/bestvidcall/Helpers/utiLs.dart';
import 'package:google_map_live/bestvidcall/videocall_page.dart';
//import 'package:chat_app/Helpers/text_styles.dart';
//import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E78),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60, left: 30),
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ATAK Vidio Call App",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Tersambung dengan temanmu lewat vidio call",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                top: 30,
              ),
              padding: const EdgeInsets.only(
                top: 30,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Center(
                  child: Column(
                children: [
/*
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return CreateRoomDialog();
                              });
                        },
                        child: Row(
                          children: [
                            Flexible(
                                flex: 7,
                                child: Image.asset(
                                  "assets/create_meeting_vector.png",
                                  fit: BoxFit.fill,
                                )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Buat Room",
                                  ),
                                  Text(
                                    "buat ruang ATAK Vidio Call yang unik dan minta orang lain untuk bergabung dengan yang sama.",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        margin: const EdgeInsets.all(20),
                        color: const Color(0xFF1A1E78)),
                  ),
*/
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FlatButton(
                        onPressed: () async {
                          bool isPermissionGranted =
                              await handlePermissionsForCall(context);
                          if (isPermissionGranted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoCallScreen(
                                          channelName: "atakroom",
                                        )));
                          }

/*
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return JoinRoomDialog();
                              });
*/
                        },
                        child: Row(
                          children: [
                            Flexible(
                                flex: 6,
                                child: Image.asset(
                                  "assets/join_meeting_vector.png",
                                  fit: BoxFit.fill,
                                )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Bergabung ke ruang",
                                  ),
                                  Text(
                                    "Bergabunglah dengan ruang ATAK Video Call yang dibuat oleh teman Anda.",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
