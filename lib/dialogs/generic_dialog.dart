import 'package:flutter/material.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String content,
  required DialogOptionsBuilder dialogOptionsBuilder,
}) {
  final options = dialogOptionsBuilder();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(content),
          actions: options.keys.map((option) {
            final T value = options[option];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(option),
            );
          }).toList(),
        );
      });
}
