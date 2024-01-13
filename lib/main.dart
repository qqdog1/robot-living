import 'package:flutter/material.dart';
import 'package:robot_living/page/logo_page.dart';

void main() {
  runApp(const RobotLiving());
}

class RobotLiving extends StatelessWidget {
  const RobotLiving({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoPage(),
    );
  }
}