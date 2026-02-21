import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LampPage(),
    );
  }
}

class LampPage extends StatefulWidget {
  const LampPage({super.key});

  @override
  State<LampPage> createState() => _LampPageState();
}

class _LampPageState extends State<LampPage> {
  double lampValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lampValue > 0.5 ? Colors.black : Colors.grey.shade900,
      body: Center(
        child: Slider(
          value: lampValue,
          onChanged: (v) => setState(() => lampValue = v),
        ),
      ),
    );
  }
}