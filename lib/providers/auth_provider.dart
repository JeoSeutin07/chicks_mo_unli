import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  String _username = 'Juan Dela Cruz';
  String _token = '';
  String _employeeId = 'Emp001';
  String _pin = '111111';
  String _name = 'De Leon';
  String _userType = 'Owner';
  String _facebook = 'Facebook.com  ';
  String _email = 'Gmail.com';
  String _phoneNumber = '09123456789';
  bool _order = false;
  bool _stock = false;
  bool _cashflow = false;
  bool _admin = false;

  String get username => _username;
  String get token => _token;
  String get employeeId => _employeeId;
  String get pin => _pin;
  String get name => _name;
  String get userType => _userType;
  String get facebook => _facebook;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  bool get order => _order;
  bool get stock => _stock;
  bool get cashflow => _cashflow;
  bool get admin => _admin;

  Future<void> setCredentials(String employeeId, String pin) async {
    try {
      // Fetch the user document matching EmployeeID and pin
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: employeeId)
          .where('pin',
              isEqualTo: int.parse(pin)) // Ensure pin matches integer type
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final userDoc = documents.first;
        final user = userDoc.data() as Map<String, dynamic>?;

        if (user != null) {
          _employeeId = user['EmployeeID'] ?? '';
          _pin = user['pin'] ?? '';
          _name = user['name'] ?? 'Unknown';
          _userType = user['userType'] ?? 'Unknown';
          _username = user['name'] ?? '';
          _token = user['token'] ?? '';

          // Fetch restriction subcollection documents
          final restrictionSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userDoc.id) // Use the user document ID
              .collection('restriction')
              .get();

          if (restrictionSnapshot.docs.isNotEmpty) {
            // Use the first document in the restriction subcollection
            final restrictionData = restrictionSnapshot.docs.first.data();
            _order = restrictionData['order'] ?? false;
            _stock = restrictionData['stock'] ?? false;
            _cashflow = restrictionData['cashflow'] ?? false;
            _admin = restrictionData['admin'] ?? false;
          }

          // Fetch user-info subcollection documents
          final userInfoSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userDoc.id) // Use the user document ID
              .collection('user-info')
              .get();

          if (userInfoSnapshot.docs.isNotEmpty) {
            // Use the first document in the user-info subcollection
            final userInfoData = userInfoSnapshot.docs.first.data();
            _facebook = userInfoData['facebook'] ?? '';
            _email = userInfoData['email'] ?? '';
            _phoneNumber = userInfoData['phone'] ?? '';
          }

          notifyListeners(); // Notify listeners about updated values
        } else {
          throw Exception('User data is null');
        }
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  void clearCredentials() {
    _username = '';
    _token = '';
    _employeeId = '';
    _pin = '';
    _name = '';
    _userType = '';
    _facebook = '';
    _email = '';
    _phoneNumber = '';
    _order = false;
    _stock = false;
    _cashflow = false;
    _admin = false;
    notifyListeners();
  }
}
