import 'widgets/inventory_item_card.dart';
import 'package:flutter/material.dart';

List<Widget> buildNonPerishableItems() {
  return [
    InventoryItemCard(
      name: "Rice",
      stockLevel: StockLevel.moderate,
      startingStock: 2,
      restock: 10,
      totalStock: 12,
      remainingStock: 0,
      isPerishable: false,
    ),
    InventoryItemCard(
      name: "Drinks",
      stockLevel: StockLevel.moderate,
      startingStock: 2,
      restock: 10,
      totalStock: 12,
      remainingStock: 3,
      isPerishable: false,
    ),
  ];
}
