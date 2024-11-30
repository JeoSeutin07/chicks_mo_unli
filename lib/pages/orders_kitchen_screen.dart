import 'package:flutter/material.dart';
import 'widgets/header_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/tickets_widget.dart';
import 'widgets/menu_tabs_widget.dart';
import '../widgets/navigation_bar.dart' as custom;

class OrdersKitchenScreen extends StatelessWidget {
  const OrdersKitchenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderWidget(),
              const SearchBarWidget(),
              const TicketsWidget(),
              const MenuTabsWidget(),
              custom
                  .NavigationBar(), // Assuming NavigationBar is not a const constructor
            ],
          ),
        ),
      ),
    );
  }
}
