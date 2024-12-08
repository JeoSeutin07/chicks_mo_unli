import 'package:flutter/material.dart';
import 'widgets/order_card.dart';
import 'widgets/tab_bar.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/header.dart';

class KitchenOrdersScreen extends StatelessWidget {
  const KitchenOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CB),
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            const OrdersTabBar(),
            Expanded(
              child: Container(
                color: const Color(0xFFFFF55E),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ListView(
                  children: const [
                    OrderCard(),
                    OrderCard(),
                    OrderCard(),
                  ],
                ),
              ),
            ),
            const BottomNav(),
          ],
        ),
      ),
    );
  }
}