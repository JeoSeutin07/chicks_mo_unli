import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadMenuToFirestore extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Menu Data
  final Map<String, dynamic> menuData = {
    "eat_all_you_can": {
      "unlimited_drummets_rice_drinks": {
        "price": 249,
        "description": "Unlimited drummets served with rice and drinks.",
        "sku": "EAYC001",
        "category": "Eat All You Can",
        "stock_usage": {"drummets": 6, "rice": 1, "drinks": 1},
        "image": "url/to/image1.jpg"
      },
      "unlimited_wings_rice_drinks": {
        "price": 289,
        "description": "Unlimited wings served with rice and drinks.",
        "sku": "EAYC002",
        "category": "Eat All You Can",
        "stock_usage": {"wings": 6, "rice": 1, "drinks": 1},
        "image": "url/to/image2.jpg"
      },
    },
    "refills": {
      "wings": {
        "available": true,
        "description": "Refill for wings.",
        "sku": "RF001",
        "category": "Refills",
        "stock_usage": {"wings": 6},
        "image": "url/to/refill-wings.jpg"
      },
      "rice": {
        "available": true,
        "description": "Additional rice refill.",
        "sku": "RF003",
        "category": "Refills",
        "stock_usage": {"rice": 1},
        "image": "url/to/refill-rice.jpg"
      }
    },
    "add_ons": {
      "rice": {
        "price": 25,
        "description": "Additional serving of rice.",
        "sku": "AO001",
        "category": "Add Ons",
        "stock_usage": {"rice": 1},
        "image": "url/to/add-rice.jpg"
      },
      "extra_dip": {
        "price": 25,
        "description": "Extra dip for your wings.",
        "sku": "AO002",
        "category": "Add Ons",
        "stock_usage": {"dip": 1},
        "image": "url/to/extra-dip.jpg"
      }
    }
  };

  // Function to upload menu data to Firestore
  Future<void> uploadMenu() async {
    try {
      // Iterate through top-level categories
      for (String category in menuData.keys) {
        final subCollectionRef =
            _firestore.collection('menu').doc(category).collection('items');

        // Iterate through items within each category
        final Map<String, dynamic> items = menuData[category];
        for (String itemName in items.keys) {
          final Map<String, dynamic> itemData = items[itemName];
          await subCollectionRef.doc(itemName).set(itemData);
        }
      }

      print("Menu uploaded to Firestore with subcollections!");
    } catch (e) {
      print("Error uploading menu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Menu to Firestore"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await uploadMenu();
          },
          child: const Text("Upload Menu"),
        ),
      ),
    );
  }
}
