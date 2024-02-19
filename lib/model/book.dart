class Book {
  int? id;
  String name;
  DateTime createdTime;

  Book(this.name, this.createdTime);
  Book.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        createdTime = DateTime.fromMillisecondsSinceEpoch(map["createdTime"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdTime': createdTime.millisecondsSinceEpoch,
    };
  }
}
