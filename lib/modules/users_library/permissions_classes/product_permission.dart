import '../../../screens_data/constants.dart';
import 'aud_permission.dart';

class ProductPermission extends AUDPermission {
  ProductPermission({super.add, super.update, super.delete});
  @override
  initializeMap(List<String> map) {
    return ProductPermission(
      add: map.contains("add_product"),
      update: map.contains("update_product"),
      delete: map.contains("delete_product"),
    );
  }

  @override
  List<int> getPermissions() {
    List<int> permissions = [];
    if (add) {
      permissions.add(permissionsData.indexOf("add_product"));
    }
    if (delete) {
      permissions.add(permissionsData.indexOf("delete_product"));
    }
    if (update) {
      permissions.add(permissionsData.indexOf("update_product"));
    }
    return permissions;
  }
}
