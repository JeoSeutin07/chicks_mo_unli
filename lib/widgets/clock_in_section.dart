import 'package:chicks_mo_unli/pages/employee_id_screen.dart';
import 'package:chicks_mo_unli/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chicks_mo_unli/pages/auth_page.dart';
import 'package:chicks_mo_unli/pages/Profile/clockin_screen.dart';
import 'package:provider/provider.dart';
import 'package:chicks_mo_unli/pages/Owner/widgets/setup_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    Navigator.of(context).push(
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
  bool _isClockedIn = false;
  bool _isLoading = true;
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _fetchClockStatus();
  }

  Future<void> _fetchClockStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.employeeId)
        .get();
    setState(() {
      _isClockedIn = doc['clockedIn'] ?? false;
      _isLoading = false;
    });
  }

  Future<void> _clockIn() async {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            ClockInScreen(employeeId: widget.employeeId, isClockingIn: true),
      ),
    )
        .then((_) {
      _fetchClockStatus(); // Refresh clock status after returning from ClockInScreen
    });
  }

  Future<void> _clockOut() async {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            ClockInScreen(employeeId: widget.employeeId, isClockingIn: false),
      ),
    )
        .then((_) {
      _fetchClockStatus(); // Refresh clock status after returning from ClockInScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggingOut) {
      // If logging out, do not rebuild the widget (return an empty container or static widget)
      return Container(); // Or any placeholder widget
    }

    // If not logging out, proceed with building the clock in/out button
    return Container(
      width: 217,
      child: Column(
        children: [
          GestureDetector(
            onTap: _isClockedIn ? _clockOut : _clockIn,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: _isClockedIn
                    ? const Color(0xFFE74C3C)
                    : const Color(0xFFFFEF00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _isClockedIn ? 'Clock Out' : 'Clock In',
                  style: const TextStyle(
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
          Text(
            'Current Status: ${_isClockedIn ? 'Clocked In' : 'Clocked Out'}',
            style: const TextStyle(
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

    // Clear credentials in AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearCredentials();

    // Navigate to EmployeeIdScreen and clear the navigation stack
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const EmployeeIdScreen()),
      (Route<dynamic> route) => false, // Clears all previous routes
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
