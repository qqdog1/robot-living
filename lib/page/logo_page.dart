import 'dart:async';
import 'package:flutter/material.dart';
import 'package:robot_living/page/menu_page.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  late Timer _timer;
  bool _canNavigate = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      _canNavigate = true;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_canNavigate) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MenuPage()));
        }
      },
      behavior: HitTestBehavior.opaque, // 全域偵測觸控
      child: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)), // 最多顯示三秒
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 显示您的 Logo 或其他欢迎界面
            return Center(
              child: Image.asset('assets/images/logo.png'),
            );
          } else {
            return const MenuPage();
          }
        },
      ),
    );
  }
}