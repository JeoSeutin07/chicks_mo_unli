import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  final String itemName;
  final double startingStock;
  final double restock;
  final double totalStock;
  final double remainingStock;
  final VoidCallback onAddStock;
  final VoidCallback onEndInventory;
  final VoidCallback onCancel;

  const InventoryCard({
    Key? key,
    required this.itemName,
    required this.startingStock,
    required this.restock,
    required this.totalStock,
    required this.remainingStock,
    required this.onAddStock,
    required this.onEndInventory,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 31, 17, 96),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF5F2EC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStockDetails(),
          const SizedBox(height: 37),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Build stock details section
  Widget _buildStockDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE8E9F1),
            ),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF15CCCC),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Starting Stock: ${startingStock}kg',
            style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 5),
          Text(
            'Restock: ${restock}kg',
            style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 5),
          Text(
            'Total Stock: ${totalStock}kg',
            style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 5),
          Text(
            'Remaining Stock: ${remainingStock}kg',
            style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Center(
      child: SizedBox(
        width: 136,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: onAddStock,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEF00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(3),
              ),
              child: const Text(
                'Add Stock',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 11),
            ElevatedButton(
              onPressed: onEndInventory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(3),
              ),
              child: const Text(
                'End Inventory',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 11),
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(3),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
