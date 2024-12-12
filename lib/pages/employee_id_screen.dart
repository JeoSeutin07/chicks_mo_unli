import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_screen.dart';
import '../widgets/styled_button.dart';

class EmployeeIdScreen extends StatefulWidget {
  const EmployeeIdScreen({super.key});

  @override
  _EmployeeIdScreenState createState() => _EmployeeIdScreenState();
}

class _EmployeeIdScreenState extends State<EmployeeIdScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isFocused = false;
  bool _isDialogShowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkStoredEmployeeId();
  }

  /// Check if an EmployeeID is already stored
  Future<void> _checkStoredEmployeeId() async {
    final String? storedEmployeeId =
        await _secureStorage.read(key: 'employeeID');
    final String? storedUserName = await _secureStorage.read(key: 'username');
    if (storedEmployeeId != null && storedUserName != null) {
      // Navigate directly to LoginScreen with the stored EmployeeID
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            userName: storedUserName, // Username will be fetched later
            employeeId: storedEmployeeId,
          ),
        ),
      );
    }
  }

  /// Validate the entered EmployeeID with Firestore
  Future<void> _checkEmployeeId(BuildContext context) async {
    if (_isDialogShowing) return;

    setState(() {
      _isLoading = true;
    });

    final employeeId = _controller.text;
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: employeeId)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        // Employee ID found, store it and proceed to login screen
        final user = documents.first.data() as Map<String, dynamic>?;
        if (user != null) {
          // Save EmployeeID in secure storage
          await _secureStorage.write(key: 'employeeID', value: employeeId);
          await _secureStorage.write(key: 'username', value: user['name']);
          // Navigate to LoginScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(userName: user['name'], employeeId: employeeId),
            ),
          );
        } else {
          _showDialog(context, 'Error', 'User data is null');
        }
      } else {
        // Employee ID not found, show error dialog
        _showDialog(context, 'Error', 'Invalid Employee ID');
      }
    } catch (e) {
      _showDialog(context, 'Error', 'Error checking Employee ID: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Show error or info dialog
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
                            const Text(
                              'Enter Employee ID',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isFocused = hasFocus;
                                });
                              },
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  hintText: 'Employee ID',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _isFocused
                                          ? const Color(0xFFD6C35C)
                                          : const Color(0xFFFFF55E),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : StyledButton(
                                    text: 'Next',
                                    onPressed: () {
                                      _checkEmployeeId(context);
                                    },
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
