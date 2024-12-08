import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_date_range_picker.dart'; // Import the new file

class PeriodSelector extends StatefulWidget {
  @override
  _PeriodSelectorState createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  DateTime selectedDate = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;
  String selectedPeriod = 'Daily';
  bool isCalendarIconSelected = false;

  String getFormattedDate() {
    final DateFormat dayFormat = DateFormat('MMM dd, yyyy');
    final DateFormat monthFormat = DateFormat('MMMM yyyy');
    switch (selectedPeriod) {
      case 'Daily':
        return dayFormat.format(selectedDate);
      case 'Weekly':
        final startOfWeek =
            selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        return '${dayFormat.format(startOfWeek)} - ${dayFormat.format(endOfWeek)}';
      case 'Monthly':
        return monthFormat.format(selectedDate);
      case 'Custom':
        if (startDate != null && endDate != null) {
          return '${dayFormat.format(startDate!)} - ${dayFormat.format(endDate!)}';
        }
        return '';
      default:
        return '';
    }
  }

  void _showCustomDateRangePicker() async {
    setState(() {
      isCalendarIconSelected = true;
    });

    final DateTimeRange? picked = await showCustomDateRangePicker(
      context: context,
      startDate: startDate,
      endDate: endDate,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        selectedPeriod = 'Custom';
      });
    }
    setState(() {
      isCalendarIconSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  color: selectedPeriod == 'Custom' || isCalendarIconSelected
                      ? Colors.black
                      : Colors.grey,
                ),
                onPressed: _showCustomDateRangePicker,
              ),
              ...['Daily', 'Weekly', 'Monthly'].map((period) {
                return TextButton(
                  onPressed: () => setState(() => selectedPeriod = period),
                  child: Text(
                    period,
                    style: TextStyle(
                      color:
                          selectedPeriod == period ? Colors.black : Colors.grey,
                      fontWeight: selectedPeriod == period
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    switch (selectedPeriod) {
                      case 'Daily':
                        selectedDate = selectedDate.subtract(Duration(days: 1));
                        break;
                      case 'Weekly':
                        selectedDate = selectedDate.subtract(Duration(days: 7));
                        break;
                      case 'Monthly':
                        selectedDate =
                            DateTime(selectedDate.year, selectedDate.month - 1);
                        break;
                      case 'Custom':
                        if (startDate != null && endDate != null) {
                          final days =
                              endDate!.difference(startDate!).inDays + 1;
                          startDate = startDate!.subtract(Duration(days: days));
                          endDate = endDate!.subtract(Duration(days: days));
                        }
                        break;
                    }
                  });
                },
              ),
              Text(
                getFormattedDate(),
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    switch (selectedPeriod) {
                      case 'Daily':
                        selectedDate = selectedDate.add(Duration(days: 1));
                        break;
                      case 'Weekly':
                        selectedDate = selectedDate.add(Duration(days: 7));
                        break;
                      case 'Monthly':
                        selectedDate =
                            DateTime(selectedDate.year, selectedDate.month + 1);
                        break;
                      case 'Custom':
                        if (startDate != null && endDate != null) {
                          final days =
                              endDate!.difference(startDate!).inDays + 1;
                          startDate = startDate!.add(Duration(days: days));
                          endDate = endDate!.add(Duration(days: days));
                        }
                        break;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
