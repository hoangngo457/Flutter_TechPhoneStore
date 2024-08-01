class Address {
  int? id;
  String? name;
  String? city;
  String? district;
  String? ward;
  String? phoneNumber;
  String? detailAdr;
  int? idUser;

  Address({
    this.id,
    this.name,
    this.city,
    this.district,
    this.ward,
    this.phoneNumber,
    this.detailAdr,
    this.idUser,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      district: json['district'],
      ward: json['ward'],
      phoneNumber: json['phone_num'],
      detailAdr: json['detail_Adr'],
      idUser: json['idUser'],
    );
  }
}
