import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String phoneNumber;
  final String facebook;
  final String profilePic;
  final String userType;
  final int clockInOutPin;
  final int pin;
  final bool clockedIn;
  final DateTime createdAt;
  final DateTime lastClockIn;
  final DateTime lastLogin;
  final Permissions permissions;

  Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.facebook,
    required this.profilePic,
    required this.userType,
    required this.clockInOutPin,
    required this.pin,
    required this.clockedIn,
    required this.createdAt,
    required this.lastClockIn,
    required this.lastLogin,
    required this.permissions,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      employeeId: data['EmployeeID'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      facebook: data['facebook'] ?? '',
      profilePic: data['profilePic'] ?? '',
      userType: data['userType'] ?? '',
      clockInOutPin: data['clockInOutPin'] ?? 0,
      pin: data['pin'] ?? 0,
      clockedIn: data['clockedIn'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastClockIn: (data['lastClockIn'] as Timestamp).toDate(),
      lastLogin: (data['lastLogin'] as Timestamp).toDate(),
      permissions: Permissions.fromMap(data['permissions'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'EmployeeID': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'facebook': facebook,
      'profilePic': profilePic,
      'userType': userType,
      'clockInOutPin': clockInOutPin,
      'pin': pin,
      'clockedIn': clockedIn,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastClockIn': Timestamp.fromDate(lastClockIn),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'permissions': permissions.toMap(),
    };
  }
}

class Permissions {
  final bool admin;
  final bool cashflow;
  final bool order;
  final bool stock;

  Permissions({
    required this.admin,
    required this.cashflow,
    required this.order,
    required this.stock,
  });

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      admin: map['admin'] ?? false,
      cashflow: map['cashflow'] ?? false,
      order: map['order'] ?? false,
      stock: map['stock'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admin': admin,
      'cashflow': cashflow,
      'order': order,
      'stock': stock,
    };
  }
}
