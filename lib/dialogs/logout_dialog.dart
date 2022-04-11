import 'package:flutter/cupertino.dart';
import 'package:notepad/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showGenericDialog(
      context: context,
      content: "Are you sure wanna logout?",
      dialogOptionsBuilder: () {
        return {
          "Cancel": false,
          "LogOut": true,
        };
      }).then((value) => value ?? false);
}
