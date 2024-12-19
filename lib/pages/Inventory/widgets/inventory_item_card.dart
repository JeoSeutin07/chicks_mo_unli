import 'package:flutter/material.dart';

enum StockLevel { low, moderate, high }

class InventoryItemCard extends StatelessWidget {
  final String name;
  final StockLevel stockLevel;
  final int startingStock;
  final int restock;
  final int totalStock;
  final int remainingStock;
  final bool isPerishable;

  const InventoryItemCard({
    Key? key,
    required this.name,
    required this.stockLevel,
    required this.startingStock,
    required this.restock,
    required this.totalStock,
    required this.remainingStock,
    required this.isPerishable,
  }) : super(key: key);

  Color _getStockColor() {
    double stockPercentage = remainingStock / totalStock;
    if (stockPercentage >= 0.75) {
      return Color(0xFFA1D8A6); // High
    } else if (stockPercentage >= 0.25) {
      return Color(0xFFFFA500); // Moderate
    } else {
      return Color(0xFFE74C3C); // Low
    }
  }

  void _showAuditModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:
              Colors.transparent, // Makes it appear like an overlay
          child: InventoryItemCard(
            name: name, // Replace with dynamic values as needed
            stockLevel: stockLevel,
            startingStock: startingStock,
            restock: restock,
            totalStock: totalStock,
            remainingStock: remainingStock,
            isPerishable: isPerishable,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double stockPercentage = remainingStock / totalStock;
    return GestureDetector(
      onTap: () => _showAuditModal(context),
      child: Container(
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
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: stockPercentage.clamp(
                            0.0, 1.0), // Ensure value is between 0 and 1
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_getStockColor()),
                      ),
                      SizedBox(height: 8),
                      Text('Starting Stock: ${startingStock}kg'),
                      Text('Restock: ${restock}kg'),
                      Text('Total Stock: ${totalStock}kg'),
                      Text('Remaining Stock: ${remainingStock}kg'),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEF00),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Adjust'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
