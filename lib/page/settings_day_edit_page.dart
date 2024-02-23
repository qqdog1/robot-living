import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/const/daily_task_type_value.dart';
import 'package:robot_living/dto/daily_task.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';
import 'package:robot_living/dto/start_end_task.dart';
import 'package:robot_living/page/settings_task_edit_page.dart';

import '../const/daily_task_type.dart';
import '../dto/task.dart';

class SettingsDayEditPage extends StatefulWidget {
  const SettingsDayEditPage({super.key});

  @override
  _SettingsDayEditPageState createState() => _SettingsDayEditPageState();
}

class _SettingsDayEditPageState extends State<SettingsDayEditPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DailyTask? dailyTask;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    // TODO read file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一日計畫設定'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: '輸入計劃名稱',
                hintText: 'EX: 工作日',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _buildTaskList(),
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.plus),
            onPressed: () {
              _addNewSettings();
            },
          ),
        ],
      ),
      // 底部中間的儲存按鈕
      bottomNavigationBar: Padding(
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
    );
  }

  void _addNewSettings() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsTaskEditPage()),
    );

    if (result != null) {
      Task task = result as Task;
      _addNewTask(task);
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _handleInputComplete();
    }
  }

  void _handleInputComplete() {
    if (dailyTask == null) {
      dailyTask = DailyTask(name: _controller.text, tasks: null);
    } else {
      dailyTask?.name = _controller.text;
    }
  }

  void _addNewTask(Task task) {
    dailyTask ??= DailyTask(name: null, tasks: null);
    setState(() {
      dailyTask?.tasks.add(task);
    });
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: dailyTask?.tasks.length ?? 0,
      itemBuilder: (context, index) {
        var currentTask = dailyTask!.tasks[index];
        String name = currentTask.name;
        DailyTaskType type = currentTask.type;
        String? startTime;
        String? endTime;
        int? loopMin;

        if (currentTask is StartEndTask) {
          startTime = currentTask.start;
          endTime = currentTask.end;
        } else if (currentTask is SegmentedTask) {
          startTime = currentTask.start;
          endTime = currentTask.end;
          loopMin = currentTask.loopMin;
        } else if (currentTask is OneTimeTask) {
          startTime = currentTask.time;
        }
        return Card(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  color: _getColorForType(type),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DailyTaskTypeValue.getValueByType(type),
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.penToSquare),
                          onPressed: () {
                            // 編輯功能的邏輯
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 第二行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('開始時間: $startTime'),
                        if (endTime != null) Text('結束時間: $endTime'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 第三行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (loopMin != null) Text('執行間隔: $loopMin'), // task.loopMin
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.trashCan), // 刪除按鈕
                          onPressed: () {
                            // 刪除功能的邏輯
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getColorForType(DailyTaskType dailyTaskType) {
    switch (dailyTaskType) {
      case DailyTaskType.startEndTask:
        return Colors.red;
      case DailyTaskType.segmentedTask:
        return Colors.blue;
      case DailyTaskType.oneTimeTask:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
