import '../../../screens_data/constants.dart';
import 'department_permission.dart';
import 'group_permission.dart';
import 'product_permission.dart';

class TotalProductPermission {
  ProductPermission product = ProductPermission();
  GroupPermission group = GroupPermission();
  DepartmentPermission department = DepartmentPermission();
  bool inProduct;
  bool outProduct;
  TotalProductPermission({
    ProductPermission? product,
    GroupPermission? group,
    DepartmentPermission? department,
    this.inProduct = false,
    this.outProduct = false,
  }) {
    this.department = department ?? DepartmentPermission();
    this.product = product ?? ProductPermission();
    this.group = group ?? GroupPermission();
  }
  static TotalProductPermission initializeMap(List<String> map) {
    return TotalProductPermission(
        inProduct: map.contains("in_product"),
        outProduct: map.contains("out_product"),
        group: GroupPermission().initializeMap(map),
        department: DepartmentPermission().initializeMap(map),
        product: ProductPermission().initializeMap(map));
  }

  List<int> getPermissions() {
    List<int> permissions = [];
    if (inProduct) {
      permissions.add(permissionsData.indexOf("in_product"));
    }
    if (outProduct) {
      permissions.add(permissionsData.indexOf("out_product"));
    }

    return permissions +
        product.getPermissions() +
        group.getPermissions() +
        department.getPermissions();
  }

  void tickAllTrue() {
    inProduct = true;
    outProduct = true;
    group.tickAllTrue();
    department.tickAllTrue();
    product.tickAllTrue();
  }

  void tickAllFalse() {
    inProduct = false;
    outProduct = false;
    group.tickAllFalse();
    department.tickAllFalse();
    product.tickAllFalse();
  }
}
