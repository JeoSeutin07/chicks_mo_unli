import 'package:flutter/material.dart';
import 'tickets_widget.dart';
import 'menu_tabs_widget.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  final VoidCallback onSendToKitchen;
  final VoidCallback onRefill; // Add this line

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.onSendToKitchen,
    required this.onRefill, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat =
        DateFormat('MM/dd/yyyy hh:mm a'); // Define date format
    final String formattedDate =
        dateFormat.format(order.timestamp); // Format the timestamp

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 248, 148, 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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
                formattedDate, // Use formatted date
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(121, 123, 126, 1),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                DateFormat('hh:mm a')
                    .format(order.timestamp), // Display time in 12-hour format
                style: const TextStyle(
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
            order.orderType, // Ensure this line is present
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
              .map((item) => Column(
                    children: [
                      OrderItem(
                        itemName: item.title,
                        quantity: item.quantity.toString(),
                        price: item.price.toString(),
                      ),
                      if (item.flavors.isNotEmpty ||
                          (item.drinkType != null &&
                              item.drinkType!.isNotEmpty))
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Flavors: ${item.flavors.join(', ')}${item.drinkType != null && item.drinkType!.isNotEmpty ? ' | Drink: ${item.drinkType}' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              color: Colors.black54,
                            ),
                          ),
                        ),
                    ],
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
              onPressed: () {
                if (order.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Cannot send an empty order to the kitchen.'),
                    ),
                  );
                } else {
                  onSendToKitchen();
                }
              },
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
          const SizedBox(height: 7),
          Center(
            child: ElevatedButton(
              onPressed: () => _handleRefill(context),
              child: const Text(
                'Refill',
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
    );
  }

  void _handleRefill(BuildContext context) {
    onRefill();
    Navigator.pop(context);
  }

  void showFlavorDialog(BuildContext context, String flavor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Flavor for $flavor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Buffalo'),
              onTap: () {
                Navigator.pop(context, 'Buffalo');
              },
            ),
            ListTile(
              title: const Text('BBQ'),
              onTap: () {
                Navigator.pop(context, 'BBQ');
              },
            ),
            ListTile(
              title: const Text('Garlic Parmesan'),
              onTap: () {
                Navigator.pop(context, 'Garlic Parmesan');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
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
    return Column(
      children: [
        Row(
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
        ),
      ],
    );
  }
}
