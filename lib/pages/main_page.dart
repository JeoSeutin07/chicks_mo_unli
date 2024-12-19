import 'package:chicks_mo_unli/pages/Inventory/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_bar.dart' as custom;
import '../providers/auth_provider.dart';
import 'Owner/owner_page.dart';
import 'Cash_Flow/Cash_Flow.dart';
import 'profile_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_page.dart'; // Import AuthPage for navigation
import '../widgets/header.dart';
import 'package:chicks_mo_unli/order_kitchen/orders_kitchen_screen.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool hasPermission = false;

    switch (index) {
      case 0:
        hasPermission = authProvider.order;
        if (hasPermission) {
          return const OrdersKitchenScreen();
        }
        break;
      case 1:
        hasPermission = authProvider.stock;
        if (hasPermission) {
          return InventoryTracker();
        }
        break;
      case 2:
        hasPermission = authProvider.cashflow;
        if (hasPermission) {
          return DashboardScreen();
        }
        break;
      case 3:
        hasPermission = authProvider.admin;
        if (hasPermission) {
          return OwnerDashboard();
        }
        break;
      case 4:
      default:
        return const ProfilePage();
    }

    if (!hasPermission) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text(
                  'You cannot access this page. Contact the Owner for more information.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }

    return const ProfilePage();
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
      appBar: AppBar(
        toolbarHeight: 35,
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF3CB),
        title: Text(
          _getPageTitle(_activeIndex),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFFFFF3CB),
        ),
        child: Column(
          children: [
            Container(
              child: ProfileHeader(
                userName: authProvider.name,
                //employeeId: authProvider.employeeId,
                //clockedIn: authProvider.clockedIn,
              ),
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
