import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text});
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      minWidth: 200,
      padding: const EdgeInsets.all(12.0),
      color: Colors.blue,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
