import 'package:chicks_mo_unli/pages/Inventory/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_bar.dart' as custom;
import '../providers/auth_provider.dart';
import '../pages/orders_kitchen_screen.dart'; // Import the OrdersKitchenScreen
import 'Owner/owner_page.dart';
import 'Cash_Flow/Cash_Flow.dart';
import 'profile_page.dart';
import '../widgets/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_page.dart'; // Import AuthPage for navigation

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
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
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkEmployeeID();
  }

  Future<void> _checkEmployeeID() async {
    String? employeeID = await _storage.read(key: 'employeeID');
    if (employeeID == null) {
      // If employeeID is not stored, navigate to AuthPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    }
  }

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
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFFFFF3CB),
        ),
        child: Column(
          children: [
            Container(
              child: ProfileHeader(userName: authProvider.name),
            ),
            Container(
              child: PageTitle(title: _getPageTitle(_activeIndex)),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFFFF3CB),
                child: _getPage(_activeIndex),
              ),
            ),
            Container(
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
