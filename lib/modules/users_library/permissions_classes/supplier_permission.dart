import 'package:magicposbeta/modules/users_library/permissions_classes/aud_permission.dart';

import '../../../screens_data/constants.dart';

class SupplierPermission extends AUDPermission {
  SupplierPermission({super.add, super.delete, super.update});

  @override
  initializeMap(List<String> map) {
    return SupplierPermission(
      add: map.contains("add_supplier"),
      update: map.contains("update_supplier"),
      delete: map.contains("delete_supplier"),
    );
  }

  @override
  List<int> getPermissions() {
    List<int> permissions = [];
    if (add) {
      permissions.add(permissionsData.indexOf("add_supplier"));
    }
    if (delete) {
      permissions.add(permissionsData.indexOf("delete_supplier"));
    }
    if (update) {
      permissions.add(permissionsData.indexOf("update_supplier"));
    }
    return permissions;
  }
}
