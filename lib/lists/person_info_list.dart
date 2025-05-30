import 'package:flutter/material.dart';
import '../../database/functions/person_functions.dart';
import '../../screens/person_card.dart';
import '../../theme/locale/locale.dart';
import '../components/general_list.dart';

class PersonInfoList extends StatelessWidget {
  const PersonInfoList({
    super.key,
    required this.onDoubleTap,
    required this.tableName,
  });

  final Function(Map item) onDoubleTap;
  final String tableName;

  @override
  Widget build(BuildContext context) {
    return GeneralList(
      secondaryController: TextEditingController(),
      searchTypes: SearchTypes.searchTypesPerson(),
      secondaryDropDown: const [],
      secondaryDropDownName: '',
      columnsNames: ListsColumnsNames.personListNames(),
      getData: (searchType, text) async {
        return await PersonFunctions.getPersonList(
          personType: tableName,
          searchType: searchType,
          searchText: text,
        );
      },
      onDoubleTap: (Map item) {
        onDoubleTap(item);
      },
      dataNames: const [
        "Barcode",
        "Name_English",
        "Name_Arabic",
        "id",
      ],
      columnsRatios: const [0.25, 0.25, 0.25, 0.25],
      enableAddButton: false,
      addPage: PersonCard.clientRoute,
    );
  }
}
