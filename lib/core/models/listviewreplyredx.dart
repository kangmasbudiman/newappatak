class Listviewreplyredx {
  final int id;
  final String idredx;
  final String nama;
  final String reply;
  final String created_at;

  Listviewreplyredx({this.id,this.idredx,this.nama, this.reply, this.created_at});

  factory Listviewreplyredx.fromJson(Map<String, dynamic> json) {
    return new Listviewreplyredx(
      id: json['id'],
      nama: json['nama'],
      reply:json['reply'],
      created_at: json['created_at'],
    );
  }
}
