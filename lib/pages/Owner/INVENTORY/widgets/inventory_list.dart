import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import 'inventory_category.dart';

class InventoryList extends StatefulWidget {
  final bool showArchived;
  final InventoryService inventoryService;

  const InventoryList({
    Key? key,
    required this.showArchived,
    required this.inventoryService,
  }) : super(key: key);

  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  Map<String, bool> expandedCategories = {
    'Perishable': true,
    'Non-Perishable': true,
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        StreamBuilder<List<InventoryItem>>(
          stream: widget.inventoryService.getInventoryItems(
            'Perishable',
            archived: widget.showArchived,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return InventoryCategory(
              title: 'Perishable',
              items: snapshot.data!,
              isExpanded: expandedCategories['Perishable']!,
              onToggleExpanded: () {
                setState(() {
                  expandedCategories['Perishable'] =
                      !expandedCategories['Perishable']!;
                });
              },
              inventoryService: widget.inventoryService,
              showArchived: widget.showArchived,
            );
          },
        ),
        StreamBuilder<List<InventoryItem>>(
          stream: widget.inventoryService.getInventoryItems(
            'Non-Perishable',
            archived: widget.showArchived,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return InventoryCategory(
              title: 'Non-Perishable',
              items: snapshot.data!,
              isExpanded: expandedCategories['Non-Perishable']!,
              onToggleExpanded: () {
                setState(() {
                  expandedCategories['Non-Perishable'] =
                      !expandedCategories['Non-Perishable']!;
                });
              },
              inventoryService: widget.inventoryService,
              showArchived: widget.showArchived,
            );
          },
        ),
      ],
    );
  }
}
