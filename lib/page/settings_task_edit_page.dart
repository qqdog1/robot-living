import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';
import 'package:robot_living/dto/duration_task.dart';
import 'package:robot_living/dto/task.dart';

import '../component/combobox.dart';
import '../component/text_paging_popup.dart';
import '../const/daily_task_type.dart';
import '../const/daily_task_type_value.dart';
import '../generated/l10n.dart';
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
      _dailyTaskTypeValue = DailyTaskTypeValue.getValueByType(context, task.type);
      if (task is DurationTask) {
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
        title: Text(S.of(context).title_task_nof_settings),
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
                    decoration: InputDecoration(
                      labelText: S.of(context).input_task_name,
                      hintText: S.of(context).input_ex_task_name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10), // 添加間距
                  Text(
                    S.of(context).task_type,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: <Widget>[
                      Combobox(
                        defaultItem: _dailyTaskTypeValue,
                        items: [
                          DailyTaskTypeValue.getValueByType(context, DailyTaskType.durationTask),
                          DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask),
                          DailyTaskTypeValue.getValueByType(context, DailyTaskType.oneTimeTask),
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
                            DailyTaskTypeValue.getValueByType(context, DailyTaskType.durationTask) ||
                        _dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (_startTime == null)
                          Text(
                            S.of(context).choose_start_time,
                            style: const TextStyle(fontSize: 20),
                          ),
                        if (_startTime != null)
                            Text(S.of(context).start_time(_startTime!.format(context)),
                                style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await _pickTime();
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                          child: Text(S.of(context).choose_start_time),
                        ),
                        if (_endTime == null)
                          Text(
                            S.of(context).choose_end_time,
                            style: const TextStyle(fontSize: 20),
                          ),
                        if (_endTime != null)
                          Text(S.of(context).end_time(_endTime!.format(context)),
                              style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await _pickTime();
                            if (pickedTime != null) {
                              setState(() {
                                _endTime = pickedTime; // 更新結束時間狀態
                              });
                            }
                          },
                          child: Text(S.of(context).choose_end_time),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        _dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask),
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
                                decoration: InputDecoration(
                                  labelText: S.of(context).execution_interval,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 10), // 為輸入框和下拉選單增加間距
                            Flexible(
                              flex: 1,
                              child: Text(S.of(context).minute),
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
                        _dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.oneTimeTask),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (_startTime == null)
                          Text(
                            S.of(context).set_trigger_time,
                            style: const TextStyle(fontSize: 20),
                          ),
                        if (_startTime != null)
                          Text(S.of(context).trigger_time(_startTime!.format(context)),
                              style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await _pickTime();
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                          child: Text(S.of(context).set_trigger_time),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(S.of(context).save, style: const TextStyle(fontSize: 20)),
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
        return TextPagingPopup(
          pageContents: [
            Text(S.of(context).task_edit_help_1,
                style: const TextStyle(fontSize: 18)),
            Text(S.of(context).task_edit_help_2,
                style: const TextStyle(fontSize: 18)),
            Text(S.of(context).task_edit_help_3,
                style: const TextStyle(fontSize: 18)),
            Text(S.of(context).task_edit_help_4,
                style: const TextStyle(fontSize: 18)),
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
      _showErrorPopup(S.of(context).error_no_task_name);
      return false;
    }
    if (_dailyTaskTypeValue == null || _dailyTaskTypeValue!.isEmpty) {
      _showErrorPopup(S.of(context).error_no_task_type);
      return false;
    }
    if ((_dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.durationTask) ||
            _dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask)) &&
        _startTime == null) {
      _showErrorPopup(S.of(context).error_no_start_time);
      return false;
    }
    if ((_dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.durationTask) ||
            _dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask)) &&
        _endTime == null) {
      _showErrorPopup(S.of(context).error_no_end_time);
      return false;
    }
    if (_dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask) &&
        _loopMin == null) {
      _showErrorPopup(S.of(context).error_no_execution_interval);
      return false;
    }
    if (_dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.oneTimeTask) &&
        _startTime == null) {
      _showErrorPopup(S.of(context).error_no_trigger_time);
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

  Task _getTask() {
    Task task;
    if (_dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.durationTask)) {
      task = DurationTask(_taskName!, TimeUtil.formatTimeOfDay(_startTime!), TimeUtil.formatTimeOfDay(_endTime!));
    } else if (_dailyTaskTypeValue == DailyTaskTypeValue.getValueByType(context, DailyTaskType.segmentedTask)) {
      task = SegmentedTask(_taskName!, TimeUtil.formatTimeOfDay(_startTime!), TimeUtil.formatTimeOfDay(_endTime!), _loopMin!);
    } else {
      task = OneTimeTask(_taskName!, TimeUtil.formatTimeOfDay(_startTime!));
    }
    return task;
  }

  Future<TimeOfDay?> _pickTime() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
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
