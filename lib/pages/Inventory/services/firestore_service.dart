import 'package:cloud_firestore/cloud_firestore.dart';
import '.././models/inventory_item_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch non-perishable inventory items
  Future<List<InventoryItemModel>> fetchNonPerishableItems() async {
    try {
      final snapshot = await _firestore.collection('inventory/items/non-perishables').get();
      
      print("Non-Perishable Items Fetched");

      return snapshot.docs.map((doc) => InventoryItemModel.fromFirestore(doc.data())).toList();
    } catch (e) {
      print('Error fetching non-perishable items: $e');
      return [];
    }
  }

  /// Fetch perishable inventory items
  Future<List<InventoryItemModel>> fetchPerishableItems() async {
    try {
      final snapshot = await _firestore.collection('inventory/items/perishables').get();
      
      print("Perishable Items Fetched");

      return snapshot.docs.map((doc) => InventoryItemModel.fromFirestore(doc.data())).toList();
    } catch (e) {
      print('Error fetching perishable items: $e');
      return [];
    }
  }
}
