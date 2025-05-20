import '../../../screens_data/constants.dart';
import 'aud_permission.dart';

class GroupPermission extends AUDPermission {
  GroupPermission({super.add, super.update, super.delete});
  @override
  initializeMap(List<String> map) {
    return GroupPermission(
      add: map.contains("add_group"),
      update: map.contains("update_group"),
      delete: map.contains("delete_group"),
    );
  }

  @override
  List<int> getPermissions() {
    List<int> permissions = [];
    if (add) {
      permissions.add(permissionsData.indexOf("add_group"));
    }
    if (delete) {
      permissions.add(permissionsData.indexOf("delete_group"));
    }
    if (update) {
      permissions.add(permissionsData.indexOf("update_group"));
    }
    return permissions;
  }
}
