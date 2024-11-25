import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  String _username = 'Nhel Jean';
  String _token = '';
  String _employeeId = '';
  String _pin = '';
  String _name = 'Palima';
  String _userType = '';
  String _facebook = '';
  String _email = '';
  String _phoneNumber = '';
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
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('EmployeeID', isEqualTo: employeeId)
          .where('pin', isEqualTo: int.parse(pin))
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        final user = documents.first.data() as Map<String, dynamic>?;
        if (user != null) {
          _employeeId = user['EmployeeID'] ?? '';
          _pin = user['pin'] ?? '';
          _name = user['name'] ?? 'Unknown';
          _userType = user['userType'] ?? 'Unknown';
          _username = user['name'] ?? '';
          _token = user['token'] ?? '';

          // Fetch restriction data
          final restrictionDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(documents.first.id)
              .collection('restriction')
              .doc('IJnPXaGbLBxLD1jzrWnf')
              .get();
          final restrictionData = restrictionDoc.data();
          if (restrictionData != null) {
            _order = restrictionData['order'] ?? false;
            _stock = restrictionData['stock'] ?? false;
            _cashflow = restrictionData['cashflow'] ?? false;
            _admin = restrictionData['admin'] ?? false;
          }

          // Fetch user-info data
          final userInfoDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(documents.first.id)
              .collection('user-info')
              .doc('W02P60M1Wg78cwLVZ3Lk')
              .get();
          final userInfoData = userInfoDoc.data();
          if (userInfoData != null) {
            _facebook = userInfoData['facebook'] ?? '';
            _email = userInfoData['email'] ?? '';
            _phoneNumber = userInfoData['phone'] ?? '';
          }

          notifyListeners();
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
