import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('Order', Icons.shopping_cart),
          _buildNavItem('Inventory', Icons.inventory),
          _buildNavItem('Cash Flow', Icons.attach_money),
          _buildNavItem('Owner', Icons.person),
          _buildNavItem('Profile', Icons.account_circle),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData iconData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 24,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF81807E),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
