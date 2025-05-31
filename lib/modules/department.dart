import 'package:equatable/equatable.dart';

import 'group.dart';

class Department implements Equatable{
  final int id;
  final String name;
  final List<Group> groups = [];
  bool isSelected = false;

  Department({required this.id, required this.name, required this.isSelected});

  void addGroup(
      {required int id, required String name, required bool isSelected}) {
    Group newGroup = Group(id: id, name: name, isSelected: isSelected);
    groups.add(newGroup);
  }

  void checkIfSelected() {
    bool check = true;
    groups.forEach((e) {
      check = check && e.isSelected;
      if(!check)return;
    });
    if(check){isSelected=true;}
    else {
      isSelected=false;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,name];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
