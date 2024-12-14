import 'package:flutter/material.dart';
import 'tickets_widget.dart';
import 'menu_tabs_widget.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 248, 148, 0.98),
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
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Table #${order.tableNumber}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.timestamp}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(121, 123, 126, 1),
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
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
            SizedBox(height: 7),
            Text(
              order.orderType,
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(121, 123, 126, 1),
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Row(
                  children: [
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
            Divider(
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
            Divider(
              color: Colors.black,
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  order.items
                      .fold(0, (sum, item) => sum + item.price)
                      .toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Send to Kitchen',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(255, 239, 0, 1),
                  minimumSize: Size(154, 21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 3),
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
    Key? key,
    required this.itemName,
    required this.quantity,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          itemName,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        Row(
          children: [
            Text(
              quantity,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(width: 29),
            Text(
              price,
              style: TextStyle(
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
