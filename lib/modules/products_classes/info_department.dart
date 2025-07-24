import 'package:magicposbeta/modules/products_classes/abs_department.dart';

class InfoDepartment extends AbsDepartment {
  final int productQty;

  InfoDepartment({
    this.productQty = 0,
    required super.id,
    required super.name,
  });

  static InfoDepartment emptyInstance() {
    return InfoDepartment(id: -1, name: '');
  }
}
