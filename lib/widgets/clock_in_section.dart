import 'package:flutter/material.dart';
import 'styled_button.dart'; // import the StyledButton widget

class ClockInSection extends StatelessWidget {
  final String id;

  const ClockInSection({super.key, required this.id});

  void logOut() {
    // Implement the log out functionality here
    print('User logged out');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: 258,
            height: 31,
            padding: const EdgeInsets.symmetric(horizontal: 117, vertical: 13),
            decoration: ShapeDecoration(
              color: Color(0xFFFFF3CB),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Set Up Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0.14,
                      letterSpacing: 0.12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 115,
            color: Color(0xFFFFEF00),
            child: Center(
              child: Text(
                'Clock In',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.48,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Current Status: Clocked out',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 0.16,
            ),
          ),
          SizedBox(height: 20),
          StyledButton(
            text: 'Log out',
            onPressed: logOut,
          ),
        ],
      ),
    );
  }
}
