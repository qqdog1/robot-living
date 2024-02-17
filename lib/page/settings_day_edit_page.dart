import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/page/settings_task_edit_page.dart';

class SettingsDayEditPage extends StatefulWidget {
  const SettingsDayEditPage({super.key});

  @override
  _SettingsDayEditPageState createState() => _SettingsDayEditPageState();
}

class _SettingsDayEditPageState extends State<SettingsDayEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一日計畫設定'),
      ),
      body: Stack(
        children: [
          // 文字輸入的區域和加號按鈕
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '輸入計劃名稱',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.plus),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsTaskEditPage(),
                  ));
                },
              ),
            ],
          ),
          // 底部中間的儲存按鈕
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // 儲存按鈕的動作
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('儲存', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
