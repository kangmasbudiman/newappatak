class Listviewredbeiring {
  final int id;
  final String idgroup;
  final String nama;
  final String distance;
  

  Listviewredbeiring({this.id,this.idgroup,this.nama, this.distance});

  factory Listviewredbeiring.fromJson(Map<String, dynamic> json) {
    return new Listviewredbeiring(
      id: json['id'],
      nama: json['nama'],
      distance:json['distance'],
     
    );
  }
}
