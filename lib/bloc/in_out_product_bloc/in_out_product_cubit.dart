import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/in_out_product.dart';
import 'package:magicposbeta/modules/products_classes/info_product.dart';
import 'package:magicposbeta/modules/person.dart';
import 'package:magicposbeta/theme/custom_exception.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../database/functions/product_functions.dart';
import '../../database/functions/product_unit_functions.dart';
import '../../modules/printer.dart';
import '../../modules/user.dart';
import 'in_out_product_states.dart';

class InOutProductCubit extends Cubit<InOutProductStates> {
  InOutProductCubit(Function() InitialInOutProductState, this.currentUser)
      : super(InitialInOutProductState());

  final User currentUser;

  List<InOutProduct> products = [];

  Person person = Person.emptyInstance();

  String personType = "";

  double totalQty = 0;

  double totalPrice = 0;

  String operationType = SearchTypes.inOperation;

  MethodChannel platform = const MethodChannel('IcodPrinter');

  bool enableDropDown() {
    if (currentUser.product.inProduct || currentUser.product.outProduct) {
      return true;
    } else {
      return false;
    }
  }

  List<String> operations() {
    List<String> data = [];
    if (currentUser.product.inProduct) {
      data.add(SearchTypes.inOperation);
    }
    if (currentUser.product.outProduct) {
      data.add(SearchTypes.outOperation);
    }

    return data;
  }

  Future<void> executeOperation(int priceComma, int qtyComma) async {
    try {
      String printText = await InOutProduct.insertProducts(
        products,
        person.arName,
        operationType,
        personType,
        priceComma: priceComma,
        qtyComma: qtyComma,
      );
      products = [];
      totalPrice = 0;
      totalQty = 0;
      person = Person.emptyInstance();
      if (operationType == SearchTypes.inOperation) {
        emit(CompletedOperationState(
            phrase: SuccessDialogPhrases.inOperationComplete));
      } else {
        emit(CompletedOperationState(
            phrase: SuccessDialogPhrases.outOperationComplete));
      }
   //   Print
      //await platform.invokeMethod("printText", printText);
    } catch (e) {
      emit(FailureInOutProductState(error: e.toString()));
    }
  }

  void initialPerson(Map item, String type) {
    person = Person.instanceFromMap(item);
    personType = type;
  }

  void removeProduct(int index) {
    InOutProduct product = products[index];
    totalQty -= product.qty;
    totalPrice -= product.price;
    products.removeAt(index);
    emit(SuccessInOutProductState());
  }

  void addProductToList(Map item) {
    InOutProduct product = InOutProduct.initializeMap(item);
    totalQty += product.qty;
    totalPrice += product.price;
    products.insert(0,product);
    emit(SuccessInOutProductState());
  }

  void changeProductQty(int index, String value) {
    InOutProduct product = products[index];
    double newQty=double.tryParse(value)??0;
    double changedQty =newQty  - product.qty;
    double changedPrice = (newQty - product.qty) * product.price;
    totalQty += changedQty;
    totalPrice += changedPrice;
    products[index].qty += changedQty;
    products[index].currentTotalPrice += changedPrice;
    emit(ChangedProductDataState(qty: products[index].qty,price: products[index].price));
  }

  void changeProductPrice(int index, String value) {
    InOutProduct product = products[index];
    double newPrice=double.tryParse(value)??0;
    double changedPrice = (newPrice-product.price)*product.qty;
    totalPrice += changedPrice;
    products[index].currentTotalPrice += changedPrice;
    products[index].price=newPrice;
    emit(ChangedProductDataState(qty: products[index].qty,price: products[index].price));
  }

  void changeProductName(int index, String value) {
    products[index].unit=value;
  }
}
