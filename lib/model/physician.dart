class Physician {

  int id;
  String username;

  Physician({
    this.id = 0,
    this.username = "",
  });

  factory Physician.fromJson(Map<String, dynamic> json) => Physician(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}