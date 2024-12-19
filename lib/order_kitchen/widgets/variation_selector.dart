import 'package:flutter/material.dart';

class VariationSelector extends StatefulWidget {
  final Function(String) onConfirm;

  const VariationSelector({super.key, required this.onConfirm});

  @override
  _VariationSelectorState createState() => _VariationSelectorState();
}

class _VariationSelectorState extends State<VariationSelector> {
  String? selectedVariation;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        constraints: const BoxConstraints(maxWidth: 260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '--Variation--',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                letterSpacing: 0.14,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVariation = 'Red Tea';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: selectedVariation == 'Red Tea'
                                ? Colors.green
                                : const Color(0xFAFFF894),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Red Tea',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVariation = 'Blue Lemonade';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: selectedVariation == 'Blue Lemonade'
                                ? Colors.green
                                : const Color(0xFAFFF894),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Blue Lemonade',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVariation = 'Cucumber';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: selectedVariation == 'Cucumber'
                                ? Colors.green
                                : const Color(0xFAFFF894),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Cucumber',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVariation = 'Pineapple';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: selectedVariation == 'Pineapple'
                                ? Colors.green
                                : const Color(0xFAFFF894),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pineapple',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dismiss the dialog
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEF00),
                    padding: const EdgeInsets.all(3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedVariation != null) {
                      widget.onConfirm(selectedVariation!);
                      Navigator.pop(context); // Dismiss the dialog
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEF00),
                    padding: const EdgeInsets.all(3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
