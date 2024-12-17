import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class SetupAccountScreen extends StatefulWidget {
  @override
  _SetupAccountScreenState createState() => _SetupAccountScreenState();
}

class _SetupAccountScreenState extends State<SetupAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _pinController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _facebookController;
  bool _isChanged = false;
  bool _isPinVisible = false; // Added to track PIN visibility

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: authProvider.name);
    _pinController = TextEditingController();
    _emailController = TextEditingController(text: authProvider.email);
    _phoneController = TextEditingController(text: authProvider.phoneNumber);
    _facebookController = TextEditingController(text: authProvider.facebook);

    _nameController.addListener(_onChanged);
    _pinController.addListener(_onChanged);
    _emailController.addListener(_onChanged);
    _phoneController.addListener(_onChanged);
    _facebookController.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {
      _isChanged = true;
    });
  }

  Future<void> _updateDetails() async {
    if (!_isChanged) return; // Skip update if no changes

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final employeeId = authProvider.employeeId;

    // Create a map to store only the changed fields
    Map<String, dynamic> updates = {};

    // Compare current values with initial ones and add changed fields to the map
    if (_nameController.text != authProvider.name) {
      updates['name'] = _nameController.text;
    }
    if (_pinController.text.isNotEmpty) {
      // Ensure PIN is valid before adding it to updates
      if (_pinController.text.length == 6 &&
          RegExp(r'^\d{6}$').hasMatch(_pinController.text)) {
        updates['pin'] = _pinController.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid PIN format')),
        );
        return;
      }
    }
    if (_emailController.text != authProvider.email) {
      // Validate email before adding
      if (RegExp(r'^[a-zA-Z0-9._%+-]+@example\.com$')
          .hasMatch(_emailController.text)) {
        updates['email'] = _emailController.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email format')),
        );
        return;
      }
    }
    if (_phoneController.text != authProvider.phoneNumber) {
      // Validate phone number before adding
      if (RegExp(r'^(09\d{9}|\+639\d{9})$').hasMatch(_phoneController.text)) {
        updates['phoneNumber'] = _phoneController.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid phone number format')),
        );
        return;
      }
    }
    if (_facebookController.text != authProvider.facebook) {
      updates['facebook'] = _facebookController.text;
    }

    // If no fields were changed, skip the update
    if (updates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to update')),
      );
      return;
    }

    try {
      // Update Firestore with only the changed fields
      await FirebaseFirestore.instance
          .collection('users')
          .doc(employeeId)
          .update(updates);

      // Update the AuthProvider with new values
      authProvider.setCredentials(employeeId);

      setState(() {
        _isChanged = false; // Reset change tracker
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Details updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 412),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60), // Space for the AppBar
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name *',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              final alphanumericRegex =
                                  RegExp(r'^[a-zA-Z0-9. ]+$');
                              if (!alphanumericRegex.hasMatch(value)) {
                                return 'Full Name must be alphanumeric and can contain periods.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _pinController,
                            decoration: InputDecoration(
                              labelText: 'Change Log In Pin *',
                              border: const OutlineInputBorder(),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPinVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPinVisible = !_isPinVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText:
                                !_isPinVisible, // Dynamically control text visibility
                            validator: (value) {
                              if (_isChanged &&
                                  (value == null || value.isEmpty)) {
                                return 'Please enter your PIN';
                              }
                              if (_isChanged && (value?.length ?? 0) != 6) {
                                return 'PIN must be exactly 6 digits.';
                              }
                              final numericRegex = RegExp(r'^\d{6}$');
                              if (_isChanged &&
                                  value != null &&
                                  !numericRegex.hasMatch(value)) {
                                return 'PIN must contain only numbers.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Email must follow the pattern @example.com';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Contact Information',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact information';
                              }
                              final phoneRegex =
                                  RegExp(r'^(09\d{9}|(\+639\d{9}))$');
                              if (!phoneRegex.hasMatch(value)) {
                                return 'Contact must start with 09 or +639.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: _facebookController,
                            decoration: const InputDecoration(
                              labelText: 'Facebook Link',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                          const SizedBox(height: 13),
                          ElevatedButton(
                            onPressed: _isChanged ? _updateDetails : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFEF00),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.25),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Set Up Account',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              toolbarHeight: 35, // Set the height to 35
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
