import 'package:chicks_mo_unli/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/pin_input.dart';
import 'widgets/clock_dialog_manager.dart';

class ClockInScreen extends StatefulWidget {
  final String employeeId;

  const ClockInScreen({super.key, required this.employeeId});

  @override
  ClockInScreenState createState() => ClockInScreenState();
}

class ClockInScreenState extends State<ClockInScreen> {
  bool _isDialogShowing = false;
  bool _isClockInTriggered = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _clockin(String pin, BuildContext context) async {
    if (_isDialogShowing) return;

    try {
      final int parsedPin = int.parse(pin);
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: widget.employeeId)
          .where('clockInOutPin', isEqualTo: parsedPin)
          .get();

      print("Query result: ${result.docs}");

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        final user = documents.first.data() as Map<String, dynamic>?;

        if (user != null) {
          // Navigate back to mainpage.dart
          Navigator.of(context).pop();
          // Show success dialog
          ClockDialogManager.showClockInSuccess(context);
        } else {
          _showDialog(context, 'Error', 'User data is null');
        }
      } else {
        _showDialog(context, 'Error', 'Invalid PIN');
      }
    } catch (e) {
      _showDialog(context, 'Error', 'Error clocking in: $e');
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _isDialogShowing = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3CB),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 52),
                    Center(
                      child: SizedBox(
                        width: 355,
                        child: Column(
                          children: [
                            const Text(
                              'Clock In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: PinInput(
                                onChanged: (pin) {
                                  if (pin.length == 6 && !_isClockInTriggered) {
                                    _isClockInTriggered = true;
                                    _clockin(pin, context).then((_) {
                                      _isClockInTriggered = false;
                                    });
                                  }
                                },
                                onSubmit: (pin) {
                                  if (!_isClockInTriggered) {
                                    _clockin(pin, context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
