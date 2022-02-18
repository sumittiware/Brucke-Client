class Company {
  String id;
  String name;
  String imageUrl;

  Company({this.id, this.name, this.imageUrl});

  static formJSON(String id, Map<String, dynamic> map) {
    Company company =
        Company(id: id, name: map["name"], imageUrl: map["imageUrl"]);
    return company;
  }
}
