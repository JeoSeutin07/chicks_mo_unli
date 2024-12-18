import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/products.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(String category, Product product) async {
    print('Adding product to category: $category');
    final categoryRef = _firestore.collection('menu').doc(category);
    final categorySnapshot = await categoryRef.get();

    if (!categorySnapshot.exists) {
      await categoryRef.set({'name': category});
      print('Category created: $category');
    }

    await categoryRef.collection('items').add(product.toMap());
    print('Product added: ${product.toMap()}');
  }

  Future<void> updateProduct(
      String category, String productId, Product product) async {
    print('Updating product in category: $category with ID: $productId');
    final categoryRef = _firestore.collection('menu').doc(category);
    final categorySnapshot = await categoryRef.get();

    if (!categorySnapshot.exists) {
      await categoryRef.set({'name': category});
      print('Category created: $category');
    }

    await categoryRef
        .collection('items')
        .doc(productId)
        .update(product.toMap());
    print('Product updated: ${product.toMap()}');
  }

  Future<void> archiveProduct(
      String category, String productId, Product product) async {
    print('Archiving product in category: $category with ID: $productId');
    final batch = _firestore.batch();

    final archiveRef = _firestore
        .collection('archiveMenu')
        .doc(category)
        .collection('items')
        .doc(productId);

    final originalRef = _firestore
        .collection('menu')
        .doc(category)
        .collection('items')
        .doc(productId);

    batch.set(archiveRef, product.toMap());
    batch.delete(originalRef);

    await batch.commit();
    print('Product archived: ${product.toMap()}');
  }

  Stream<QuerySnapshot> getCategoryProducts(String category) {
    print('Getting products for category: $category');
    return _firestore
        .collection('menu')
        .doc(category)
        .collection('items')
        .snapshots();
  }

  Stream<QuerySnapshot> getCategories() {
    print('Getting all categories');
    return _firestore.collection('menu').snapshots().map((snapshot) {
      print(
          'Categories snapshot: ${snapshot.docs.map((doc) => doc.data()).toList()}');
      return snapshot;
    });
  }

  Future<List<String>> getCategorySuggestions(String pattern) async {
    QuerySnapshot snapshot = await _firestore
        .collection('menu')
        .where('name', isGreaterThanOrEqualTo: pattern)
        .get();

    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<void> deleteCategory(String category) async {
    print('Deleting category: $category');
    final categoryRef = _firestore.collection('menu').doc(category);
    final categorySnapshot = await categoryRef.get();

    if (categorySnapshot.exists) {
      final batch = _firestore.batch();

      final itemsSnapshot = await categoryRef.collection('items').get();
      for (var doc in itemsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(categoryRef);
      await batch.commit();
      print('Category deleted: $category');
    } else {
      print('Category does not exist: $category');
    }
  }
}
