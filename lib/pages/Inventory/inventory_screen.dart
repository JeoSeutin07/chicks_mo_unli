import 'package:flutter/material.dart';
import 'widgets/period_selector.dart';
import 'services/firestore_service.dart';
import 'models/inventory_item_model.dart';
import 'widgets/stock_legend.dart';
import 'models/inventory_audit_model.dart';

class InventoryTracker extends StatefulWidget {
  @override
  _InventoryTrackerState createState() => _InventoryTrackerState();
}

class _InventoryTrackerState extends State<InventoryTracker> {
  bool isPerishableSelected = true;
  final FirestoreService firestoreService = FirestoreService();
  List<InventoryItemModel> inventoryItems = [];
  bool isLoading = false; // To manage fetch loading status

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  /// Fetch inventory data safely
  Future<void> _fetchInventory() async {
    setState(() {
      isLoading = true; // Show loader
    });

    try {
      List<InventoryItemModel> fetchedItems = isPerishableSelected
          ? await firestoreService.fetchPerishableItems()
          : await firestoreService.fetchNonPerishableItems();

      print('Fetched items'); // Log results
      setState(() {
        inventoryItems = fetchedItems;
      });
    } catch (e) {
      print('Error fetching inventory: $e');
    } finally {
      setState(() {
        isLoading = false; // Always reset loading state
      });
    }
  }

  /// Handle tab switching safely
  void _onTabSelection(bool isPerishable) {
    if (isPerishable == isPerishableSelected) return; // Prevent redundant fetch
    setState(() {
      isPerishableSelected = isPerishable;
    });
    _fetchInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          PeriodSelector(),
          StockLegend(
              items: inventoryItems), // Pass dynamic inventory items safely
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildTab(
                    'Perishable',
                    isPerishableSelected,
                    () => _onTabSelection(true),
                  ),
                  SizedBox(width: 8),
                  _buildTab(
                    'Non-Perishable',
                    !isPerishableSelected,
                    () => _onTabSelection(false),
                  ),
                ],
              ),
              _buildSortButton(),
            ],
          ),
          Expanded(
            child: Container(
              color: Color(0xFFFFF894),
              padding: EdgeInsets.all(10),
              child: inventoryItems.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: inventoryItems.length,
                      itemBuilder: (context, index) {
                        final item = inventoryItems[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF3CB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: item.stockColor,
                              width: 3,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: item.stockPercentage,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    item.stockColor),
                                minHeight: 8,
                              ),
                              SizedBox(height: 8),
                              Text('Starting Stock: ${item.startingStock}kg'),
                              Text('Restock: ${item.restock}kg'),
                              Text('Total Stock: ${item.totalStock}kg'),
                              Text('Remaining Stock: ${item.remainingStock}kg'),
                              SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Adjust Stock'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFEF00),
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Create tab UI
Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFFFF894) : Color(0xFFFFF55E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Text(text),
    ),
  );
}

/// Create sort button UI
Widget _buildSortButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFFFFF3CB)),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      children: [
        Icon(Icons.sort, size: 16),
        SizedBox(width: 8),
        Text('Sort'),
        Icon(Icons.arrow_drop_down, size: 16),
      ],
    ),
  );
}

/// Dynamically create inventory item cards
Widget _buildInventoryItemCard(InventoryItemModel item) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(item.name),
      subtitle: Text('Stock Level: ${item.stockLevel}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Remaining: ${item.remainingStock}'),
          Text('Restock: ${item.restock}'),
        ],
      ),
    ),
  );
}
