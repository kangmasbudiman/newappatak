class Listgoto {
  final int id;
 
  final String pesan;
  final String nama_lengkap;
  final String latitude;
  final String longitude;
  final String no_wa;

  final String keterangan;


  Listgoto({this.id,this.keterangan,this.latitude,this.longitude,this.nama_lengkap,this.no_wa,this.pesan});

  factory Listgoto.fromJson(Map<String, dynamic> json) {
    return new Listgoto(
      id: json['id'],
      pesan: json['pesan'],
      nama_lengkap:json['nama_lengkap'],
      latitude:json['latitude'],
      longitude:json['longitude'],
      no_wa:json['no_wa'],
   
      keterangan:json['keterangan'],
      
    );
  }
}
