import 'package:equatable/equatable.dart';

import '../../../screens_data/constants.dart';

class PayKeyPermission implements Equatable {
  bool plus;
  bool plusPer;
  bool minus;
  bool minusPer;
  bool visa1;
  bool visa2;
  bool ch;
  bool chk;
  bool rc;
  bool pd;

  PayKeyPermission({
    this.plus = false,
    this.plusPer = false,
    this.minus = false,
    this.minusPer = false,
    this.visa1 = false,
    this.visa2 = false,
    this.ch = false,
    this.chk = false,
    this.rc = false,
    this.pd = false,
  });
  static PayKeyPermission initializeMap(List<String> map) {
    return PayKeyPermission(
      plus: map.contains("plus"),
      plusPer: map.contains("plus_per"),
      minus: map.contains("minus"),
      minusPer: map.contains("minus_per"),
      visa1: map.contains("visa1"),
      visa2: map.contains("visa2"),
      ch: map.contains("ch"),
      chk: map.contains("chk"),
      rc: map.contains("rc"),
      pd: map.contains("pd"),
    );
  }

  List<int> getPermissions() {
    List<int> permissions = [];
    if (plus) {
      permissions.add(permissionsData.indexOf("plus"));
    }
    if (plusPer) {
      permissions.add(permissionsData.indexOf("plus_per"));
    }
    if (minus) {
      permissions.add(permissionsData.indexOf("minus"));
    }
    if (minusPer) {
      permissions.add(permissionsData.indexOf("minus_per"));
    }
    if (visa1) {
      permissions.add(permissionsData.indexOf("visa1"));
    }
    if (visa2) {
      permissions.add(permissionsData.indexOf("visa2"));
    }
    if (ch) {
      permissions.add(permissionsData.indexOf("ch"));
    }
    if (chk) {
      permissions.add(permissionsData.indexOf("chk"));
    }
    if (rc) {
      permissions.add(permissionsData.indexOf("rc"));
    }
    if (pd) {
      permissions.add(permissionsData.indexOf("pd"));
    }

    return permissions;
  }

  void tickAllTrue() {
    plus = true;
    plusPer = true;
    minus = true;
    minusPer = true;
    visa1 = true;
    visa2 = true;
    ch = true;
    chk = true;
    rc = true;
    pd = true;
  }

  void tickAllFalse() {
    plus = false;
    plusPer = false;
    minus = false;
    minusPer = false;
    visa1 = false;
    visa2 = false;
    ch = false;
    chk = false;
    rc = false;
    pd = false;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [plus,plusPer,minus,minusPer,visa1,visa2,ch,chk,rc,pd];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
