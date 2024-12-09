import 'package:flutter/material.dart';
// Removed unused import

class NavigationBar extends StatefulWidget {
  final Function(int) onNavItemTapped;
  final int activeIndex;


  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFFFF3CB), // Set the background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('Order', Icons.shopping_cart, 0),
          _buildNavItem('Inventory', Icons.inventory, 1),
          _buildNavItem('Cash Flow', Icons.attach_money, 2),
          _buildNavItem('Owner', Icons.person, 3),
          _buildNavItem('Profile', Icons.account_circle, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData iconData, int index) {
    return GestureDetector(
      onTap: () => widget.onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
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
            ),
          ),
        ],
      ),
    );
  }
}
