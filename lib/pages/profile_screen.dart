import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/clock_in_section.dart';
import '../widgets/navigation_bar.dart' as custom;
import '../providers/auth_provider.dart';
import '../widgets/profile_info.dart'; // Import ProfileInfo widget

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Color(0xFFFFF3CB),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(userName: authProvider.name),
              // Pass parameters to ProfileInfo
              ProfileInfo(
                id: authProvider.employeeId,
                type: authProvider.userType,
                phone: authProvider.phoneNumber,
                email: authProvider.email,
                facebook: authProvider.facebook,
              ),
              ClockInSection(id: authProvider.employeeId),
              custom.NavigationBar(),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                color: Color(0xFFF3EDF7),
                child: Container(
                  width: 108,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF1D1B20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
