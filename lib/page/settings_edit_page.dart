import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../component/combobox.dart';
import '../const/daily_task_type_value.dart';

class SettingsEditPage extends StatefulWidget {
  const SettingsEditPage({super.key});

  @override
  _SettingsEditPageState createState() => _SettingsEditPageState();
}

class _SettingsEditPageState extends State<SettingsEditPage> {
  String dailyTaskTypeValue = DailyTaskTypeValue.startEndTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '通知類型',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              children: <Widget>[
                Combobox(
                  defaultItem: dailyTaskTypeValue,
                  items: const [
                    DailyTaskTypeValue.startEndTask,
                    DailyTaskTypeValue.segmentedTask,
                    DailyTaskTypeValue.oneTimeTask,
                  ],
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.circleQuestion),
                  onPressed: () {
                    // 問號按鈕的功能實現
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
