import 'package:flutter/material.dart';

class DummyLoginScreen extends StatelessWidget {
  const DummyLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة وهمية'),
      ),
      body: const Center(
        child: Text(
          'شاشة تسجيل الدخول\n(قيد التطوير من قبل الزميلة)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}