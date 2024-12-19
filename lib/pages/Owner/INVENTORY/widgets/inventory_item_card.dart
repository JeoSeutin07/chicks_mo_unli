import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import '../inventory_form_screen.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final InventoryService inventoryService;
  final bool showArchiveButton;
  final bool showRestoreButton;

  const InventoryItemCard({
    Key? key,
    required this.item,
    required this.inventoryService,
    this.showArchiveButton = true,
    this.showRestoreButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFFFFF894),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Min Stock: ${item.minimumStock} ${item.unit}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventoryFormScreen(
                                inventoryService: inventoryService,
                                item: item,
                              ),
                            ),
                          );
                        },
                      ),
                      if (showArchiveButton)
                        ListTile(
                          leading: Icon(Icons.archive),
                          title: Text('Archive'),
                          onTap: () async {
                            await inventoryService.archiveInventoryItem(
                              item.id,
                              item.category,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      if (showRestoreButton)
                        ListTile(
                          leading: Icon(Icons.unarchive),
                          title: Text('Restore'),
                          onTap: () async {
                            await inventoryService.restoreInventoryItem(
                              item.id,
                              item.category,
                            );
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
