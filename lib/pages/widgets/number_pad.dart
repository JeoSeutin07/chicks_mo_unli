import 'package:flutter/material.dart';

class NumberPad extends StatefulWidget {
  final Function(String) onNumberSelected;
  final Function() onBackspace;

  const NumberPad(
      {Key? key, required this.onNumberSelected, required this.onBackspace})
      : super(key: key);

  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String _pressedButton = '';

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedButton = number;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressedButton = '';
        });
        widget.onNumberSelected(number);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: _pressedButton == number
              ? const Color(0xFFD6C35C)
              : const Color(0xFFFFF55E),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              letterSpacing: 0.14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: widget.onBackspace,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF55E),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.backspace,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNumberButton('1'),
                _buildNumberButton('2'),
                _buildNumberButton('3'),
              ],
            ),
            const SizedBox(height: 34),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNumberButton('4'),
                _buildNumberButton('5'),
                _buildNumberButton('6'),
              ],
            ),
            const SizedBox(height: 34),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNumberButton('7'),
                _buildNumberButton('8'),
                _buildNumberButton('9'),
              ],
            ),
            const SizedBox(height: 34),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 60), // Spacer to match the spacing
                _buildNumberButton('0'),
                _buildBackspaceButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
