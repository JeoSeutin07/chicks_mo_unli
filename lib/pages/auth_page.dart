import 'package:chicks_mo_unli/pages/employee_id_screen.dart';
import 'package:chicks_mo_unli/pages/login_screen.dart';
import 'package:chicks_mo_unli/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  // Secure storage instance
  final storage = FlutterSecureStorage();

  // Check if a user session exists
  Future<bool> isUserLoggedIn() async {
    String? userEmail = await storage.read(key: 'userEmail');
    return userEmail != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the Future to complete
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          // User is logged in, navigate to MainPage
          return const MainPage();
        } else {
          // No user session, navigate to EmployeeIdScreen
          return const EmployeeIdScreen();
        }
      },
    );
  }
}
