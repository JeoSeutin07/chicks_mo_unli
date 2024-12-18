import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_services.dart';
import 'models/users.model.dart';
import 'employee_card.dart';
import 'package:chicks_mo_unli/pages/Owner/EMPLOYEE/add_employee_page.dart';
import 'package:chicks_mo_unli/pages/Owner/EMPLOYEE/update_employee.dart';

class EmployeeListHeader extends StatelessWidget {
  const EmployeeListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: const Text(
                      'Employee Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 185,
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: const Text(
                            'Role',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Semantics(
                          header: true,
                          child: const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Semantics(
                          header: true,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeListScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3CB),
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Employee List',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            const EmployeeListHeader(),
            SizedBox(height: 10),
            _buildEmployeeList(),
            _buildAddEmployeeButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    return Expanded(
      child: StreamBuilder<List<Employee>>(
        stream: _firebaseService.getEmployees(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: EmployeeCard(employee: snapshot.data![index])),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Show update and delete options
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Color(
                              0xFFFFF3CB), // Change this to your desired color

                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.update),
                                  title: Text('Update'),
                                  onTap: () async {
                                    // Fetch the DocumentSnapshot dynamically using the ID of the employee
                                    DocumentSnapshot docSnapshot =
                                        await _firebaseService
                                            .fetchEmployeeDocument(
                                                snapshot.data![index].id);

                                    // You now have the DocumentSnapshot; you can pass it to the update screen
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdateEmployee(
                                            employee: docSnapshot),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _showDeleteConfirmation(
                                        context, snapshot.data![index]);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Employee'),
          content: Text(
              'Are you sure you want to delete ${employee.name}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteAndArchiveEmployee(employee);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAndArchiveEmployee(Employee employee) async {
    try {
      await _firebaseService.archiveAndDeleteEmployee(employee);
      print('Employee archived and deleted successfully');
    } catch (e) {
      print('Error deleting and archiving employee: $e');
    }
  }

  Widget _buildAddEmployeeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFF894), // Button color
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNewEmployee(), // Navigate to CRUD page
            ),
          );
        },
        child: Text(
          'Add Employee',
          style: TextStyle(color: Colors.black), // Text color
        ),
      ),
    );
  }
}
