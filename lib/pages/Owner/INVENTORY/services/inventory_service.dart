import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventory_item.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<InventoryItem>> getInventoryItems(String category,
      {bool archived = false}) {
    return _firestore
        .collection(category)
        .where('isArchived', isEqualTo: archived)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryItem.fromFirestore(doc))
            .toList());
  }

  Future<void> addInventoryItem(InventoryItem item) async {
    await _firestore.collection(item.category).add(item.toMap());
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    await _firestore
        .collection(item.category)
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> archiveInventoryItem(String itemId, String category) async {
    await _firestore
        .collection(category)
        .doc(itemId)
        .update({'isArchived': true});
  }

  Future<void> restoreInventoryItem(String itemId, String category) async {
    await _firestore
        .collection(category)
        .doc(itemId)
        .update({'isArchived': false});
  }
}
