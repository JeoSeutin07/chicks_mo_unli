import 'package:chicks_mo_unli/order_kitchen/widgets/tickets_widget.dart';
import 'package:flutter/material.dart';
import 'order_details_screen.dart';

class ServeTabContent extends StatelessWidget {
  final List<Order> orders;
  final Function(Order) onAddToOrder;
  final Function(Order) onCheckOut;

  const ServeTabContent({
    super.key,
    required this.orders,
    required this.onAddToOrder,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFBD663),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26, width: 1),
          ),
          child: OrderCard(
            orderNumber: order.tableNumber.toString(),
            dateTime: order.timestamp.toString(),
            tableNumber: order.tableNumber.toString(),
            orderTime: order.timestamp.toString(),
            items: order.items
                .map((item) => OrderItem(
                      name: item.title,
                      quantity: item.quantity,
                    ))
                .toList(),
            onAddToOrder: () => onAddToOrder(order),
            onCheckOut: () => onCheckOut(order),
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
  final VoidCallback onAddToOrder;
  final VoidCallback onCheckOut;
  final String orderType; // Ensure this line is present

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.dateTime,
    required this.tableNumber,
    required this.orderTime,
    required this.items,
    required this.onAddToOrder,
    required this.onCheckOut,
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
                child: Row(
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
              );
            },
          ),
          const SizedBox(height: 7),
          Center(
            child: ElevatedButton(
              onPressed: onAddToOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 239, 0, 1),
                minimumSize: const Size(154, 21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Add to Order',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Center(
            child: ElevatedButton(
              onPressed: onCheckOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 239, 0, 1),
                minimumSize: const Size(154, 21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Check Out',
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

  const OrderItem({
    required this.name,
    required this.quantity,
  });
}
