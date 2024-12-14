import 'package:flutter/material.dart';
import 'menu_tabs_widget.dart';
import 'order_details_screen.dart';

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
  int? activeTableNumber;

  void navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          order: order,
          onSendToKitchen: () {},
        ),
      ),
    );
  }

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
          const SizedBox(height: 5), // Adjusted spacing
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 5), // Adjusted horizontal margin
                  child: Material(
                    color: const Color(
                        0xFFE02C34), // Updated color to match branding
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
                            fontWeight:
                                FontWeight.w600, // Slightly bolder font weight
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5), // Adjusted spacing between buttons
                ...widget.orders
                    .map((order) => GestureDetector(
                          onTap: () =>
                              switchTable(order.tableNumber, order.orderType),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5), // Adjusted horizontal margin
                            child: OrderTicket(
                              order: order,
                              isSelected:
                                  activeTableNumber == order.tableNumber &&
                                      selectedOrderType == order.orderType,
                              onDetailsTap: () => navigateToOrderDetails(order),
                            ),
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
                showTableNumberDialog(context);
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
                int takeoutNumber = widget.orders
                        .where((order) => order.orderType == 'Takeout')
                        .length +
                    1;
                widget.onAddOrder(takeoutNumber, 'Takeout');
                setState(() {
                  activeTableNumber = takeoutNumber;
                });
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

  void showTableNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3CB), // Set background color
        content: TableNumberPad(
          onConfirm: (tableNumber) {
            if (tableNumber == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid table number.'),
                ),
              );
              return;
            }
            if (widget.orders.any((order) =>
                order.tableNumber == tableNumber &&
                order.orderType == 'Dine In')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Table #$tableNumber already exists for Dine In.'),
                ),
              );
              return;
            }
            setState(() {
              activeTableNumber = tableNumber;
            });
            widget.onAddOrder(tableNumber, selectedOrderType);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void switchTable(int tableNumber, String orderType) {
    setState(() {
      activeTableNumber = tableNumber;
      selectedOrderType = orderType;
    });
  }

  void showOrderSummaryDialog(BuildContext context, Order order) {
    if (activeTableNumber != null &&
        (activeTableNumber != order.tableNumber ||
            selectedOrderType != order.orderType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'You can only order for ${selectedOrderType == 'Takeout' ? 'Takeout #' : 'Table #'}$activeTableNumber'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3CB), // Set background color
        title: Text(
            'Order Summary for ${order.orderType == 'Takeout' ? 'Takeout #' : 'Table #'}${order.tableNumber}'),
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
  final bool isSelected;
  final VoidCallback onDetailsTap;

  const OrderTicket({
    super.key,
    required this.order,
    this.isSelected = false,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: isSelected
            ? const Color(0xFFE02C34)
            : const Color(0xFFFF5E5E), // Change color if selected
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onDetailsTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align the content
              children: [
                Text(
                  order.orderType == 'Takeout'
                      ? 'Takeout #${order.tableNumber}'
                      : 'Table #${order.tableNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (order.orderType == 'Dine In')
                  Text(
                    'Dine In',
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
      ),
    );
  }
}

class TableNumberPad extends StatefulWidget {
  final Function(int) onConfirm;

  const TableNumberPad({super.key, required this.onConfirm});

  @override
  _TableNumberPadState createState() => _TableNumberPadState();
}

class _TableNumberPadState extends State<TableNumberPad> {
  String displayValue = '0';

  void _updateDisplay(String value) {
    setState(() {
      if (displayValue == '0') {
        displayValue = value;
      } else {
        displayValue += value;
      }
    });
  }

  void _confirm() {
    widget.onConfirm(int.parse(displayValue));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromRGBO(255, 243, 203, 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center align the content
        children: [
          const Text(
            '--Assign Table Number--',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.14,
            ),
            textAlign: TextAlign.center, // Center align the text
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromRGBO(255, 248, 148, 0.98),
            ),
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 0.14,
              ),
              textAlign: TextAlign.center, // Center align the text
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              _buildNumberRow(['1', '2', '3']),
              const SizedBox(height: 10),
              _buildNumberRow(['4', '5', '6']),
              const SizedBox(height: 10),
              _buildNumberRow(['7', '8', '9']),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNumberButton('0'),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        displayValue = displayValue.length > 1
                            ? displayValue.substring(0, displayValue.length - 1)
                            : '0';
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(255, 243, 203, 1),
                      ),
                      child: const Icon(Icons.backspace, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _confirm,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(255, 239, 0, 1),
              ),
              child: const Text(
                'Confirm',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: numbers.map((number) => _buildNumberButton(number)).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _updateDisplay(number),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromRGBO(255, 243, 203, 1),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 14,
            letterSpacing: 0.14,
          ),
        ),
      ),
    );
  }
}
