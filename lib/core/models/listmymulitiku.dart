class Listmymulticycari {
  final int id;
 
  final String name;
  final String totaldistance;
  

  Listmymulticycari({this.id,this.name,this.totaldistance});

  factory Listmymulticycari.fromJson(Map<String, dynamic> json) {
    return new Listmymulticycari(
      id: json['id'],
      name: json['name'],
      totaldistance:json['totaldistance'],
      
    );
  }
}
