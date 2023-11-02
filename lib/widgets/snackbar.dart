import 'package:flutter/material.dart';

void showSnackbar(
    String message, BuildContext context, Color bgcolor, Color txtcolor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
          message,
          style: TextStyle(color: txtcolor),
        ),
        backgroundColor: bgcolor),
  );
}
