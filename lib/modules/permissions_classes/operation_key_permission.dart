import 'package:equatable/equatable.dart';

import '../../../screens_data/constants.dart';

class OperationKeysPermission implements Equatable{
  bool RF;
  bool allCancel;
  bool changePrice;
  bool changeQty;
  bool data;
  bool printer;
  bool drawer;
  bool deptAccess;
  OperationKeysPermission({
    this.changeQty = false,
    this.data = false,
    this.printer = false,
    this.drawer = false,
    this.deptAccess = false,
    this.RF = false,
    this.allCancel = false,
    this.changePrice = false,
  });
  static OperationKeysPermission initializeMap(List<String> map) {
    return OperationKeysPermission(
      RF: map.contains("RF"),
      allCancel: map.contains("all_cancel"),
      changePrice: map.contains("change_price"),
      data: map.contains("data"),
      deptAccess: map.contains("dept_access"),
      drawer: map.contains("drawer"),
      changeQty: map.contains("change_qty"),
      printer: map.contains("print"),
    );
  }

  List<int> getPermissions() {
    List<int> permissions = [];

    if (RF) {
      permissions.add(permissionsData.indexOf("RF"));
    }
    if (allCancel) {
      permissions.add(permissionsData.indexOf("all_cancel"));
    }
    if (changePrice) {
      permissions.add(permissionsData.indexOf("change_price"));
    }
    if (data) {
      permissions.add(permissionsData.indexOf("data"));
    }
    if (drawer) {
      permissions.add(permissionsData.indexOf("drawer"));
    }
    if (changeQty) {
      permissions.add(permissionsData.indexOf("change_qty"));
    }
    if (printer) {
      permissions.add(permissionsData.indexOf("print"));
    }
    if (deptAccess) {
      permissions.add(permissionsData.indexOf("dept_access"));
    }

    return permissions;
  }

  void tickAllTrue() {
    changeQty = true;
    data = true;
    printer = true;
    drawer = true;
    deptAccess = true;
    RF = true;
    allCancel = true;
    changePrice = true;
  }

  void tickAllFalse() {
    changeQty = false;
    data = false;
    printer = false;
    drawer = false;
    deptAccess = false;
    RF = false;
    allCancel = false;
    changePrice = false;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [changeQty,data,printer,drawer,deptAccess,RF,allCancel,changePrice];

  @override
  // TODO: implement stringify
  bool? get stringify =>true;
}
