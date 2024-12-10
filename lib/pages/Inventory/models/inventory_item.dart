// lib/models/inventory_item.dart

enum StockLevel { low, moderate, high }

class InventoryItem {
  final String name;
  final int startingStock;
  final int restock;
  final int totalStock;
  final int remainingStock;
  final bool isPerishable;
  final StockLevel stockLevel;

  InventoryItem({
    required this.name,
    required this.startingStock,
    required this.restock,
    required this.totalStock,
    required this.remainingStock,
    required this.isPerishable,
    required this.stockLevel,
  });

  // Factory method for creating an instance from JSON
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      name: json['name'],
      startingStock: json['startingStock'],
      restock: json['restock'],
      totalStock: json['totalStock'],
      remainingStock: json['remainingStock'],
      isPerishable: json['isPerishable'],
      stockLevel: _determineStockLevel(json['remainingStock'], json['totalStock']),
    );
  }

  // Method to determine stock level
  static StockLevel _determineStockLevel(int remainingStock, int totalStock) {
    double stockPercentage = remainingStock / totalStock;
    if (stockPercentage >= 0.75) {
      return StockLevel.high;
    } else if (stockPercentage >= 0.25) {
      return StockLevel.moderate;
    } else {
      return StockLevel.low;
    }
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startingStock': startingStock,
      'restock': restock,
      'totalStock': totalStock,
      'remainingStock': remainingStock,
      'isPerishable': isPerishable,
      'stockLevel': stockLevel.toString(), // Save stock level as string
    };
  }
}
