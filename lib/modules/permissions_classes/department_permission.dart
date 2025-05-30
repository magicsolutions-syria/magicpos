import '../../../screens_data/constants.dart';
import 'aud_permission.dart';

class DepartmentPermission extends AUDPermission {
  DepartmentPermission({super.add, super.update, super.delete});
  @override
  initializeMap(List<String> map) {
    return DepartmentPermission(
      add: map.contains("add_department"),
      update: map.contains("update_department"),
      delete: map.contains("delete_department"),
    );
  }

  @override
  List<int> getPermissions() {
    List<int> permissions = [];
    if (add) {
      permissions.add(permissionsData.indexOf("add_department"));
    }
    if (delete) {
      permissions.add(permissionsData.indexOf("delete_department"));
    }
    if (update) {
      permissions.add(permissionsData.indexOf("update_department"));
    }
    return permissions;
  }
}
