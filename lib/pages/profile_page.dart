import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile_info.dart';
import '../widgets/clock_in_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileInfo(
                username: authProvider.name,
                id: authProvider.employeeId,
                type: authProvider.userType,
                phone: authProvider.phoneNumber,
                email: authProvider.email,
                facebook: authProvider.facebook,
              ),
              ClockInSection(id: authProvider.employeeId),
            ],
          ),
        ),
      ),
    );
  }
}
