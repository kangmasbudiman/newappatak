class Listcasevac {
  final int id;
 
  final String pesan;
  final String nama_lengkap;
  final String latitude;
  final String longitude;
  final String no_wa;
  final String lokasi;
  final String jenispasien;
  final String levelurgency;
  final String tools;
  final String keadaanlokasi;
  final String keterangan;
  /*
  $b['nama_lengkap']=$k->nama_lengkap;
          $b['latitude']=$k->latitude;
          $b['longitude']=$k->longitude;
          $b['pesan']=$k->pesan;
          $b['no_wa']=$k->no_wa;
          $b['lokasi']=$k->lokasi;
          $b['jenispasien']=$k->jenispasien;
          $b['levelurgency']=$k->levelurgency;
          $b['tools']=$k->tools;
          $b['keadaanlokasi']=$k->keadaanlokasi;
          $b['keterangan']=$k->keterangan;
*/

  Listcasevac({this.id,this.jenispasien,this.keadaanlokasi,this.keterangan,this.latitude,this.levelurgency,this.lokasi,this.longitude,this.nama_lengkap,this.no_wa,this.pesan,this.tools});

  factory Listcasevac.fromJson(Map<String, dynamic> json) {
    return new Listcasevac(
      id: json['id'],
      pesan: json['pesan'],
      nama_lengkap:json['nama_lengkap'],
      latitude:json['latitude'],
      longitude:json['longitude'],
      no_wa:json['no_wa'],
      lokasi:json['lokasi'],
      jenispasien:json['jenispasien'],
      levelurgency:json['levelurgency'],
      tools:json['tools'],
      keadaanlokasi:json['keadaanlokasi'],
      keterangan:json['keterangan'],
      
    );
  }
}
