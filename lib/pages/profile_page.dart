import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider for access to AuthProvider
import 'Profile/widgets/clock_dialog.dart'; // Import ClockDialog widget
import '../providers/auth_provider.dart'; // Adjust import based on your project structure
import '../widgets/profile_info.dart'; // Import ProfileInfo widget
import '../widgets/clock_in_section.dart'; // Import ClockInSection widget

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AuthProvider instance and get user data
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pass the data from AuthProvider to ProfileInfo
                ProfileInfo(
                  username: authProvider.name,
                  id: authProvider.employeeId,
                  type: authProvider.userType,
                  phone: authProvider.phoneNumber,
                  email: authProvider.email,
                  facebook: authProvider.facebook,
                  profilePic: authProvider.profilePic,
                ),
                const SizedBox(height: 20),
                ClockInSection(employeeId: authProvider.employeeId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
