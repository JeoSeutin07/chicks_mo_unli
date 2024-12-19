import 'package:flutter/material.dart';
import 'widgets/inventory_list.dart';
import 'services/inventory_service.dart';
import 'inventory_form_screen.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _showArchived = false;
  final InventoryService _inventoryService = InventoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3CB),
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                _showArchived ? 'Archived Inventory' : 'Inventory List',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Color(0xFFFFF3CB),
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(_showArchived
                                ? Icons.inventory
                                : Icons.archive),
                            title: Text(_showArchived
                                ? 'Show Active Items'
                                : 'Show Archived Items'),
                            onTap: () {
                              setState(() {
                                _showArchived = !_showArchived;
                              });
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
            Expanded(
              child: InventoryList(
                showArchived: _showArchived,
                inventoryService: _inventoryService,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_showArchived
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFF894), // Button color
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryFormScreen(
                          inventoryService: _inventoryService,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Add Inventory',
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
