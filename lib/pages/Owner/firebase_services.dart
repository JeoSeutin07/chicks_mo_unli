import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/users.model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Employee>> getEmployees() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList());
  }

  CollectionReference get employeesCollection => _firestore.collection('users');
  CollectionReference get archiveEmployeeCollection =>
      _firestore.collection('archived_users');

  Future<void> archiveAndDeleteEmployee(Employee employee) async {
    try {
      // Archive the document first
      await archiveEmployeeCollection.doc(employee.id).set(employee.toMap());

      // Delete the document from the main collection
      await employeesCollection.doc(employee.id).delete();

      print('Employee archived and deleted successfully');
    } catch (e) {
      print('Error deleting and archiving employee: $e');
      throw e;
    }
  }

  Future<DocumentSnapshot> fetchEmployeeDocument(String employeeId) async {
    try {
      DocumentSnapshot doc = await employeesCollection.doc(employeeId).get();
      return doc;
    } catch (e) {
      print('Error fetching employee document: $e');
      throw e;
    }
  }

  Future<void> updateEmployee({required Employee employee}) async {
    try {
      await employeesCollection.doc(employee.id).update(employee.toMap());
      print('Employee updated successfully');
    } catch (e) {
      print('Error updating employee: $e');
      throw e;
    }
  }
}
