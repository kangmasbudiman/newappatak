import 'package:flutter/material.dart';

class Tampilimage extends StatefulWidget {
  final String url;
  const Tampilimage({Key key, this.url}) : super(key: key);

  @override
  State<Tampilimage> createState() => _TampilimageState();
}

class _TampilimageState extends State<Tampilimage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain, image: NetworkImage(widget.url))),
      ),
    );
  }
}
