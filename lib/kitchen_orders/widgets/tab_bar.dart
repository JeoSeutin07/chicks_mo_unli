import 'package:flutter/material.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          _buildTab('Menu', true),
          _buildTab('Queue', false),
          _buildTab('Served', true),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isInactive) {
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isInactive 
            ? const Color(0xFFFFF894) 
            : const Color(0xFFFFF55E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}