import 'package:equatable/equatable.dart';

import '../../../screens_data/constants.dart';

class ReportsPermission implements Equatable {
  bool products;
  bool groups;
  bool departments;
  bool clients;
  bool suppliers;
  bool users;
  bool inventory;
  bool depts;
  bool cash;
  bool functions;

  ReportsPermission({
    this.functions = false,
    this.products = false,
    this.groups = false,
    this.departments = false,
    this.clients = false,
    this.suppliers = false,
    this.users = false,
    this.inventory = false,
    this.depts = false,
    this.cash = false,
  });

  static ReportsPermission initializeMap(List<String> map) {
    return ReportsPermission(
      functions: map.contains("functions"),
      products: map.contains("products"),
      departments: map.contains("departments"),
      groups: map.contains("groups"),
      cash: map.contains("cash"),
      clients: map.contains("clients"),
      suppliers: map.contains("suppliers"),
      inventory: map.contains("inventory"),
      depts: map.contains("dept"),
      users: map.contains("users"),
    );
  }

  List<int> getPermissions() {
    List<int> permissions = [];
    if (functions) {
      permissions.add(permissionsData.indexOf("functions"));
    }
    if (products) {
      permissions.add(permissionsData.indexOf("products"));
    }
    if (departments) {
      permissions.add(permissionsData.indexOf("departments"));
    }
    if (groups) {
      permissions.add(permissionsData.indexOf("groups"));
    }
    if (cash) {
      permissions.add(permissionsData.indexOf("cash"));
    }
    if (clients) {
      permissions.add(permissionsData.indexOf("clients"));
    }
    if (suppliers) {
      permissions.add(permissionsData.indexOf("suppliers"));
    }
    if (inventory) {
      permissions.add(permissionsData.indexOf("inventory"));
    }
    if (depts) {
      permissions.add(permissionsData.indexOf("dept"));
    }
    if (users) {
      permissions.add(permissionsData.indexOf("users"));
    }
    return permissions;
  }

  void tickAllTrue() {
    functions = true;
    products = true;
    groups = true;
    departments = true;
    clients = true;
    suppliers = true;
    users = true;
    inventory = true;
    depts = true;
    cash = true;
  }

  void tickAllFalse() {
    functions = false;
    products = false;
    groups = false;
    departments = false;
    clients = false;
    suppliers = false;
    users = false;
    inventory = false;
    depts = false;
    cash = false;
  }

  @override
  List<Object?> get props => [
        functions,
        products,
        groups,
        departments,
        clients,
        suppliers,
        users,
        inventory,
        depts,
        cash
      ];

  @override
  bool? get stringify => true;
}
