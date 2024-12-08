import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    final ThemeData customTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFFFF3CB),
      colorScheme: ColorScheme.light(
        primary: const Color(
            0xFFFFA500), // Set the color for selected date background
        onPrimary: Colors.white, // Text color for selected date
        surface: const Color(0xFFFFF3CB),
        onSurface: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black, // "Select" and "Cancel" buttons
        ),
      ),
    );

    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero, // Remove inset padding
              child: Theme(
                data: customTheme,
                child: Container(
                  color: const Color(0xFFFFF3CB), // Dialog background color
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.zero, // Remove padding
                        color: const Color(0xFFFFF3CB),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red), // Debug border
                        ),
                        child: Text(
                          "Select Date Range",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Calendar
                      Container(
                        padding: EdgeInsets.zero, // Remove padding
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.green), // Debug border
                        ),
                        child: CalendarDatePicker(
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          currentDate: DateTime.now(),
                          onDateChanged: (DateTime date) {
                            if (startDate == null ||
                                (startDate != null && endDate != null)) {
                              setState(() {
                                startDate = date;
                                endDate =
                                    null; // Reset end date when selecting start
                              });
                            } else {
                              setState(() {
                                endDate = date.isAfter(startDate!)
                                    ? date
                                    : startDate; // Ensure the end date is after start
                              });
                            }
                          },
                          selectableDayPredicate: (DateTime date) {
                            // Highlight the selected range
                            if (startDate != null && endDate != null) {
                              return date.isAfter(startDate!
                                      .subtract(const Duration(days: 1))) &&
                                  date.isBefore(
                                      endDate!.add(const Duration(days: 1)));
                            }
                            return true;
                          },
                        ),
                      ),
                      // Selected Date Range
                      if (startDate != null)
                        Center(
                          child: Text(
                            endDate != null
                                ? '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}'
                                : 'Start Date: ${DateFormat('MMM dd, yyyy').format(startDate!)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                startDate = null;
                                endDate = null;
                              });
                            },
                            child: const Text("RESET"),
                          ),
                          TextButton(
                            onPressed: () {
                              if (startDate != null && endDate != null) {
                                Navigator.of(context).pop(DateTimeRange(
                                  start: startDate!,
                                  end: endDate!,
                                ));
                              }
                            },
                            child: const Text("SELECT"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CB),
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
