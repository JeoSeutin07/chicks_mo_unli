import 'package:flutter/material.dart';

class StyledButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const StyledButton({super.key, required this.text, required this.onPressed});

  @override
  _StyledButtonState createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      child: Container(
        width: 359,
        height: 51,
        padding: const EdgeInsets.symmetric(horizontal: 117, vertical: 13),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFFD6C35C) : const Color(0xFFFFF55E),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                height: 0.05,
                letterSpacing: 0.20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
