import 'package:flutter/material.dart';
import 'dart:async';

class ToastHelper {
  static Timer? _timer;
  static OverlayEntry? _overlayEntry;

  /// Shows a custom "Toast" style notification that floats above everything
  static void show(BuildContext context, String message, {bool isError = false}) {
    // 1. Remove any existing toast to prevent stacking
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _timer?.cancel();
    }

    // 2. Get Theme Data for colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF333333) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isError ? Colors.redAccent : (isDark ? Colors.greenAccent : Colors.green);

    // 3. Create the OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Position it safely above the FAB area
        bottom: 120, 
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: _ToastWidget(
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            iconColor: iconColor,
            isError: isError,
          ),
        ),
      ),
    );

    // 4. Insert into the screen
    Overlay.of(context).insert(_overlayEntry!);

    // 5. Remove after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }
}

// Internal Widget for animation and layout
class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final bool isError;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.isError,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Center( // Center horizontally
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(30), // Pill shape
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Wrap content
              children: [
                Icon(
                  widget.isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: widget.iconColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}