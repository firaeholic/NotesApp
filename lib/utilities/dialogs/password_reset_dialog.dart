import 'package:flutter/widgets.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Reset Password', 
    content: 'A reset password link has been sent to your email!', 
    optionBuilder: () => {
      'OK': null
    });
}