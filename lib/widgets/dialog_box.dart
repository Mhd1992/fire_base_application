import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void dialogBox(
  BuildContext context,
  String errorMessage,
  DialogType type, {
  Function()? onOkPressed,
}) => AwesomeDialog(
  context: context,
  title: 'Alert',
  dialogType: type,
  desc: errorMessage,
  btnCancelOnPress: () {},
  btnOkOnPress: onOkPressed,
).show();
