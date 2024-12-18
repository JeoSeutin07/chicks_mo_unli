import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String sku;
  final String category;
  final String description;
  final int price;
  final Map<String, int> stockUsage;
  final String image;
  final bool available;

  Product({
    required this.id,
    required this.sku,
    required this.category,
    required this.description,
    required this.price,
    required this.stockUsage,
    required this.image,
    this.available = true,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      sku: data['sku'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      price:
          (data['price'] is int) ? data['price'] : (data['price'] ?? 0).toInt(),
      stockUsage: Map<String, int>.from(data['stock_usage'] ?? {}),
      image: data['image'] ?? '',
      available: data['available'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sku': sku,
      'category': category,
      'description': description,
      'price': price,
      'stock_usage': stockUsage,
      'image': image,
      'available': available,
    };
  }
}
