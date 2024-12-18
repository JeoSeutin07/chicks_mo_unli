import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_item_card.dart';
import 'services/firebase_services.dart';

class InventoryCategoryCard extends StatefulWidget {
  final String categoryName;
  final FirebaseService firebaseService;

  const InventoryCategoryCard({
    Key? key,
    required this.categoryName,
    required this.firebaseService,
  }) : super(key: key);

  @override
  _InventoryCategoryCardState createState() => _InventoryCategoryCardState();
}

class _InventoryCategoryCardState extends State<InventoryCategoryCard> {
  bool isExpanded = true;

  void _deleteCategory() async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await widget.firebaseService.deleteCategory(widget.categoryName);
      // Optionally, you can show a confirmation message or handle state update here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.categoryName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 24,
                  color: Colors.black,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteCategory,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          StreamBuilder<QuerySnapshot>(
            stream:
                widget.firebaseService.getCategoryProducts(widget.categoryName),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                children: snapshot.data!.docs
                    .map((item) => InventoryItemCard(
                          item: item,
                          category: widget.categoryName,
                          firebaseService: widget.firebaseService,
                        ))
                    .toList(),
              );
            },
          ),
      ],
    );
  }
}
