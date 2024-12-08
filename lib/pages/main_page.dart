import 'package:chicks_mo_unli/pages/Inventory/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_bar.dart' as custom;
import '../providers/auth_provider.dart';
import '../pages/orders_kitchen_screen.dart'; // Import the OrdersKitchenScreen
import 'Owner/owner_page.dart';
import 'Cash_Flow/Cash_Flow.dart';
import 'profile_page.dart';
import '../widgets/profile_header.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // Remove border for debugging
          ),
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // Adjust padding
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14, // Set the font size to 14px
          fontWeight: FontWeight.normal, // Remove bold font weight
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _activeIndex = 4;

  void _onNavItemTapped(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const OrdersKitchenScreen();
      case 1:
        return InventoryTracker();
      case 2:
        return DashboardScreen();
      case 3:
        return OwnerDashboard();
      case 4:
      default:
        return const ProfilePage();
    }
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Order Page';
      case 1:
        return 'Inventory Page';
      case 2:
        return 'Cash Flow Page';
      case 3:
        return 'Owner Page';
      case 4:
      default:
        return 'Profile Page';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Remove border for debugging
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFFFFF3CB),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  // Remove border for debugging
                  ),
              child: ProfileHeader(userName: authProvider.name),
            ),
            Container(
              decoration: BoxDecoration(
                  // Remove border for debugging
                  ),
              child: PageTitle(title: _getPageTitle(_activeIndex)),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // Remove border for debugging
                  color: const Color(0xFFFFF3CB),
                ),
                child: _getPage(_activeIndex),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  // Remove border for debugging
                  ),
              child: custom.NavigationBar(
                activeIndex: _activeIndex,
                onNavItemTapped: _onNavItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
