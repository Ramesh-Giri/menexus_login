import 'package:flutter/material.dart';

class MessageHandler {
  static void showSnackBar(scaffoldKey, message) {
    scaffoldKey.currentState!.hideCurrentSnackBar();

    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellowAccent,
    ));
  }
}
