import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';
import 'package:robot_living/dto/start_end_task.dart';
import 'package:robot_living/dto/task.dart';

import '../component/combobox.dart';
import '../component/text_paging_popup.dart';
import '../const/daily_task_type_value.dart';
import '../util/time_util.dart';

class SettingsTaskEditPage extends StatefulWidget {
  final Task? task;
  const SettingsTaskEditPage({super.key, this.task});

  @override
  _SettingsTaskEditPageState createState() => _SettingsTaskEditPageState();
}

class _SettingsTaskEditPageState extends State<SettingsTaskEditPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final FocusNode _taskNameFocusNode = FocusNode();
  final TextEditingController _loopMinController = TextEditingController();
  final FocusNode _loopMinFocusNode = FocusNode();
  String? _taskName;
  String? _dailyTaskTypeValue;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int? _loopMin;

  @override
  void initState() {
    super.initState();
    _taskNameFocusNode.addListener(_onTaskNameFocusChange);
    _loopMinFocusNode.addListener(_onLoopMinFocusChange);
    if (widget.task != null) {
      Task task = widget.task!;
      _taskName = task.name;
      _taskNameController.text = _taskName!;
      _dailyTaskTypeValue = DailyTaskTypeValue.getValueByType(task.type);
      if (task is StartEndTask) {
        _startTime = TimeUtil.stringToTimeOfDay(task.start);
        _endTime = TimeUtil.stringToTimeOfDay(task.end);
      } else if (task is SegmentedTask) {
        _startTime = TimeUtil.stringToTimeOfDay(task.start);
        _endTime = TimeUtil.stringToTimeOfDay(task.end);
        _loopMin = task.loopMin;
        _loopMinController.text = _loopMin.toString();
      } else if (task is OneTimeTask) {
        _startTime = TimeUtil.stringToTimeOfDay(task.time);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任務及通知設定'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _taskNameController,
                    focusNode: _taskNameFocusNode,
                    decoration: const InputDecoration(
                      labelText: '輸入任務名稱',
                      hintText: 'EX: 定時學習',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10), // 添加間距
                  const Text(
                    '任務類型:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: <Widget>[
                      Combobox(
                        defaultItem: _dailyTaskTypeValue,
                        items: const [
                          DailyTaskTypeValue.startEndTask,
                          DailyTaskTypeValue.segmentedTask,
                          DailyTaskTypeValue.oneTimeTask,
                        ],
                        onItemChanged: (newValue) {
                          setState(() {
                            _dailyTaskTypeValue = newValue;
                            _startTime = null;
                            _endTime = null;
                            _loopMin = null;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.circleQuestion),
                        onPressed: () {
                          showTypeHelpPopup(context);
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _dailyTaskTypeValue ==
                            DailyTaskTypeValue.startEndTask ||
                        _dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (_startTime == null)
                          const Text(
                            '設定開始時間:',
                            style: TextStyle(fontSize: 20),
                          ),
                        if (_startTime != null)
                          Text('開始時間: ${_startTime!.format(context)}',
                              style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                          child: const Text('選擇開始時間'),
                        ),
                        if (_endTime == null)
                          const Text(
                            '設定結束時間:',
                            style: TextStyle(fontSize: 20),
                          ),
                        if (_endTime != null)
                          Text('結束時間: ${_endTime!.format(context)}',
                              style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _endTime = pickedTime; // 更新結束時間狀態
                              });
                            }
                          },
                          child: const Text('選擇結束時間'),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        _dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _loopMinController,
                                focusNode: _loopMinFocusNode,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: '執行間隔',
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 10), // 為輸入框和下拉選單增加間距
                            const Flexible(
                              flex: 1,
                              child: Text('分鐘'),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        _dailyTaskTypeValue == DailyTaskTypeValue.oneTimeTask,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (_startTime == null)
                          const Text(
                            '設定觸發時間:',
                            style: TextStyle(fontSize: 20),
                          ),
                        if (_startTime != null)
                          Text('觸發時間: ${_startTime!.format(context)}',
                              style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                          child: const Text('選擇觸發時間'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Future<void> showTypeHelpPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const TextPagingPopup(
          totalPages: 4,
          pageContents: [
            Text('任務分三種類型:\n1.起訖類型\n2.分段類型\n3.一次性',
                style: TextStyle(fontSize: 18)),
            Text(
                '起訖類型任務需要設定\n開始時間及結束時間,\n若是想養成早睡早起的習慣,就適合把睡覺設定成起訖行任務\n又或是每日晚間養成定時讀書的習慣也很適合加入一個起訖型的任務',
                style: TextStyle(fontSize: 18)),
            Text(
                '分段類的任務適合放一些每日需要被階段完成的目標\n若訂下了每天需要喝足夠的水,從早上10點開始到晚上8點\n每隔40分鐘提醒\n或是每日做100下伏地挺身\n也可以讓程式協助分段提醒',
                style: TextStyle(fontSize: 18)),
            Text(
                '一次型的任務只須設定一個時間點,讓程式提醒你去做某件事\n像是每天早上10點要記得煮水或是晚上10點要關玄關的燈\n各種執行起來不會花太多時間又或是容易忘記的事情都很適合加入',
                style: TextStyle(fontSize: 18)),
          ],
        );
      },
    );
  }

  void _onTaskNameFocusChange() {
    if (!_taskNameFocusNode.hasFocus) {
      _handleTaskNameInputComplete();
    }
  }

  void _onLoopMinFocusChange() {
    if (!_loopMinFocusNode.hasFocus) {
      _handleLoopMinInputComplete();
    }
  }

  void _handleTaskNameInputComplete() {
    _taskName = _taskNameController.text;
  }

  void _handleLoopMinInputComplete() {
    _loopMin = int.tryParse(_loopMinController.text);
  }

  void _checkAndReturnInput() {
    _handleTaskNameInputComplete();
    _handleLoopMinInputComplete();
    if (_checkInput()) {
      Task task = _getTask();
      Navigator.pop(context, task);
    }
  }

  bool _checkInput() {
    if (_taskName == null || _taskName!.isEmpty) {
      _showErrorPopup('請輸入任務名稱');
      return false;
    }
    if (_dailyTaskTypeValue == null || _dailyTaskTypeValue!.isEmpty) {
      _showErrorPopup('請選擇任務類型');
      return false;
    }
    if ((_dailyTaskTypeValue == DailyTaskTypeValue.startEndTask ||
            _dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask) &&
        _startTime == null) {
      _showErrorPopup('請設定開始時間');
      return false;
    }
    if ((_dailyTaskTypeValue == DailyTaskTypeValue.startEndTask ||
            _dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask) &&
        _endTime == null) {
      _showErrorPopup('請設定結束時間');
      return false;
    }
    if (_dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask &&
        _loopMin == null) {
      _showErrorPopup('請設定執行間隔');
      return false;
    }
    if (_dailyTaskTypeValue == DailyTaskTypeValue.oneTimeTask &&
        _startTime == null) {
      _showErrorPopup('請設定觸發時間');
      return false;
    }
    return true;
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TextPagingPopup(totalPages: 1, pageContents: [
          Text(message, style: const TextStyle(fontSize: 20))
        ]);
      },
    );
  }

  Task _getTask() {
    Task task;
    if (_dailyTaskTypeValue == DailyTaskTypeValue.startEndTask) {
      task = StartEndTask(_taskName!, TimeUtil.formatTimeOfDay(_startTime!), TimeUtil.formatTimeOfDay(_endTime!));
    } else if (_dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask) {
      task = SegmentedTask(_taskName!, TimeUtil.formatTimeOfDay(_startTime!), TimeUtil.formatTimeOfDay(_endTime!), _loopMin!);
    } else {
      task = OneTimeTask(_taskName!, TimeUtil.formatTimeOfDay(_startTime!));
    }
    return task;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskNameFocusNode.dispose();
    _loopMinController.dispose();
    _loopMinFocusNode.dispose();
    super.dispose();
  }
}
