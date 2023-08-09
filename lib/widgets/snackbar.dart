import 'package:flutter/material.dart';

SnackBar customSnackBar(String text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: Colors.red,
  );
}
