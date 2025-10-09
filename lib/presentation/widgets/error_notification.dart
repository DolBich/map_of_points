import 'dart:async';

import 'package:flutter/material.dart';

class ErrorNotification extends StatefulWidget {
  final String message;
  final VoidCallback onClose;
  final Duration duration;

  const ErrorNotification({
    super.key,
    required this.message,
    required this.onClose,
    this.duration = const Duration(seconds: 4, milliseconds: 700),
  });

  static final BoxDecoration _decoration = BoxDecoration(
    color: Colors.red[50],
    border: Border.all(color: Colors.red),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(50),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  @override
  State<ErrorNotification> createState() => _ErrorNotificationState();
}

class _ErrorNotificationState extends State<ErrorNotification> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    _autoHideTimer = Timer(widget.duration, _hideWithAnimation);
  }

  void _hideWithAnimation() {
    _controller.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget get _closeButton {
    return IconButton(
      icon: Icon(Icons.close, color: Colors.red),
      onPressed: widget.onClose,
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
        Icon(Icons.error_outline, color: Colors.red),
        const SizedBox(width: 8),
        Text(
          'Error',
          style: TextStyle(
            color: Colors.red,
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
            widget.message,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SlideTransition(
              position: _positionAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: ErrorNotification._decoration,
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
            ),
          ),
        ),
      ),
    );
  }
}