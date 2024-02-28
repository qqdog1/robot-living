import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/const/daily_task_type_value.dart';
import 'package:robot_living/dto/daily_task.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';
import 'package:robot_living/dto/start_end_task.dart';
import 'package:robot_living/page/settings_task_edit_page.dart';

import '../component/text_paging_popup.dart';
import '../const/daily_task_type.dart';
import '../dto/task.dart';

class SettingsDayEditPage extends StatefulWidget {
  final DailyTask? dailyTask;
  const SettingsDayEditPage({super.key, this.dailyTask});

  @override
  _SettingsDayEditPageState createState() => _SettingsDayEditPageState();
}

class _SettingsDayEditPageState extends State<SettingsDayEditPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DailyTask? dailyTask;
  List<bool> _daysSelected = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.dailyTask != null) {
      dailyTask = widget.dailyTask;
      _controller.text = dailyTask!.name!;
      _daysSelected = dailyTask!.triggered!;
    }
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
                hintText: 'EX: 認真工作一日計畫',
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
          _buildWeekdaySelector(),
        ],
      ),
      // 底部中間的儲存按鈕
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            _checkAndReturnInput();
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

  Widget _buildWeekdaySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List<Widget>.generate(7, (index) {
              return Expanded(
                child: Center(child: Text(_getDayName(index))),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List<Widget>.generate(7, (index) {
              return Expanded(
                child: Center(
                  child: Checkbox(
                    value: _daysSelected[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _daysSelected[index] = value!;
                      });
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return '日';
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      default:
        return '';
    }
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

  void _editNewSettings(int index, Task task) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingsTaskEditPage(task: task)),
    );

    if (result != null) {
      Task task = result as Task;
      _replaceTask(index, task);
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
      dailyTask!.tasks.add(task);
    });
  }

  void _replaceTask(int index, Task task) {
    setState(() {
      dailyTask!.tasks[index] = task;
    });
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: dailyTask?.tasks.length ?? 0,
      itemBuilder: (context, index) {
        Task currentTask = dailyTask!.tasks[index];
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
                            _editNewSettings(index, currentTask);
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (loopMin != null) Text('執行間隔: $loopMin'), // task.loopMin
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.trashCan), // 刪除按鈕
                          onPressed: () {
                            setState(() {
                              dailyTask?.tasks.removeAt(index);
                            });
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

  void _checkAndReturnInput() {
    dailyTask?.name = _controller.text;
    dailyTask?.triggered = _daysSelected;
    if (_checkInput()) {
      // TODO 檢查同為起訖類是否overlap
      Navigator.pop(context, dailyTask);
    }
  }

  bool _checkInput() {
    if (dailyTask == null || dailyTask!.tasks.isEmpty) {
      _showErrorPopup('無任何設定無須儲存');
      return false;
    }
    if (dailyTask?.name == null || dailyTask!.name!.isEmpty) {
      _showErrorPopup('請輸入計畫名稱');
      return false;
    }
    return true;
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TextPagingPopup(pageContents: [
          Text(message, style: const TextStyle(fontSize: 20))
        ]);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
