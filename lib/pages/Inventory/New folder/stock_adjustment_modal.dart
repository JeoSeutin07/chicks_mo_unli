import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockAdjustmentModal extends StatefulWidget {
  final String itemId;
  final double currentStock;

  const StockAdjustmentModal({
    Key? key,
    required this.itemId,
    required this.currentStock,
  }) : super(key: key);

  @override
  _StockAdjustmentModalState createState() => _StockAdjustmentModalState();
}

class _StockAdjustmentModalState extends State<StockAdjustmentModal> {
  late TextEditingController _stockController;
  String _action = 'restock';

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController();
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _updateStock() async {
    if (_stockController.text.isEmpty) return;

    double adjustmentAmount = double.parse(_stockController.text);
    double newStock = _action == 'restock'
        ? widget.currentStock + adjustmentAmount
        : widget.currentStock - adjustmentAmount;

    try {
      await FirebaseFirestore.instance
          .collection('inventory')
          .doc(widget.itemId)
          .update({
        'currentStock': newStock,
        'restockHistory': FieldValue.arrayUnion([
          {
            'date': DateTime.now().toIso8601String(),
            'restockAmount': adjustmentAmount,
            'startingStock': widget.currentStock,
            'newStock': newStock,
            'action': _action,
            'changedBy': 'currentUser', // Replace with actual user ID
          }
        ]),
      });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating stock: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adjust Stock'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _action,
            items: [
              DropdownMenuItem(value: 'restock', child: Text('Restock')),
              DropdownMenuItem(value: 'consume', child: Text('Consume')),
            ],
            onChanged: (String? value) {
              if (value != null) {
                setState(() => _action = value);
              }
            },
          ),
          TextField(
            controller: _stockController,
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount to ${_action}',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateStock,
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
