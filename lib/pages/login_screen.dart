import 'package:flutter/material.dart';
import 'widgets/pin_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3CB),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 52),
                    Center(
                      child: Container(
                        width: 355,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 108.5,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/images/chicks-mo-unli-logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'LogIn',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: PinInput(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
