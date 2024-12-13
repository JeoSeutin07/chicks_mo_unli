import 'package:chicks_mo_unli/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/pin_input.dart';
import 'widgets/clock_dialog_manager.dart';

class ClockInScreen extends StatefulWidget {
  final String employeeId;
  final bool isClockingIn;

  const ClockInScreen(
      {super.key, required this.employeeId, required this.isClockingIn});

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

  Future<void> _handleClockInOut(String pin, BuildContext context) async {
    if (_isDialogShowing) return;

    try {
      final int parsedPin = int.parse(pin);
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: widget.employeeId)
          .where('clockInOutPin', isEqualTo: parsedPin)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        final user = documents.first.data() as Map<String, dynamic>?;

        if (user != null) {
          final attendanceRef = FirebaseFirestore.instance
              .collection('users')
              .doc(widget.employeeId)
              .collection('attendance');

          if (widget.isClockingIn) {
            // Clock-In Logic
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.employeeId)
                .update({
              'clockedIn': true,
              'lastClockIn': Timestamp.now(),
            });

            await attendanceRef
                .doc(Timestamp.now().millisecondsSinceEpoch.toString())
                .set({
              'clockInTime': Timestamp.now(),
              'clockOutTime': null, // Set later when clocking out
              'status': 'clockedIn',
            });

            ClockDialogManager.showClockInSuccess(context);
          } else {
            // Clock-Out Logic
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.employeeId)
                .update({
              'clockedIn': false,
            });

            // Query for the latest clock-in record with clockOutTime == null
            final query = await attendanceRef
                .where('clockOutTime', isEqualTo: null)
                .orderBy('clockInTime', descending: true)
                .limit(1)
                .get();

            if (query.docs.isNotEmpty) {
              final doc = query.docs.first;
              await doc.reference.update({
                'clockOutTime': Timestamp.now(),
                'status': 'clockedOut',
              });

              ClockDialogManager.showClockOutSuccess(context);
            } else {
              _showDialog(context, 'Error', 'No active clock-in record found.');
            }
          }

          // Navigate back to the previous screen
          Navigator.of(context).pop();
        } else {
          _showDialog(context, 'Error', 'User data is null');
        }
      } else {
        _showDialog(context, 'Error', 'Invalid PIN');
      }
    } catch (e) {
      _showDialog(context, 'Error', 'Error clocking in/out: $e');
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
                            Text(
                              widget.isClockingIn ? 'Clock In' : 'Clock Out',
                              style: const TextStyle(
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
                                    _handleClockInOut(pin, context).then((_) {
                                      _isClockInTriggered = false;
                                    });
                                  }
                                },
                                onSubmit: (pin) {
                                  if (!_isClockInTriggered) {
                                    _handleClockInOut(pin, context);
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
