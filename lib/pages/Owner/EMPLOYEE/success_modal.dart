import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeSuccessModal extends StatelessWidget {
  final Map<String, dynamic> employeeData;

  const EmployeeSuccessModal({Key? key, required this.employeeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 242,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 248, 148, 1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Account Created Successfully!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.14,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "Here's the Account Credentials:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Name: ${employeeData['name']}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'EmployeeID: ${employeeData['EmployeeID']} \nLogin Pin: ${employeeData['pin']} \nClock in/out Pin: ${employeeData['clockInOutPin']}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: 'Name: ${employeeData['name']}\n'
                          'EmployeeID: ${employeeData['EmployeeID']}\n'
                          'Login Pin: ${employeeData['pin']}\n'
                          'Clock in/out Pin: ${employeeData['clockInOutPin']}'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Copy to Clipboard',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
