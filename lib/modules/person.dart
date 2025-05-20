import 'package:equatable/equatable.dart';

class Person implements Equatable {
  int id;
  double inBalance;
  double outBalance;
  double balance;
  String barcode;
  String arName;
  String enName;
  String tel;
  String whatsNum;
  String email;

  Person(this.id, this.inBalance, this.outBalance, this.balance, this.barcode,
      this.arName, this.enName, this.tel, this.whatsNum, this.email);

  static Person emptyInstance() {
    return Person(-1, 0, 0, 0, "", "", "", "", "", "");
  }

  static Person instanceFromMap(Map item) {
    return Person(
        item["id"],
        item["In"],
        item["Out"],
        item["Balance"],
        item["Barcode"],
        item["Name_Arabic"],
        item["Name_English"],
        item["Tel"],
        item["Whatsapp"],
        item["Email"]);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [arName, enName, barcode, tel, whatsNum, email, id];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
