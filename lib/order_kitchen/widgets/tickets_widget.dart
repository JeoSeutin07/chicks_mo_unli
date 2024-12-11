import 'package:flutter/material.dart';
import 'package:chicks_mo_unli/order_kitchen/widgets/menu_tabs_widget.dart';

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
  const TicketsWidget({super.key});

  @override
  State<TicketsWidget> createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  List<Order> orders = [];
  int currentTableNumber = 1;
  List<MenuItem> selectedItems = [];

  void addOrder(List<MenuItem> items) {
    setState(() {
      orders.add(Order(
        tableNumber: currentTableNumber++,
        items: items,
        timestamp: DateTime.now(),
      ));
      selectedItems.clear(); // Clear selected items after adding order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Orders and Kitchen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'On-Going Tickets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...orders.map((order) => OrderTicket(order: order)).toList(),
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
        title: Text('Table #$currentTableNumber Order'),
        content: Container(
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
              addOrder(selectedItems);
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
      width: 120,
      margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFBD663),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Table #${order.tableNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...order.items
              .map((item) =>
                  Text(item.title, style: const TextStyle(fontSize: 12)))
              .toList(),
        ],
      ),
    );
  }
}
