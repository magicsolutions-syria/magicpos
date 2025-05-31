import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import 'package:magicposbeta/theme/locale/wrong_dialog_phrases.dart';

import '../../modules/custom_exception.dart';
import '../../modules/printer.dart';
import '../../theme/app_profile.dart';
import '../../theme/locale/warning_dialogs_phrases.dart';
import 'bill_states.dart';

class BillCubit extends Cubit<BillStates> {
  BillCubit(Function() InitialBillState, BuildContext context)
      : super(InitialBillState()) {
    imagePath = context.read<SharedCubit>().settings.billLogo;
    header = context.read<SharedCubit>().settings.billHeader;
    footer = context.read<SharedCubit>().settings.billFooter;
    headerType = context.read<SharedCubit>().settings.headerType;
  }

  String imagePath = "";
  String header = "";
  String footer = "";
  String headerType = "";

  Future<void> setBillSettings(BuildContext context) async {
    try {
      if (headerType == RadiosValues.logo) {
        if (imagePath == "") {
          throw CustomException(WrongDialogPhrases.mustSelectImage);
        }
        await Printer.createCopy(imagePath);
        if (context.mounted) {
          context
              .read<SharedCubit>()
              .settings
              .setBillLogo(value: AppProfile.billLogoDefaultPath);
        }
      } else {
        context.read<SharedCubit>().settings.setBillHeader(value: header);
      }
      if (context.mounted) {
        context.read<SharedCubit>().settings.setHeaderType(value: headerType);
        context.read<SharedCubit>().settings.setBillFooter(value: footer);
      }
      emit(SuccessBillState());
    } catch (e) {
      emit(FailureBillState(e.toString()));
    }
  }

  void updateHeaderType(String text) {
    headerType = text;
    emit(ChangedHeaderState());
  }
}
