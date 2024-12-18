import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'package:chicks_mo_unli/pages/Owner/EMPLOYEE/success_modal.dart';

class AddNewEmployee extends StatefulWidget {
  @override
  _AddNewEmployeeState createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _pinController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _facebookController;
  late TextEditingController _userTypeController;
  bool _isChanged = false;
  bool _isPinVisible = false; // Added to track PIN visibility
  Map<String, bool> _permissions = {
    'admin': false,
    'cashflow': false,
    'order': false,
    'stock': false,
  };

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _pinController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _facebookController = TextEditingController();
    _userTypeController = TextEditingController();

    _firstNameController.addListener(_onChanged);
    _lastNameController.addListener(_onChanged);
    _pinController.addListener(_onChanged);
    _emailController.addListener(_onChanged);
    _phoneController.addListener(_onChanged);
    _facebookController.addListener(_onChanged);
    _userTypeController.addListener(_onChanged);
  }

  void _showEmployeeSuccessModal(
      BuildContext context, Map<String, dynamic> employeeData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EmployeeSuccessModal(employeeData: employeeData);
      },
    );
  }

  void _onChanged() {
    setState(() {
      _isChanged = true;
    });
  }

  Future<void> _addEmployee() async {
    if (!_formKey.currentState!.validate()) return;
    String employeeId = 'EMP${DateTime.now().millisecondsSinceEpoch}';

    // Create a map to store the new employee details
    Map<String, dynamic> newEmployee = {
      'EmployeeID': employeeId,
      'createdAt': Timestamp.now(),
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'name': '${_firstNameController.text} ${_lastNameController.text}',
      'pin': int.parse(_pinController.text), // Store pin as number
      'clockInOutPin': int.parse(_pinController.text), // Store pin as number
      'profilePic': "",
      'lastClockIn': Timestamp.now(),
      'lastLogin': Timestamp.now(),
      'clockedIn': false,
      'email': _emailController.text,
      'phoneNumber': _phoneController.text,
      'facebook': _facebookController.text,
      'userType': _userTypeController.text,
      'permissions': _permissions,
      "activityLogs": [
        {
          "createdAt": Timestamp.now(),
        }
      ]
    };

    try {
      // Set the new employee with the specific EmployeeID as document ID
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(employeeId);

      await userRef.set(newEmployee);
      // Show success modal
      _showEmployeeSuccessModal(context, newEmployee);
// Prepare initial attendance document under 'attendance' collection
      Map<String, dynamic> attendance = {
        'attendance':
            [], // Optional: This can be an empty list or can be removed
      };

// Add an initial attendance record to the 'attendance' collection
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(employeeId)
          .set(attendance);
// Create a timestamp-based attendance document in the subcollection
      Map<String, dynamic> clockInData = {
        'clockInTime': Timestamp.now(), // Current timestamp for clock-in
        'clockOutTime': null, // Null for initial clock-out
        'status': 'clockedIn', // Initial status
      };

// Add the clock-in document to a subcollection named 'attendanceRecords'
      await userRef
          .collection('attendance') // Subcollection under user document
          .doc(DateFormat('yyyyMMdd_HHmmss').format(
              Timestamp.now().toDate())) // Use current time as document ID
          .set(clockInData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee added successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding employee: $e')),
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
                          const SizedBox(height: 20), // Space for the AppBar
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name*',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              final alphanumericRegex =
                                  RegExp(r'^[a-zA-Z0-9. ]+$');
                              if (!alphanumericRegex.hasMatch(value)) {
                                return 'First Name must be alphanumeric and can contain periods.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name *',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              final alphanumericRegex =
                                  RegExp(r'^[a-zA-Z0-9. ]+$');
                              if (!alphanumericRegex.hasMatch(value)) {
                                return 'Last Name must be alphanumeric and can contain periods.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _pinController,
                            decoration: InputDecoration(
                              labelText: 'Clock In/Out Pin *',
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
                          TextFormField(
                            controller: _userTypeController,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                          const SizedBox(height: 13),
                          const Text('Permissions'),
                          SwitchListTile(
                            title: const Text('Admin'),
                            value: _permissions['admin']!,
                            onChanged: (bool value) {
                              setState(() {
                                _permissions['admin'] = value;
                                _onChanged();
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Cashflow'),
                            value: _permissions['cashflow']!,
                            onChanged: (bool value) {
                              setState(() {
                                _permissions['cashflow'] = value;
                                _onChanged();
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Order'),
                            value: _permissions['order']!,
                            onChanged: (bool value) {
                              setState(() {
                                _permissions['order'] = value;
                                _onChanged();
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Stock'),
                            value: _permissions['stock']!,
                            onChanged: (bool value) {
                              setState(() {
                                _permissions['stock'] = value;
                                _onChanged();
                              });
                            },
                          ),
                          const SizedBox(height: 13),
                          ElevatedButton(
                            onPressed: _isChanged
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isChanged = false; // Disable button
                                      });
                                      await _addEmployee();
                                    }
                                  }
                                : null,
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
                              'Add',
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
                'Add New Employee',
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
