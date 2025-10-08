import 'package:flutter/material.dart';

class ErrorNotification extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const ErrorNotification({
    super.key,
    required this.message,
    required this.onClose,
  });

  static final BoxDecoration _decoration = BoxDecoration(
    color: Colors.red[50],
    border: Border.all(color: Colors.red[200]!),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(50),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget get _closeButton {
    return IconButton(
      icon: Icon(Icons.close, color: Colors.red[600], size: 20),
      onPressed: onClose,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
    );
  }

  Widget get _title {
    return Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red[600], size: 20),
        const SizedBox(width: 8),
        Text(
          'Error',
          style: TextStyle(
            color: Colors.red[800],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget get _body {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          _title,
          Text(
            message,
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: _decoration,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 12,
              children: [
                _body,
                _closeButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}