import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import 'inventory_item_card.dart';

class InventoryCategory extends StatelessWidget {
  final String title;
  final List<InventoryItem> items;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final InventoryService inventoryService;
  final bool showArchived;

  const InventoryCategory({
    Key? key,
    required this.title,
    required this.items,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.inventoryService,
    required this.showArchived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                isExpanded ? Icons.expand_more : Icons.chevron_right,
              ),
            ],
          ),
          onTap: onToggleExpanded,
        ),
        if (isExpanded)
          ...items.map(
            (item) => InventoryItemCard(
              item: item,
              inventoryService: inventoryService,
              showArchiveButton: !showArchived,
              showRestoreButton: showArchived,
            ),
          ),
      ],
    );
  }
}
