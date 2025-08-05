import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/database/functions/product_functions.dart';
import 'package:magicposbeta/modules/products_classes/info_product.dart';
import 'package:magicposbeta/theme/locale/drop_down_data.dart';
import '../../../theme/locale/search_types.dart';
import 'product_list_states.dart';

class ProductCardListCubit extends Cubit<ProductCardListStates> {
  ProductCardListCubit(
    Function() InitialProductCardListState,
  ) : super(InitialProductCardListState()){
    getData();
  }
  List<InfoProduct> products = [];
  String searchType = SearchTypes.arName;
  String searchText = "";
  String dropDownText=DropDownData.unit1;
  int dropDownValue = 1;

  Future<void> getData() async {

    try {
      emit(LoadingProductCardListState());
      switch (searchType) {
        case (SearchTypes.enName):
          {
            products =
            await ProductFunctions.searchProductByEnglishName(searchText);
            break;
          }
        case (SearchTypes.code1):
          {
            products = await ProductFunctions.searchProductByCode1(searchText);
            break;
          }
        case (SearchTypes.code2):
          {
            products = await ProductFunctions.searchProductByCode2(searchText);
            break;
          }
        case (SearchTypes.code3):
          {
            products = await ProductFunctions.searchProductByCode3(searchText);
            break;
          }
        default:
          {
            products =
            await ProductFunctions.searchProductByArabicName(searchText);
            break;
          }
      }
      emit(SuccessProductCardListState());
    } catch (e) {
      emit(FailureProductCardListState(error: e.toString()));
    }
  }

  void changeDropDown(String value) {
    dropDownText=value;
    switch (value) {
      case DropDownData.unit1:
        dropDownValue = 1;
        break;
      case DropDownData.unit2:
        dropDownValue = 2;
        break;
      case DropDownData.unit3:
        dropDownValue = 3;
        break;

      default:
        {}
    }
    getData();
  }

  void changeSearchType(String value) {
    searchType=value;
    getData();
  }

  void changeSearchText(String value) {
    searchText=value;
    getData();
  }
}
