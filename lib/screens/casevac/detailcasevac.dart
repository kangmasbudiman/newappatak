import 'package:flutter/material.dart';

class Detailcasevac extends StatefulWidget {
  final String namalengkap;
  final String lat;
  final String long;
  final String pesan;
  final String lokasi;
  final String jenispasien;
  final String levelurgency;
  final String tools;
  final String keadaanlokasi;
  final String keterangan;
  final String tgl;
  final String foto;
  const Detailcasevac({
    Key key,
    this.jenispasien,
    this.keadaanlokasi,
    this.keterangan,
    this.lat,
    this.levelurgency,
    this.lokasi,
    this.long,
    this.namalengkap,
    this.pesan,
    this.tgl,
    this.tools,
    this.foto,
  }) : super(key: key);

  @override
  State<Detailcasevac> createState() => _DetailcasevacState();
}

class _DetailcasevacState extends State<Detailcasevac> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Detail Casevac"),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/atak_splash_blank.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Nama :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.namalengkap,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Nama Form:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.pesan,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("_____________________"),
                    Text(
                      "Lokasi:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.lokasi,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("_____________________"),
                    Text(
                      "Jenis Pasien:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.jenispasien,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("_____________________"),
                    Text(
                      "Level Urgency:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.levelurgency,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("_____________________"),
                    Text(
                      "Tools:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.tools,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("_____________________"),
                    Text(
                      "Lokasi Penjemputan/Keadaan Lokasi:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.keadaanlokasi,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("_____________________"),
                    Text(
                      "Keterangan:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.keterangan,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1,
                      child: Image(
                          fit: BoxFit.cover,
                          image: widget.foto == null
                              ? Center(
                                  child: Text("Tidak Ada Foto"),
                                )
                              : NetworkImage(
                                  'http://202.43.164.229/amartamedia/public/public/upload/slider/' +
                                      widget.foto)),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: Colors.white),
                  color: Colors.white.withOpacity(0.5)),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1),
        ),
      ),
    );
  }
}
