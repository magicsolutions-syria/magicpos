import 'package:magicposbeta/screens_data/constants.dart';

import 'aud_permission.dart';

class ClientPermission extends AUDPermission {
  ClientPermission({super.add, super.delete, super.update});

  @override
  initializeMap(List<String> map) {
    return ClientPermission(
        add: map.contains("add_client"),
        update: map.contains("update_client"),
        delete: map.contains("delete_client"));
  }

  @override
  List<int> getPermissions() {
    List<int> permissions = [];
    if (add) {
      permissions.add(permissionsData.indexOf("add_client"));
    }
    if (delete) {
      permissions.add(permissionsData.indexOf("delete_client"));
    }
    if (update) {
      permissions.add(permissionsData.indexOf("update_client"));
    }
    return permissions;
  }
}
