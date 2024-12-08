import 'package:flutter/material.dart';
import 'widgets/employee_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/tickets_widget.dart';
import 'widgets/menu_tabs_widget.dart';
import '../widgets/navigation_bar.dart' as custom;

class OrdersKitchenScreen extends StatelessWidget {
  const OrdersKitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmployeeHeader(
                employeeName: 'John Doe', // Example employee name
                currentTime: DateTime.now(), // Current time
              ),
              const SearchBarWidget(),
              const TicketsWidget(),
              const MenuTabsWidget(),
              const custom
                  .NavigationBar(), // Assuming NavigationBar is not a const constructor
            ],
          ),
        ),
      ),
    );
  }
}
