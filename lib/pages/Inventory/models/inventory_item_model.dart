import 'package:flutter/material.dart';

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
      downStock: data['downStock'] ?? 0,
    );
  }

  /// Dynamically calculate stock percentage
  double get stockPercentage {
    return (remainingStock / totalStock).clamp(0.0, 1.0);
  }

  /// Dynamically determine the stock color
  Color get stockColor {
    if (stockPercentage >= 0.75) {
      return Color(0xFFA1D8A6); // High Stock - Green
    } else if (stockPercentage >= 0.25) {
      return Color(0xFFFFA500); // Moderate Stock - Orange
    } else {
      return Color(0xFFE74C3C); // Low Stock - Red
    }
  }

  /// Determine the stock level dynamically
  String get stockLevel {
    if (stockPercentage >= 0.75) {
      return 'High';
    } else if (stockPercentage >= 0.25) {
      return 'Moderate';
    } else {
      return 'Low';
    }
  }
}
