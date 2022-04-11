import 'package:flutter/cupertino.dart';
import 'package:notepad/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) async {
  return await showGenericDialog(
      context: context,
      content: "Are you sure wanna delete?",
      dialogOptionsBuilder: () {
        return {
          "No": false,
          "Yes": true,
        };
      }).then((value) => value ?? false);
}
