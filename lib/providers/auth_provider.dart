import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  // Main user fields
  String _employeeId = '';
  String _name = '';
  String _userType = '';
  String _facebook = '';
  String _email = '';
  String _phoneNumber = '';
  String _profilePic = '';
  String _lastLogin = '';

  // Permissions
  bool _order = false;
  bool _stock = false;
  bool _cashflow = false;
  bool _admin = false;
  bool _clockedIn = false;

  // Activity logs
  List<Map<String, dynamic>> _activityLogs = [];

  // Getters
  String get employeeId => _employeeId;
  String get name => _name;
  String get userType => _userType;
  String get facebook => _facebook;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get profilePic => _profilePic;
  String get lastLogin => _lastLogin;

  bool get order => _order;
  bool get stock => _stock;
  bool get cashflow => _cashflow;
  bool get admin => _admin;
  bool get clockedIn => _clockedIn;

  List<Map<String, dynamic>> get activityLogs => _activityLogs;

  // Fetch user credentials

  Future<void> setCredentials(String employeeId) async {
    try {
      // Fetch the user document matching EmployeeID and pin
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: employeeId)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      print("Documents found: ${documents.length}");
      if (documents.isNotEmpty) {
        final userDoc = documents.first;
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          print("Fetched user data: $userData");

          // Update main user fields
          _employeeId = userData['EmployeeID'] ?? '';
          _name = userData['name'] ?? '';
          _userType = userData['userType'] ?? '';
          _facebook = userData['facebook'] ?? '';
          _email = userData['email'] ?? '';
          _phoneNumber = userData['phoneNumber'] ?? '';
          _profilePic = userData['profilePic'] ?? '';

          // Convert Firestore Timestamp to String if it exists
          _lastLogin = _convertTimestampToString(userData['lastLogin']);

          print(
              "Updated user fields: $_employeeId, $_name, $_userType, $_facebook, $_email, $_phoneNumber, $_profilePic, $_lastLogin");

          // Update permissions
          final permissions =
              userData['permissions'] as Map<String, dynamic>? ?? {};
          _order = permissions['order'] ?? false;
          _stock = permissions['stock'] ?? false;
          _cashflow = permissions['cashflow'] ?? false;
          _admin = permissions['admin'] ?? false;
          _clockedIn = userData['clockedIn'] ?? false;
          print(
              "Updated permissions: order=$_order, stock=$_stock, cashflow=$_cashflow, admin=$_admin");

          // Update activity logs
          final logs = userData['activityLogs'] as List<dynamic>? ?? [];
          _activityLogs =
              logs.map((log) => Map<String, dynamic>.from(log)).toList();

          print("Updated activity logs: $_activityLogs");

          // Notify listeners to update the UI
          notifyListeners();
        } else {
          throw Exception('User data is null');
        }
      } else {
        throw Exception('No matching user found');
      }
    } catch (e) {
      print("Error retrieving user data: $e");
      throw Exception('Error retrieving user data: $e');
    }
  }

// Helper function to convert Firestore Timestamp to String
  String _convertTimestampToString(dynamic timestamp) {
    if (timestamp is Timestamp) {
      // Convert Timestamp to a DateTime object and format it to a String
      DateTime dateTime = timestamp.toDate();
      return dateTime
          .toIso8601String(); // or any custom format like 'yyyy-MM-dd HH:mm:ss'
    } else if (timestamp is String) {
      return timestamp; // Already a String
    }
    return ''; // Return empty string if timestamp is null or in unexpected format
  }

  // Clear user credentials
  void clearCredentials() {
    _employeeId = '';
    _name = '';
    _userType = '';
    _facebook = '';
    _email = '';
    _phoneNumber = '';
    _profilePic = '';
    _lastLogin = '';

    _order = false;
    _stock = false;
    _cashflow = false;
    _admin = false;
    _clockedIn = false;

    _activityLogs = [];
    notifyListeners();
  }
}
