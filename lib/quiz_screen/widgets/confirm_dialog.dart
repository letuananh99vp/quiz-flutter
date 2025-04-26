import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Xác nhận'),
      content: Text('Bạn có muốn lưu lại câu trả lời?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Không'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Có'),
        ),
      ],
    ),
  );
}
