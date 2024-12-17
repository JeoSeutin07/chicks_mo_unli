import 'package:chicks_mo_unli/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chicks_mo_unli/pages/employee_id_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBFOX0wRRFbw0xQO5HbYRcYe7rjT259d9Y",
            authDomain: "chicks-mo-unli.firebaseapp.com",
            projectId: "chicks-mo-unli",
            storageBucket: "chicks-mo-unli.firebasestorage.app",
            messagingSenderId: "955709287536",
            appId: "1:955709287536:web:1ff2a4027aa797f15dd8b5",
            measurementId: "G-43WH0CJXL5"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        home: AuthPage(),
      ),
    );
  }
}
