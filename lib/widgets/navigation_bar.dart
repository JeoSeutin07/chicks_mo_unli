import 'package:flutter/material.dart';
import '../pages/orders_kitchen_screen.dart'; // Import the OrdersKitchenScreen

<<<<<<<<< Temporary merge branch 1
class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

=========
class NavigationBar extends StatefulWidget {
  final Function(int) onNavItemTapped;
  final int activeIndex;

  const NavigationBar(
      {super.key, required this.onNavItemTapped, required this.activeIndex});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
>>>>>>>>> Temporary merge branch 2
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(10),
<<<<<<<<< Temporary merge branch 1
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, 'Order', Icons.shopping_cart,
              const OrdersKitchenScreen()),
          _buildNavItem(context, 'Inventory', Icons.inventory, null),
          _buildNavItem(context, 'Cash Flow', Icons.attach_money, null),
          _buildNavItem(context, 'Owner', Icons.person, null),
          _buildNavItem(context, 'Profile', Icons.account_circle, null),
=========
      color: const Color(0xFFFFF3CB), // Set the background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('Order', Icons.shopping_cart, 0),
          _buildNavItem('Inventory', Icons.inventory, 1),
          _buildNavItem('Cash Flow', Icons.attach_money, 2),
          _buildNavItem('Owner', Icons.person, 3),
          _buildNavItem('Profile', Icons.account_circle, 4),
>>>>>>>>> Temporary merge branch 2
        ],
      ),
    );
  }

<<<<<<<<< Temporary merge branch 1
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
=========
  Widget _buildNavItem(String label, IconData iconData, int index) {
    return GestureDetector(
      onTap: () => widget.onNavItemTapped(index),
>>>>>>>>> Temporary merge branch 2
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
<<<<<<<<< Temporary merge branch 1
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF81807E),
              fontSize: 14,
=========
            color: widget.activeIndex == index
                ? Colors.black
                : const Color(0xFF81807E),
          ),
          Text(
            label,
            style: TextStyle(
              color: widget.activeIndex == index
                  ? Colors.black
                  : const Color(0xFF81807E),
>>>>>>>>> Temporary merge branch 2
            ),
          ),
        ],
      ),
    );
  }
}
