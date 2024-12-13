import 'package:chicks_mo_unli/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chicks_mo_unli/pages/auth_page.dart';
import 'package:chicks_mo_unli/pages/Profile/clockin_screen.dart';
import 'package:provider/provider.dart';
import 'package:chicks_mo_unli/pages/Profile/widgets/setup_account.dart';

class ClockInSection extends StatelessWidget {
  final String employeeId;

  const ClockInSection({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SetupAccountButton(), // SetupAccountButton no longer navigates to ClockInScreen
          const SizedBox(height: 20),
          ClockStatusWidget(
              employeeId: employeeId), // Pass employeeId to ClockStatusWidget
          const SizedBox(height: 20),
          const LogoutButton(),
        ],
      ),
    );
  }
}

class SetupAccountButton extends StatefulWidget {
  const SetupAccountButton({super.key});

  @override
  _SetupAccountButtonState createState() => _SetupAccountButtonState();
}

class _SetupAccountButtonState extends State<SetupAccountButton> {
  Color _buttonColor = const Color(0xFFFFF3CB);

  void _setupAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _setupAccount,
      onTapDown: (_) {
        setState(() {
          _buttonColor = const Color(0xFFCCC2A2);
        });
      },
      onTapUp: (_) {
        setState(() {
          _buttonColor = const Color(0xFFFFF3CB);
        });
      },
      splashColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 258),
        decoration: BoxDecoration(
          color: _buttonColor,
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
      ),
    );
  }
}

class ClockStatusWidget extends StatefulWidget {
  final String employeeId;

  const ClockStatusWidget({super.key, required this.employeeId});

  @override
  _ClockStatusWidgetState createState() => _ClockStatusWidgetState();
}

class _ClockStatusWidgetState extends State<ClockStatusWidget> {
  void _navigateToClockInScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClockInScreen(employeeId: widget.employeeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 217,
      child: Column(
        children: [
          GestureDetector(
            onTap: _navigateToClockInScreen,
            child: Container(
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
          ),
          const SizedBox(height: 5),
          const Text(
            'Current Status: Clocked out',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.16,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logOut(BuildContext context) async {
    final storage = FlutterSecureStorage();

    // Clear stored data
    await storage.delete(key: 'employeeID');
    await storage.delete(key: 'username');

    // Clear the credentials in AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearCredentials();

    // Navigate to the AuthPage after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _logOut(context),
      child: Container(
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
      ),
    );
  }
}
