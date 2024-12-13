import 'package:flutter/material.dart';
import 'menu_tabs_widget.dart';

class Order {
  final int tableNumber;
  final List<MenuItem> items;
  final DateTime timestamp;

  Order({
    required this.tableNumber,
    required this.items,
    required this.timestamp,
  });
}

class TicketsWidget extends StatefulWidget {
  final List<Order> orders;
  final int currentTableNumber;
  final Function(List<MenuItem>) onAddOrder;

  const TicketsWidget({
    super.key,
    required this.orders,
    required this.currentTableNumber,
    required this.onAddOrder,
  });

  @override
  State<TicketsWidget> createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  List<MenuItem> selectedItems = [];

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
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Material(
                    color: const Color(0xFFFBD663),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => showOrderDialog(context),
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
                    .map((order) => OrderTicket(order: order))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table #${widget.currentTableNumber} Order'),
        content: SizedBox(
          width: double.maxFinite,
          child: MenuTabContent(
            onItemSelected: (item) {
              setState(() {
                selectedItems.add(item);
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onAddOrder(selectedItems);
              selectedItems.clear();
              Navigator.pop(context);
            },
            child: const Text('Create Order'),
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
        color: const Color(0xFFFBD663),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Table #${order.tableNumber}',
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.timestamp.hour.toString().padLeft(2, '0')}:${order.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ...order.items
                  .map((item) => Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Inter',
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
