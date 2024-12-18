import 'package:flutter/material.dart';
import 'dart:async'; // Add this import for Timer
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
  final Function(int) onSelectTable;
  final Function(Order) onSendToQueue;

  const TicketsWidget({
    super.key,
    required this.orders,
    required this.onAddOrder,
    required this.onSelectTable,
    required this.onSendToQueue,
  });

  @override
  State<TicketsWidget> createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  String selectedOrderType = 'Dine In';
  int currentTableNumber = 1;
  int? activeTableNumber;
  Timer? _timer;
  Map<Order, Stopwatch> orderTimers = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          order: order,
          onSendToKitchen: () {
            widget.onSendToQueue(order);
            orderTimers[order] = Stopwatch()..start();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  String _formatElapsedTime(Order order) {
    final timer = orderTimers[order];
    if (timer == null || !timer.isRunning) {
      return '00:00';
    }
    final duration = timer.elapsed;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Material(
                    color: const Color(0xFFE02C34),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => showOrderTypeDialog(context),
                      borderRadius: BorderRadius.circular(8),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Create Table',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                ...widget.orders
                    .map((order) => GestureDetector(
                          onTap: () =>
                              switchTable(order.tableNumber, order.orderType),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: OrderTicket(
                              order: order,
                              isSelected:
                                  activeTableNumber == order.tableNumber &&
                                      selectedOrderType == order.orderType,
                              onDetailsTap: () => navigateToOrderDetails(order),
                              elapsedTime: _formatElapsedTime(order),
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
        backgroundColor: const Color(0xFFFFF3CB),
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
                    ? const Color(0xFFFBD663)
                    : const Color(0xFFFFF894),
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
                    ? const Color(0xFFFBD663)
                    : const Color(0xFFFFF894),
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
        backgroundColor: const Color(0xFFFFF3CB),
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
        backgroundColor: const Color(0xFFFFF3CB),
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

  void addOrder(int tableNumber, String orderType) {
    setState(() {
      if (!widget.orders.any((order) =>
          order.tableNumber == tableNumber && order.orderType == orderType)) {
        widget.orders.add(Order(
          tableNumber: tableNumber,
          items: [],
          timestamp: DateTime.now(),
          orderType: orderType,
        ));
      }
    });
  }
}

class OrderTicket extends StatelessWidget {
  final Order order;
  final bool isSelected;
  final VoidCallback onDetailsTap;
  final String elapsedTime;

  const OrderTicket({
    super.key,
    required this.order,
    this.isSelected = false,
    required this.onDetailsTap,
    required this.elapsedTime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetailsTap,
      child: Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromRGBO(251, 214, 99, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              order.orderType == 'Takeout'
                  ? 'Takeout #${order.tableNumber}'
                  : 'Table #${order.tableNumber}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              elapsedTime,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '--Assign Table Number--',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.14,
            ),
            textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
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
