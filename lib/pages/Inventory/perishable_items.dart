import 'package:flutter/material.dart';
import 'widgets/inventory_item_card.dart';
import 'models/inventory_item.dart';

List<Widget> buildPerishableItems() {
  return [
    InventoryItemCard(
      item: InventoryItem(
        name: "Chicken Wings",
        stockLevel: StockLevel.high,
        startingStock: 10,
        restock: 5,
        totalStock: 15,
        remainingStock: 0,
        isPerishable: true,
      ),
    ),
    InventoryItemCard(
      item: InventoryItem(
        name: "Fries",
        stockLevel: StockLevel.low,
        startingStock: 5,
        restock: 8,
        totalStock: 15,
        remainingStock: 2,
        isPerishable: true,
      ),
    ),
  ];
}
