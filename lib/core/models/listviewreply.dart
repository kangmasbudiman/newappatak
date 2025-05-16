class Listviewreply {
  final int id;
  final String idcasevac;
  final String nama;
  final String reply;
  final String created_at;

  Listviewreply({this.id,this.idcasevac,this.nama, this.reply, this.created_at});

  factory Listviewreply.fromJson(Map<String, dynamic> json) {
    return new Listviewreply(
      id: json['id'],
      nama: json['nama'],
      reply:json['reply'],
      created_at: json['created_at'],
    );
  }
}
