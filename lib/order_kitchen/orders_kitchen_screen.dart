import 'package:flutter/material.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/menu_tabs_widget.dart';

class OrdersKitchenScreen extends StatelessWidget {
  const OrdersKitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(),
            Expanded(
              child: const MenuTabsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
