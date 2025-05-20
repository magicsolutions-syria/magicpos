import 'package:flutter/material.dart';
import 'package:magicposbeta/database/users_functions.dart';
import 'package:magicposbeta/screens/user_card.dart';
import '../../theme/locale/locale.dart';
import '../general_list.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.onDoubleTap});

  final Function(Map item) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GeneralList(
      secondaryController: TextEditingController(),
      searchTypes: SearchTypes.searchTypesUser(),
      secondaryDropDown: const [],
      secondaryDropDownName: '',
      columnsNames: ListsColumnsNames.userListNames(),
      commas: const [-1, -1, -1],
      getData: (searchType, text) async {
        return await UsersFunctions.getUsersList(
            searchText: text, searchType: searchType);
      },
      onDoubleTap: (item) {
        onDoubleTap(item);
      },
      dataNames: const [
        "ar_name",
        "en_name",
        "jop_title_name",
      ],
      columnsRatios: const [0.35, 0.35, 0.3],
      addPage: UserCard.route,
      enableAddButton: false,
    );
  }
}
