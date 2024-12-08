import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: Color(0xFF81807E),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF81807E),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
