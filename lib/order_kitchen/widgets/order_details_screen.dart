import 'package:flutter/material.dart';
import 'tickets_widget.dart';
import 'menu_tabs_widget.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  final VoidCallback onSendToKitchen;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.onSendToKitchen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 248, 148, 0.98),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.tableNumber}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Table #${order.tableNumber}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.timestamp}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(121, 123, 126, 1),
                    fontFamily: 'Inter',
                  ),
                ),
                const Text(
                  '00:00',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              order.orderType,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(121, 123, 126, 1),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Item',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Row(
                  children: const [
                    Text(
                      'Qty.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              height: 14,
            ),
            ...order.items
                .map((item) => OrderItem(
                      itemName: item.title,
                      quantity: item.quantity.toString(),
                      price: item.price.toString(),
                    ))
                .toList(),
            const Divider(
              color: Colors.black,
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  order.items
                      .fold(0, (sum, item) => sum + int.parse(item.price))
                      .toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Center(
              child: ElevatedButton(
                onPressed: onSendToKitchen,
                child: const Text(
                  'Send to Kitchen',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 239, 0, 1),
                  minimumSize: const Size(154, 21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String itemName;
  final String quantity;
  final String price;

  const OrderItem({
    super.key,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          itemName,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        Row(
          children: [
            Text(
              quantity,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(width: 29),
            Text(
              price,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
