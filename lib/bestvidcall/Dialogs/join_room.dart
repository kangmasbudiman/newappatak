import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_live/bestvidcall/Helpers/utiLs.dart';
import 'package:google_map_live/bestvidcall/videocall_page.dart';

class JoinRoomDialog extends StatefulWidget {
  @override
  _JoinRoomDialogState createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final TextEditingController roomTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Join Room"),
      content: Container(
        height: 300,
        width: 200,
        child: ListView(
          //  shrinkWrap: true,
          children: [
            Image.asset(
              'assets/room_join_vector.png',
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: roomTxtController,
              decoration: InputDecoration(
                  hintText: "Enter room id to join",
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: const Color(0xFF1A1E78), width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF1A1E78), width: 2))),
            ),
            const SizedBox(
              height: 20,
            ),
            FlatButton(
              color: const Color(0xFF1A1E78),
              onPressed: () async {
                if (roomTxtController.text.isNotEmpty) {
                  bool isPermissionGranted =
                      await handlePermissionsForCall(context);
                  if (isPermissionGranted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoCallScreen(
                                  channelName: roomTxtController.text,
                                )));
                  } else {
                    Get.snackbar("Failed", "Enter Room-Id to Join.",
                        backgroundColor: Colors.white,
                        colorText: Color(0xFF1A1E78),
                        snackPosition: SnackPosition.BOTTOM);
                  }
                } else {
                  Get.snackbar("Failed",
                      "Microphone Permission Required for Video Call.",
                      backgroundColor: Colors.white,
                      colorText: Color(0xFF1A1E78),
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.white),
                  const SizedBox(
                    width: 20,
                  ),
                  Text("Join Room", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
