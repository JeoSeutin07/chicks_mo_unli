import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF894),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order #',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Table #1',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'dd mmm yyyy, 00:00 tt',
            style: TextStyle(
              color: Color(0xFF797B7E),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Dine in',
            style: TextStyle(
              color: Color(0xFF797B7E),
              fontSize: 12,
            ),
          ),
          const Divider(),
          _buildOrderItem('Item', 'Qty.', isHeader: true),
          _buildOrderItem('UnDrumRiDri', '3'),
          _buildOrderItem('American Mustard', '1'),
          _buildOrderItem('Barbeque', '1'),
          _buildOrderItem('Buffalo Wing', '1'),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEF00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Serve',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String quantity, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: isHeader ? 12 : 12,
              fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          Text(
            quantity,
            style: TextStyle(
              fontSize: isHeader ? 12 : 12,
              fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}