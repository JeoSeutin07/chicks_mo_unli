import 'package:flutter/material.dart';
import 'menu_tabs_widget.dart';

class Order {
  final int tableNumber;
  final List<MenuItem> items;
  final DateTime timestamp;
  final String orderType;

  Order({
    required this.tableNumber,
    required this.items,
    required this.timestamp,
    required this.orderType,
  });
}

class TicketsWidget extends StatefulWidget {
  final List<Order> orders;
  final Function(int, String) onAddOrder;

  const TicketsWidget({
    super.key,
    required this.orders,
    required this.onAddOrder,
  });

  @override
  State<TicketsWidget> createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  String selectedOrderType = 'Dine In';
  int currentTableNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'On-Going Tickets',
              style: TextStyle(
                fontSize: 18, // Slightly reduced font size for header
                fontWeight: FontWeight.bold, // Bold font weight for header
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 5), // Add horizontal margin
                  child: Material(
                    color: const Color(
                        0xFFFBD663), // Updated color to match branding
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => showOrderTypeDialog(context),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Create Table',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between buttons
                ...widget.orders
                    .map((order) => GestureDetector(
                          onTap: () => showOrderSummaryDialog(context, order),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5), // Add horizontal margin
                            child: OrderTicket(order: order),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showOrderTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3CB), // Set background color
        title: const Text('Select Order Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedOrderType = 'Dine In';
                });
                Navigator.pop(context);
                widget.onAddOrder(currentTableNumber++, selectedOrderType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOrderType == 'Dine In'
                    ? const Color(0xFFFBD663) // Darker shade when selected
                    : const Color(
                        0xFFFFF894), // Lighter shade when not selected
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Dine In'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedOrderType = 'Takeout';
                });
                Navigator.pop(context);
                widget.onAddOrder(currentTableNumber++, selectedOrderType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOrderType == 'Takeout'
                    ? const Color(0xFFFBD663) // Darker shade when selected
                    : const Color(
                        0xFFFFF894), // Lighter shade when not selected
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Takeout'),
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

  void showOrderSummaryDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3CB), // Set background color
        title: Text('Order Summary for Table #${order.tableNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: order.items
              .map((item) => ListTile(
                    title: Text(item.title),
                    trailing: Text(item.price),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class OrderTicket extends StatelessWidget {
  final Order order;

  const OrderTicket({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: const Color(0xFFFFEF00), // Updated color to match branding
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center align the content
            children: [
              Text(
                'Table #${order.tableNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order.orderType,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
