import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_live/newgoto/mapbox.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class Selectdestination extends StatefulWidget {
  const Selectdestination({Key key}) : super(key: key);

  @override
  State<Selectdestination> createState() => _SelectdestinationState();
}

class _SelectdestinationState extends State<Selectdestination> {
  TextEditingController startcontroller = new TextEditingController();
  TextEditingController endcontroller = new TextEditingController();
  GooglePlace _googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer _debounce;

  DetailsResult startposition;
  DetailsResult endposition;

  FocusNode startFocusNode;
  FocusNode endFocusNode;

  void autocopmplatesearchplace(String value) async {
    var result = await _googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions.first.description);
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  StreamSubscription<loc.LocationData> _locationSubscription;
  LatLng currentPostion;
  final loc.Location location = loc.Location();
  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
      //  startposition=currentPostion;
    });
  }

  Set<Marker> _markers = Set();
  Completer<GoogleMapController> _controller = Completer();
  var maptype = MapType.normal;

  Future<void> _gotoLake() async {
    final loc.LocationData _locationResult = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationResult.latitude, _locationResult.longitude),
      zoom: 16,
    )));
    setState(() {
      _markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          markerId: MarkerId('loc'),
          position:
              LatLng(_locationResult.latitude, _locationResult.longitude)));
    });
  }

  Future<void> _gotoZoomin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _gotoZoomout() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKey = "AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk";
    _googlePlace = GooglePlace(apiKey);
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
    getLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.map_outlined,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (maptype == MapType.normal) {
                  this.maptype = MapType.hybrid;
                } else {
                  this.maptype = MapType.normal;
                }
              });
            },
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.black,
            child:
                const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                    onTap: (LatLng latLng) {
                      _markers.add(
                          Marker(markerId: MarkerId('mark'), position: latLng));
                    },
                    markers: Set<Marker>.of(_markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    mapType: maptype,
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition:
                        CameraPosition(zoom: 15, target: currentPostion)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
/*
                      TextField(
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce.cancel();

                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            if (value.isNotEmpty) {
                              autocopmplatesearchplace(value);
                            } else {
                              //clear
                              setState(() {
                                predictions = [];
                                startposition = null;
                              });
                            }
                          });
                        },
                        focusNode: startFocusNode,
                        controller: startcontroller,
                        autofocus: false,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                            suffixIcon: startcontroller.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        predictions = [];
                                        startcontroller.clear();
                                      });
                                    },
                                    icon: Icon(Icons.clear_outlined))
                                : null,
                            hintText: 'Starting Point',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black), //<-- SEE HERE
                            ),
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            )),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      */
                      TextField(
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce.cancel();

                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            if (value.isNotEmpty) {
                              autocopmplatesearchplace(value);
                            } else {
                              //clear
                              setState(() {
                                predictions = [];
                                endposition = null;
                              });
                            }
                          });
                        },
                        focusNode: endFocusNode,
                        controller: endcontroller,
                        autofocus: false,
                        style: TextStyle(fontSize: 24),
                        //enabled: startcontroller.text != null &&
                        //    startposition != null,
                        decoration: InputDecoration(
                            suffixIcon: endcontroller.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        predictions = [];
                                        endcontroller.clear();
                                      });
                                    },
                                    icon: Icon(Icons.clear_outlined))
                                : null,
                            hintText: 'Tujuan',
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black), //<-- SEE HERE
                            ),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            )),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.grey[200],
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                    predictions[index].description.toString()),
                                onTap: () async {
                                  final placeId = predictions[index].placeId;
                                  final detail =
                                      await _googlePlace.details.get(placeId);
                                  if (detail != null &&
                                      detail.result != null &&
                                      mounted) {
                                    if (startFocusNode.hasFocus) {
                                      setState(() {
                                        startposition = detail.result;
                                        startcontroller.text =
                                            detail.result.name;
                                        predictions = [];
                                      });
                                    } else {
                                      setState(() {
                                        endposition = detail.result;
                                        endcontroller.text = detail.result.name;
                                        predictions = [];
                                      });
                                    }
//startposition != null &&
                                    if (endposition != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Mapbox(
                                                    //startposition:startposition ,
                                                    posisi: currentPostion,
                                                    endtposition: endposition,
                                                  )));
                                    }
                                  }
                                },
                              ),
                            );
                          })
                    ],
                  ),
                ),
                //zoom kontrol custom
                Positioned(
                  bottom: 87,
                  right: 4,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            height: 38,
                            width: 38,
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    _gotoLake();
                                  },
                                  icon: Icon(Icons.gps_fixed)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  right: 8,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          child: InkWell(
                            onTap: () async {
                              _gotoZoomin();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/zoomin.png')),
                                color: Colors.transparent,
                              ),
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  right: 10,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          child: InkWell(
                            onTap: () async {
                              _gotoZoomout();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/zoomout.png')),
                                color: Colors.transparent,
                              ),
                              height: 26,
                              width: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //endzoom custom
              ],
            ),
    );
  }
}
