import 'package:equatable/equatable.dart';

class AbsDepartment implements Equatable {
  final int id;
  String _name = "";

  String get name => _name;

  AbsDepartment({
    required this.id,
    required String name,
  }) {
    _name = name;
  }

  void setName(String name) {
    _name = name;
  }
  @override
  // TODO: implement props
  List<Object?> get props => [id,name];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
