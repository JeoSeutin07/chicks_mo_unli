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
          SizedBox(height: 5),
          ClockStatusWidget(), // replace the existing clock status with the new widget
          SizedBox(height: 20),
          LogoutButton(), // replace the existing log out button with the new widget
        ],
      ),
    );
  }
}

class SetupAccountButton extends StatelessWidget {
  const SetupAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 258),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 83),
        child: Text(
          'Set Up Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.12,
            height: 2,
          ),
        ),
      ),
    );
  }
}

class ClockStatusWidget extends StatelessWidget {
  const ClockStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 217,
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEF00),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Clock In',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.48,
                  height: 20 / 48,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Current Status: Clocked out',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.16,
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 359),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEF00),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 117),
        child: Text(
          'Log out',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            height: 1,
          ),
        ),
      ),
    );
  }
}
