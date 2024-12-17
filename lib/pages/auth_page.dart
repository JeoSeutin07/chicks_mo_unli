import 'package:chicks_mo_unli/pages/employee_id_screen.dart';
import 'package:chicks_mo_unli/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  // Secure storage instance
  final storage = FlutterSecureStorage();

  // Check if a user session exists using Employee ID
  Future<bool> isUserLoggedIn() async {
    String? employeeId = await storage.read(key: 'employeeId');
    return employeeId != null; // Returns true if a session exists
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        // Show a loading indicator while checking the session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Navigate based on session state
        if (snapshot.data == true) {
          return const MainPage(); // User logged in
        } else {
          return const EmployeeIdScreen(); // No session found
        }
      },
    );
  }
}
