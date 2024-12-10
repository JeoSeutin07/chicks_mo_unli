import 'package:flutter/material.dart';
import '../models/inventory_item_model.dart';

class StockLegend extends StatelessWidget {
  final List<InventoryItemModel> items;

  const StockLegend({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('StockLegend received items: $items'); // Debug
    
    // Dynamically determine stock states
    final highStock = items.where((item) => item.remainingStock > item.upStock).toList();
    final moderateStock = items.where((item) =>
        item.remainingStock <= item.upStock && item.remainingStock >= item.downStock).toList();
    final lowStock = items.where((item) => item.remainingStock < item.downStock).toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('High Stock', Color(0xFFA1D8A6), highStock.length),
          _buildLegendItem('Moderate Stock', Color(0xFFFFA500), moderateStock.length),
          _buildLegendItem('Low Stock', Color(0xFFE74C3C), lowStock.length),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          '$label ($count)',
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
