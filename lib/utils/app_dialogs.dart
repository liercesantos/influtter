import 'package:flutter/material.dart';

class AppDialog {
  static show(BuildContext context, String title, String message,
      String buttonText, action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            child: Text(buttonText),
            onPressed: () => {action()},
          ),
        ],
      ),
    );
  }
}
