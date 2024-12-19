import 'package:flutter/material.dart';
import 'tickets_widget.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class QueueTabContent extends StatelessWidget {
  final List<Order> orders;
  final Function(Order) onServeOrder;
  final Map<Order, Stopwatch> orderTimers; // Add this line

  const QueueTabContent({
    super.key,
    required this.orders,
    required this.onServeOrder,
    required this.orderTimers, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final timer = orderTimers[order]; // Get the timer for the order
        final elapsedTime = timer != null
            ? '${timer.elapsed.inMinutes}:${(timer.elapsed.inSeconds % 60).toString().padLeft(2, '0')}'
            : '00:00'; // Format the elapsed time
        final DateFormat dateFormat =
            DateFormat('MM/dd/yyyy hh:mm a'); // Define date format
        final String formattedDate =
            dateFormat.format(order.timestamp); // Format the timestamp
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFBD663),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26, width: 1),
          ),
          child: OrderCard(
            orderNumber: order.tableNumber.toString(),
            dateTime: formattedDate, // Use formatted date
            tableNumber: order.tableNumber.toString(),
            orderTime: elapsedTime, // Update to use the elapsed time
            items: order.items
                .map((item) => OrderItem(
                      name: item.title,
                      quantity: item.quantity,
                      flavors: item.flavors, // Add this line
                      drinkType: item.drinkType, // Add this line
                    ))
                .toList(),
            onServe: () {
              onServeOrder(order);
            },
            orderType: order.orderType, // Ensure this line is present
          ),
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String dateTime;
  final String tableNumber;
  final String orderTime;
  final List<OrderItem> items;
  final VoidCallback onServe;
  final String orderType; // Ensure this line is present

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.dateTime,
    required this.tableNumber,
    required this.orderTime,
    required this.items,
    required this.onServe,
    required this.orderType, // Ensure this line is present
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBD663),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #$orderNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Table #$tableNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                dateTime,
                style: const TextStyle(
                  color: Color.fromRGBO(121, 123, 126, 1),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                orderTime,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            orderType, // Ensure this line is present
            style: const TextStyle(
              color: Color.fromRGBO(121, 123, 126, 1),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 7),
          const Divider(color: Colors.black12),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Item',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Qty.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          items[index].name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          items[index].quantity.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    if (items[index].flavors.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Flavors: ${items[index].flavors.join(', ')}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    if (items[index].drinkType != null &&
                        items[index].drinkType!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Drink: ${items[index].drinkType}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 7),
          Center(
            child: ElevatedButton(
              onPressed: onServe,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 239, 0, 1),
                minimumSize: const Size(154, 21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Serve',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final List<String> flavors; // Add this line
  final String? drinkType; // Add this line

  const OrderItem({
    required this.name,
    required this.quantity,
    this.flavors = const [], // Add this line
    this.drinkType, // Add this line
  });
}
