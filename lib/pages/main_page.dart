import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_bar.dart' as custom;
import '../providers/auth_provider.dart';
import 'order_page.dart';
import 'inventory_page.dart';
import 'cash_flow_page.dart';
import 'owner_page.dart';
import 'profile_page.dart';
import '../widgets/profile_header.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
        return const OrderPage();
      case 1:
        return const InventoryPage();
      case 2:
        return const CashFlowPage();
      case 3:
        return const OwnerPage();
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
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFFFFF3CB),
        ),
        child: Column(
          children: [
            ProfileHeader(userName: authProvider.name),
            PageTitle(title: _getPageTitle(_activeIndex)),
            Expanded(
              child: Container(
                color: const Color(
                    0xFFFFF3CB), // Set the background color to match the navigation bar
                child: _getPage(_activeIndex),
              ),
            ),
            custom.NavigationBar(
              activeIndex: _activeIndex,
              onNavItemTapped: _onNavItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}
