// File: lib/pages/inventory/model/inventory_item_model.dart
class InventoryItemModel {
  final String name;
  final bool isPerishable;
  final int startingStock;
  final int restock;
  final int totalStock;
  final int remainingStock;
  final int upStock;
  final int downStock;

  InventoryItemModel({
    required this.name,
    required this.isPerishable,
    required this.startingStock,
    required this.restock,
    required this.totalStock,
    required this.remainingStock,
    required this.upStock,
    required this.downStock,
  });

  /// Factory method to create model from Firestore data
  factory InventoryItemModel.fromFirestore(Map<String, dynamic> data) {
    return InventoryItemModel(
      name: data['name'] ?? '',
      isPerishable: data['isPerishable'] ?? false,
      startingStock: data['startingStock'] ?? 0,
      restock: data['restock'] ?? 0,
      totalStock: data['totalStock'] ?? 0,
      remainingStock: data['remainingStock'] ?? 0,
      upStock: data['upStock'] ?? 0,
      downStock: data['downsStock'] ?? 0,
    );
  }

  /// Determine the stock level dynamically
  String get stockLevel {
    if (remainingStock > upStock) {
      return 'High';
    } else if (remainingStock < downStock) {
      return 'Low';
    } else {
      return 'Moderate';
    }
  }
}
