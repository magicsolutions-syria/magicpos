import 'package:equatable/equatable.dart';

abstract class AUDPermission implements Equatable {
  bool add;
  bool delete;
  bool update;
  AUDPermission({this.add = false, this.delete = false, this.update = false});
  initializeMap(List<String> map);
  List<int> getPermissions();
  void tickAllTrue() {
    add = true;
    update = true;
    delete = true;
  }

  void tickAllFalse() {
    add = false;
    update = false;
    delete = false;
  }
  @override
  // TODO: implement props
  List<Object?> get props =>[add,update,delete];
  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
