import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/info_product.dart';
import 'package:magicposbeta/theme/custom_exception.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../database/functions/product_functions.dart';
import '../../database/functions/product_unit_functions.dart';
import '../../modules/user.dart';
import 'product_states.dart';

class ProductCardCubit extends Cubit<ProductCardStates> {
  ProductCardCubit(Function() InitialProductCardState, this.currentUser)
      : super(InitialProductCardState()) {
    initialCard();
  }

  InfoProduct product = InfoProduct.emptyInstance();
  InfoProduct constProduct = InfoProduct.emptyInstance();
  final User currentUser;
  List<String> names_1 = [];
  List<String> names_2 = [];
  List<String> names_3 = [];
  bool isAddMode = true;

  Future<void> initialCard() async {
    try {
      isAddMode = true;
      product = InfoProduct.emptyInstance();
      constProduct = product;
      String id = await ProductFunctions.initialProductId();
      product.id = int.parse(id);
      names_1 = await ProductUnitFunctions.namesData1();
      names_2 = await ProductUnitFunctions.namesData2();
      names_3 = await ProductUnitFunctions.namesData3();
      emit(SuccessProductCardState());
    } catch (e) {
      emit(
        FailureProductCardState(
          error: e.toString(),
        ),
      );
    }
  }

  void updateDescription(String description) {
    product.description = description;
  }

  void updateImagePath(String path) {
    product.imagePath = path;
  }

  bool deletePermission() {
print(currentUser.product.product.update);
print(currentUser.product.product.add);
print(currentUser.product.product.delete);

    return !isAddMode && currentUser.product.product.delete;
  }

  bool updatePermission() {

    return !isAddMode && currentUser.product.product.update;
  }

  bool addPermission() {
    return isAddMode && currentUser.product.product.add;
  }

  addProduct() async {
    emit(LoadingProductCardState());
    try {
      if (product.arName == "") {
        throw CustomException(ErrorsCodes.emptyArName);
      }
      if (product.enName == "") {
        throw CustomException(ErrorsCodes.emptyEnName);
      }
      if (product.groupName == "") {
        throw CustomException(ErrorsCodes.emptyGroupName);
      }
      if (product.checkQty()) {
        throw CustomException(ErrorsCodes.invalidQty);
      }
      if (product.checkBarcodes()) {
        throw CustomException(ErrorsCodes.barcodeIsNotUnique);
      }
      await ProductFunctions.addProduct(product);
      await initialCard();

      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.addOperationComplete));
    } catch (e) {
      emit(FailureProductCardState(error: e.toString()));
    }
  }

  updateProduct() async {
    emit(LoadingProductCardState());
    try {
      if (product.arName == "") {
        throw CustomException(ErrorsCodes.emptyArName);
      }
      if (product.enName == "") {
        throw CustomException(ErrorsCodes.emptyEnName);
      }
      if (product.groupName == "") {
        throw CustomException(ErrorsCodes.emptyGroupName);
      }
      if (product.checkBarcodes()) {
        throw CustomException(ErrorsCodes.barcodeIsNotUnique);
      }
      await ProductFunctions.updateProduct(product);
      constProduct = product;
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.updateOperationComplete));
    } catch (e) {
      emit(FailureProductCardState(error: e.toString()));
    }
  }

  deleteProduct() async {
    emit(LoadingProductCardState());
    try {
      await ProductFunctions.deleteProduct(product.id);
      await initialCard();
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.deleteOperationComplete));
    } catch (e) {
      emit(FailureProductCardState(error: e.toString()));
    }
  }

  void initialProduct(Map item) {
    emit(LoadingProductCardState());
    product = InfoProduct.instanceFromMap(item);
    constProduct = product;
    isAddMode = false;
    emit(SuccessProductCardState());
  }

  bool isChanged() {
    return !(constProduct == product);
  }

  void updateDepartmentName(String departmentVal) {
    product.departmentName=departmentVal;
    emit(ChangedValueState());
  }

  void updateGroupName({required String group, required String department}) {
    product.departmentName=department;
    product.groupName=group;
    emit(ChangedValueState());
  }
}
