import 'package:flutter/material.dart';
import 'widgets/period_selector.dart';
import 'perishable_items.dart';
import 'non_perishable_items.dart';
import 'widgets/inventory_item_card.dart';

class InventoryTracker extends StatefulWidget {
  @override
  _InventoryTrackerState createState() => _InventoryTrackerState();
}

class _InventoryTrackerState extends State<InventoryTracker> {
  bool isPerishableSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Tracker'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10), // Add left and right margins
        child: Column(
          children: [
            PeriodSelector(),
            StockLegend(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTab('Perishable', isPerishableSelected, () {
                      setState(() => isPerishableSelected = true);
                    }),
                    SizedBox(width: 8),
                    _buildTab('Non-Perishable', !isPerishableSelected, () {
                      setState(() => isPerishableSelected = false);
                    }),
                  ],
                ),
                _buildSortButton(),
              ],
            ),
            Expanded(
  child: Container(
    color: Color(0xFFFFF894), // Set the background color
    padding: EdgeInsets.all(10), // Set the inside padding
    child: ListView(
      children: isPerishableSelected
          ? buildPerishableItems()
          : buildNonPerishableItems(),
    ),
  ),
),
            ElevatedButton(
              onPressed: () {
                // Logic for adjusting stock can go here
              },
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
      ),
    );
  }

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
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey[800],
          ),
        ),
      ),
    );
  }

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
}

class StockLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('High Stock', Color(0xFFA1D8A6)),
          _buildLegendItem('Moderate Stock', Color(0xFFFFA500)),
          _buildLegendItem('Low Stock', Color(0xFFE74C3C)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
