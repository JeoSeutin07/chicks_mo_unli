import 'package:flutter/material.dart';
import 'number_pad.dart';

class PinInput extends StatefulWidget {
  const PinInput({super.key});

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  bool _isObscured = true;
  final List<String> _pin = List.filled(6, '');
  int _currentIndex = 0;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _onNumberSelected(String number) {
    if (_currentIndex < 6) {
      setState(() {
        _pin[_currentIndex] = number;
        _currentIndex++;
      });
    }
  }

  void _onBackspace() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pin[_currentIndex] = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Pin',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF49454F),
              letterSpacing: 0.4,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _pin[index].isNotEmpty && !_isObscured
                        ? SizedBox(
                            width: 15,
                            height: 15,
                            child: Center(
                              child: Text(
                                _pin[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              color: _pin[index].isNotEmpty && _isObscured
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: _toggleVisibility,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          height: 1,
          color: const Color(0xFF49454F),
        ),
        const SizedBox(height: 16),
        Center(
          child: NumberPad(
            onNumberSelected: _onNumberSelected,
            onBackspace: _onBackspace,
          ),
        ),
      ],
    );
  }
}
