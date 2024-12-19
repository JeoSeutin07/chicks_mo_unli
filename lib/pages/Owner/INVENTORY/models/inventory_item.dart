import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String description;
  final double minimumStock;
  final double maximumStock;
  final double averagePrice;
  final String unit;
  final bool isArchived;
  final String category;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.minimumStock,
    required this.maximumStock,
    required this.averagePrice,
    required this.unit,
    required this.category,
    this.isArchived = false,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      minimumStock: (data['minimumStock'] ?? 0).toDouble(),
      maximumStock: (data['maximumStock'] ?? 0).toDouble(),
      averagePrice: (data['averagePrice'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'kg',
      category: data['category'] ?? 'Perishable',
      isArchived: data['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'minimumStock': minimumStock,
      'maximumStock': maximumStock,
      'averagePrice': averagePrice,
      'unit': unit,
      'category': category,
      'isArchived': isArchived,
    };
  }

  InventoryItem copyWith({
    String? name,
    String? description,
    double? minimumStock,
    double? maximumStock,
    double? averagePrice,
    String? unit,
    String? category,
    bool? isArchived,
  }) {
    return InventoryItem(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      averagePrice: averagePrice ?? this.averagePrice,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
