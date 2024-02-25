import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/dto/daily_task.dart';
import 'package:robot_living/page/settings_day_edit_page.dart';

import '../dto/daily_task_set.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  DailyTaskSet? dailyTaskSet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildTaskList(),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: Visibility(
              child: FloatingActionButton(
                onPressed: () {
                  _addNewSettings();
                },
                child: const Icon(FontAwesomeIcons.plus),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: dailyTaskSet?.dailyTasks.length ?? 0,
      itemBuilder: (context, index) {
        DailyTask currentDailyTask = dailyTaskSet!.dailyTasks[index];
        String name = currentDailyTask.name!;
        List<bool> triggered = currentDailyTask.triggered!;
        List<String> weekDays = ["日", "一", "二", "三", "四", "五", "六"];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(7, (i) {
                    return triggered[i]
                        ? Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(weekDays[i],
                                style: const TextStyle(fontSize: 16)),
                          )
                        : const SizedBox();
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addNewTask(DailyTask dailyTask) {
    dailyTaskSet ??= DailyTaskSet(dailyTasks: null);
    setState(() {
      dailyTaskSet!.dailyTasks.add(dailyTask);
    });
  }

  void _addNewSettings() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsDayEditPage()),
    );

    if (result != null) {
      DailyTask dailyTask = result as DailyTask;
      _addNewTask(dailyTask);
    }
  }

  void _editNewSettings(int index, DailyTask dailyTask) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsDayEditPage()),
    );

    if (result != null) {
      DailyTask dailyTask = result as DailyTask;
      print(dailyTask.toString());
    }
  }
}
