import 'package:flutter/material.dart';
import '../pages/orders_kitchen_screen.dart'; // Import the OrdersKitchenScreen

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, 'Order', Icons.shopping_cart,
              const OrdersKitchenScreen()),
          _buildNavItem(context, 'Inventory', Icons.inventory, null),
          _buildNavItem(context, 'Cash Flow', Icons.attach_money, null),
          _buildNavItem(context, 'Owner', Icons.person, null),
          _buildNavItem(context, 'Profile', Icons.account_circle, null),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String label, IconData iconData, Widget? screen) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF81807E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
