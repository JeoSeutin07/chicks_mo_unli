import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile_info.dart';
import '../widgets/clock_in_section.dart';
import 'profile/widgets/setup_account.dart'; // Import SetupAccountScreen

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Navigator(
          key: GlobalKey<
              NavigatorState>(), // Add a unique key for nested navigator
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (context) => ProfileContent(authProvider: authProvider),
            );
          },
        ));
  }
}

class ProfileContent extends StatelessWidget {
  final AuthProvider authProvider;

  const ProfileContent({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              profilePic: authProvider.profilePic,
            ),
            const SizedBox(height: 20),
            ClockInSection(employeeId: authProvider.employeeId),
          ],
        ),
      ),
    );
  }
}
