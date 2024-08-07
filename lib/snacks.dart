import 'package:flutter/material.dart';

class Snacks{
  static const errorC=Colors.red;
  static const okay=Colors.green;

  static Future<void> itSnack(BuildContext context, String message, bool error) async{//появление snack bar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final sn=SnackBar(content: Text(message),
    backgroundColor: error ? errorC : okay,);
    ScaffoldMessenger.of(context).showSnackBar(sn);
  }
}