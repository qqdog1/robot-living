import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:robot_living/cache/user_settings_cache.dart';
import 'package:robot_living/dto/daily_task.dart';
import 'package:robot_living/page/settings_day_edit_page.dart';
import 'package:robot_living/util/notification_util.dart';

import '../component/text_paging_popup_with_button.dart';
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

class _SettingsPage extends State<SettingsPage> with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel('robot_inner');

  late UserSettingsCache userSettingsCache;
  DailyTaskSet? dailyTaskSet;
  String? currentExecuting;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    WidgetsBinding.instance.addObserver(this);

    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onAlarmReceived') {
        if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
          _handleAlarm();
        }
      }
    });
  }

  Future<void> _loadSettings() async {
    userSettingsCache = await UserSettingsCache.getInstance();
    final dailyTaskSetCache = userSettingsCache.getDailyTaskSet();
    if (mounted) {
      setState(() {
        dailyTaskSet = dailyTaskSetCache;
        currentExecuting = NotificationUtil.getCurrentExecuting(userSettingsCache.getDailyTaskSet());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: currentExecuting == null
          ? AppBar()
          : AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).currently_executing,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    currentExecuting!,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildTaskList(),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                _addNewSettings();
              },
              child: const Icon(FontAwesomeIcons.plus),
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

        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(S.of(context).execution_interval,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            ...List.generate(
                              7,
                              (i) {
                                return triggered[i]
                                    ? Padding(
                                        padding: const EdgeInsets.only(right: 4.0),
                                        child: Text(weekDays[i], style: const TextStyle(fontSize: 16)),
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
            ),
            if (index == (dailyTaskSet!.dailyTasks.length - 1))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowsRotate),
                  onPressed: () {
                    _showResetPopup(context);
                  },
                ),
              ),
          ],
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
    for (List<NotificationObject> lst in oldNof.map.values) {
      for (NotificationObject notificationObject in lst) {
        NotificationUtil.cancelAndroidAlarm(notificationObject.id!);
      }
    }

    // give all task an id
    int id = 1;
    for (DailyTask dailyTask in dailyTaskSet!.dailyTasks) {
      for (Task task in dailyTask.tasks) {
        task.setId(id++);
      }
    }

    NotificationMap notificationMap = NotificationUtil.toNotificationMap(dailyTaskSet!);
    userSettingsCache.setTaskAndNotify(dailyTaskSet!, notificationMap);

    // 為每一個task註冊一個最近期即將發生的通知而非全部
    for (int taskId in notificationMap.map.keys) {
      NotificationUtil.registerNext(notificationMap.map[taskId]!, context);
    }

    setState(() {
      currentExecuting = NotificationUtil.getCurrentExecuting(userSettingsCache.getDailyTaskSet());
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

  void _editSettings(int index, DailyTask dailyTask) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingsDayEditPage(dailyTask: dailyTask)),
    );

    if (result != null) {
      DailyTask dailyTask = result as DailyTask;
      _replaceTask(index, dailyTask);
    }
  }

  Future<void> _showResetPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TextPagingPopupWithButton(
          pageContents: [
            Text(S.of(context).reset_help, style: const TextStyle(fontSize: 18)),
          ],
          buttonCallback: () {
            _updateUserCache();
            Navigator.pop(context);
          },
          buttonText: S.of(context).reset,
        );
      },
    );
  }

  void _handleAlarm() {
    print("handle alarm");
    setState(() {
      currentExecuting = NotificationUtil.getCurrentExecuting(userSettingsCache.getDailyTaskSet());
    });
  }
}
