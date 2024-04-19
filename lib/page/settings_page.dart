import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:robot_living/cache/user_settings_cache.dart';
import 'package:robot_living/dto/daily_task.dart';
import 'package:robot_living/page/settings_day_edit_page.dart';
import 'package:robot_living/util/notification_util.dart';

import '../dto/daily_task_set.dart';
import '../dto/notification_object.dart';
import '../dto/notification_map.dart';
import '../dto/task.dart';
import '../generated/l10n.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late UserSettingsCache userSettingsCache;
  DailyTaskSet? dailyTaskSet;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    userSettingsCache = await UserSettingsCache.getInstance();
    final dailyTaskSetCache = userSettingsCache.getDailyTaskSet();
    if (mounted) {
      setState(() {
        dailyTaskSet = dailyTaskSetCache;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocaleProvider>(context);
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
        List<String> weekDays = [
          S.of(context).sunday,
          S.of(context).monday,
          S.of(context).tuesday,
          S.of(context).wednesday,
          S.of(context).thursday,
          S.of(context).friday,
          S.of(context).saturday,
        ];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(S.of(context).execution_interval,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ...List.generate(
                          7,
                          (i) {
                            return triggered[i]
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(weekDays[i],
                                        style: const TextStyle(fontSize: 16)),
                                  )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.penToSquare),
                        onPressed: () {
                          _editSettings(index, currentDailyTask);
                        },
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.trashCan),
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      dailyTaskSet?.dailyTasks.removeAt(index);
    });
    _updateUserCache();
  }

  void _addNewTask(DailyTask dailyTask) {
    dailyTaskSet ??= DailyTaskSet(dailyTasks: null);
    setState(() {
      dailyTaskSet!.dailyTasks.add(dailyTask);
    });
    _updateUserCache();
  }

  void _replaceTask(int index, DailyTask dailyTask) {
    setState(() {
      dailyTaskSet!.dailyTasks[index] = dailyTask;
    });
    _updateUserCache();
  }

  void _updateUserCache() {
    // cancel old notification
    NotificationMap oldNof = userSettingsCache.getNotificationMap();
    for (NotificationObject notificationObject in oldNof.map.values) {
      NotificationUtil.cancelAndroidAlarm(notificationObject.id!);
    }

    // give all task an id
    int id = 1;
    for (DailyTask dailyTask in dailyTaskSet!.dailyTasks) {
      for (Task task in dailyTask.tasks!) {
        task.setId(id++);
      }
    }

    NotificationMap notificationMap = NotificationUtil.toNotificationMap(dailyTaskSet!);
    userSettingsCache.setTaskAndNotify(dailyTaskSet!, notificationMap);

    // TODO 為每一個task註冊一個最近期即將發生的通知而非全部
    for (DailyTask dailyTask in dailyTaskSet!.dailyTasks) {
      for (Task task in dailyTask.tasks) {
      }
    }

    // for (NotificationObject notificationObject in notificationMap.map) {
    //   NotificationUtil.setAndroidAlarm(notificationObject.id!,
    //       notificationObject.title!,
    //       notificationObject.body,
    //       notificationObject.weekday!,
    //       notificationObject.hour,
    //       notificationObject.minute);
    // }
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

  void _editSettings(int index, DailyTask dailyTask) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SettingsDayEditPage(dailyTask: dailyTask)),
    );

    if (result != null) {
      DailyTask dailyTask = result as DailyTask;
      _replaceTask(index, dailyTask);
    }
  }
}
