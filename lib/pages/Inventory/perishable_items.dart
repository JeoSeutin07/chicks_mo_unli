import 'package:flutter/material.dart';
import 'widgets/inventory_item_card.dart';

List<Widget> buildPerishableItems() {
  return [
    InventoryItemCard(
      name: "Chicken Wings",
      stockLevel: StockLevel.high,
      startingStock: 2,
      restock: 10,
      totalStock: 12,
      remainingStock: 3,
      isPerishable: true,
    ),
    InventoryItemCard(
      name: "Fries",
      stockLevel: StockLevel.low,
      startingStock: 2,
      restock: 10,
      totalStock: 12,
      remainingStock: 12,
      isPerishable: true,
    ),
  ];
}
