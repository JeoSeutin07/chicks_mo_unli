import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTimeRange?> showCustomDateRangePicker({
  required BuildContext context,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final ThemeData customTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color(0xFFFFF3CB),
    colorScheme: ColorScheme.light(
      primary:
          const Color(0xFFFFA500), // Set the color for selected date background
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

  return await showDialog<DateTimeRange>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: customTheme,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CB), // Dialog background color
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CB),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
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
                      padding: const EdgeInsets.all(8),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
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
                      ),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
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
}
