import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemCard({Key? key, required this.item}) : super(key: key);

  Color _getStockColor() {
    switch (item.stockLevel) {
      case StockLevel.high:
        return Color(0xFFA1D8A6);
      case StockLevel.moderate:
        return Color(0xFFFFA500);
      case StockLevel.low:
        return Color(0xFFE74C3C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3CB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getStockColor(),
          width: 5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Color(0xFFFFF55E),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (item.remainingStock / item.totalStock).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(_getStockColor()),
                ),
                SizedBox(height: 8),
                Text('Starting Stock: ${item.startingStock}kg'),
                Text('Restock: ${item.restock}kg'),
                Text('Total Stock: ${item.totalStock}kg'),
                Text('Remaining Stock: ${item.remainingStock}kg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}