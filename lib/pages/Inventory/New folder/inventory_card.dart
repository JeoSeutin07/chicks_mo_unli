import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const InventoryCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  Color _getStockLevelColor() {
    double currentStock = item['currentStock'].toInt();
    double minStock = item['minimumStock'].toInt();
    double maxStock = item['maximumStock'].toInt();

    if (currentStock <= minStock) {
      return Colors.red;
    } else if (currentStock >= maxStock) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  double _getStockPercentage() {
    double currentStock = item['currentStock'].toInt();
    double maxStock = item['maximumStock'].toInt();
    return (currentStock / maxStock).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: _getStockLevelColor(),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: _getStockPercentage(),
                backgroundColor: Colors.grey[200],
                valueColor:
                    AlwaysStoppedAnimation<Color>(_getStockLevelColor()),
              ),
              SizedBox(height: 8),
              Text('Current Stock: ${item['currentStock']} ${item['unit']}'),
              Text('Minimum Stock: ${item['minimumStock']} ${item['unit']}'),
              Text('Maximum Stock: ${item['maximumStock']} ${item['unit']}'),
            ],
          ),
        ),
      ),
    );
  }
}
