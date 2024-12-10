import 'package:flutter/material.dart';
import 'widgets/inventory_item_card.dart';
import 'models/inventory_item.dart';

List<Widget> buildNonPerishableItems() {
  return [
    InventoryItemCard(
      item: InventoryItem(
        name: "Rice",
        stockLevel: StockLevel.moderate,
        startingStock: 2,
        restock: 10,
        totalStock: 12,
        remainingStock: 6,
        isPerishable: false,
      ),
    ),
    InventoryItemCard(
      item: InventoryItem(
        name: "Drinks",
        stockLevel: StockLevel.moderate,
        startingStock: 2,
        restock: 10,
        totalStock: 12,
        remainingStock: 5,
        isPerishable: false,
      ),
    ),
  ];
}
