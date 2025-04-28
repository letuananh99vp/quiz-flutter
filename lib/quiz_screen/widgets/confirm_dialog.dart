import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String content) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Xác nhận'),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Không'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Có'),
        ),
      ],
    ),
  );
}
