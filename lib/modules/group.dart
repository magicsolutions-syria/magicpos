class Group {
  final int id;
  final String name;
  bool isSelected = false;

  Group({required this.id, required this.name, required this.isSelected});

  static String getSelectId(List<Group> groups) {
    String value = "";
    for (var group in groups) {
      if(group.isSelected) {
        value += ", ${group.id}";
      }
    }
    return value;
  }

  static Group emptyInstance() {
    return Group(id: 0, name: "", isSelected: false);
  }
}
