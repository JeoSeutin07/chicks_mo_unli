import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './widgets/pin_input.dart';
import 'main_page.dart'; // Add this import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  final String userName;
  final String employeeId;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  const LoginScreen(
      {super.key, required this.userName, required this.employeeId});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isDialogShowing = false;

  Future<void> _login(String pin, BuildContext context) async {
    if (_isDialogShowing) return;

    try {
      final int parsedPin = int.parse(pin);
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: widget.employeeId)
          .where('pin', isEqualTo: parsedPin)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        final user = documents.first.data() as Map<String, dynamic>?;

        if (user != null) {
          await _secureStorage.write(
              key: 'employeeID', value: widget.employeeId);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else {
          _showDialog(context, 'Error', 'User data is null');
        }
      } else {
        _showDialog(context, 'Error', 'Invalid PIN');
      }
    } catch (e) {
      _showDialog(context, 'Error', 'Error logging in: $e');
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
                            CircleAvatar(
                              radius: 108.5,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/images/chicks-mo-unli-logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Welcome ${widget.userName}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Enter PIN to proceed.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: PinInput(
                                onChanged: (pin) {
                                  if (pin.length == 6) {
                                    _login(pin, context);
                                  }
                                },
                                onSubmit: (pin) {
                                  _login(pin, context);
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
