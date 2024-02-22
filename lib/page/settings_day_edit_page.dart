import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/const/daily_task_type_value.dart';
import 'package:robot_living/dto/daily_task.dart';
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
        final task = dailyTask!.tasks[index];
        return Card(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  color: _getColorForType(task.type),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0), // Adjust padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(DailyTaskTypeValue.getValueByType(task.type), style: const TextStyle(fontSize: 16, color: Colors.grey)),
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
