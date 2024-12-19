import 'package:flutter/material.dart';

class InventoryFilters extends StatelessWidget {
  final bool showPerishable;
  final bool showNonPerishable;
  final Function(bool, bool) onFilterChanged;
  final Function(String) onSortChanged;
  final String timeFrame;
  final Function(String) onTimeFrameChanged;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const InventoryFilters({
    Key? key,
    required this.showPerishable,
    required this.showNonPerishable,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.timeFrame,
    required this.onTimeFrameChanged,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterChip(
                label: Text('Perishable'),
                selected: showPerishable,
                onSelected: (bool value) {
                  onFilterChanged(value, showNonPerishable);
                },
              ),
              FilterChip(
                label: Text('Non-Perishable'),
                selected: showNonPerishable,
                onSelected: (bool value) {
                  onFilterChanged(showPerishable, value);
                },
              ),
              PopupMenuButton<String>(
                onSelected: onSortChanged,
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'stockLevel',
                    child: Text('Sort by Stock Level'),
                  ),
                  PopupMenuItem(
                    value: 'name',
                    child: Text('Sort by Name'),
                  ),
                ],
                child: Chip(
                  label: Text('Sort'),
                  avatar: Icon(Icons.sort),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: Text('Daily'),
                selected: timeFrame == 'daily',
                onSelected: (bool selected) {
                  if (selected) onTimeFrameChanged('daily');
                },
              ),
              ChoiceChip(
                label: Text('Weekly'),
                selected: timeFrame == 'weekly',
                onSelected: (bool selected) {
                  if (selected) onTimeFrameChanged('weekly');
                },
              ),
              ChoiceChip(
                label: Text('Monthly'),
                selected: timeFrame == 'monthly',
                onSelected: (bool selected) {
                  if (selected) onTimeFrameChanged('monthly');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
