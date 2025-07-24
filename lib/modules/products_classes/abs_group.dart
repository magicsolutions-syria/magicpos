 class AbsGroup {
  final int id;
  String _name = "";

  String get name => _name;

  AbsGroup({
    required this.id,
    required String name,
  }) {
    _name = name;
  }



  void setName(String name) {
    _name = name;
  }
}
