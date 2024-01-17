import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool _showPlus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 20.0, // Adjust the values as per your requirements
              right: 20.0,
              child: Visibility(
                visible: _showPlus,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _showPlus = false;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
