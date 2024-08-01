class Users{
  int? id;
  String? fullName;
  String? password;
  String? phoneNumber;
  String? email;
  String? address;
  String? image;
  String? filename;
  String? roleId;


  Users.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    fullName = json["fullName"];
    password= json["password"];
    phoneNumber = json["phoneNumber"];
    email = json["email"];
    address = json["address"];
    image = json["image"];
    filename = json["filename"];
    roleId = json["roleId"];
  }

}