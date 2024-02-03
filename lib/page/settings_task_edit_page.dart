import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../component/combobox.dart';
import '../component/paging_popup.dart';
import '../const/daily_task_type_value.dart';

class SettingsTaskEditPage extends StatefulWidget {
  const SettingsTaskEditPage({super.key});

  @override
  _SettingsTaskEditPageState createState() => _SettingsTaskEditPageState();
}

class _SettingsTaskEditPageState extends State<SettingsTaskEditPage> {
  String? dailyTaskTypeValue;
  TextEditingController textEditingController = TextEditingController();
  bool isFirstComboInput = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任務及通知設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '任務名稱:',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: '請輸入名稱',
              ),
            ),
            const Text(
              '任務類型:',
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
                  onItemChanged: (newValue) {
                    setState(() {
                      dailyTaskTypeValue = newValue;
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
              visible: dailyTaskTypeValue == DailyTaskTypeValue.startEndTask ||
                  dailyTaskTypeValue == DailyTaskTypeValue.segmentedTask,
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
          ],
        ),
      ),
    );
  }

  Future<void> showTypeHelpPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PagingPopup(
          totalPages: 4,
          pageContents: [
            Text('任務分三種類型:\n1.起訖類型\n2.分段類型\n3.一次性',
                style: TextStyle(fontSize: 18)),
            Text(
                '起訖類型任務需要設定\n開始時間及結束時間,\n若是想養成早睡早起的習慣,就適合把睡覺設定成起訖行任務\n又或是每日晚間養成定時讀書的習慣也很適合加入一個起訖型的任務',
                style: TextStyle(fontSize: 18)),
            Text(
                '分段類的任務適合放一些每日需要被階段完成的目標\n若訂下了每天需要喝水2500CC,從早上10點開始到晚上8點\n並分成10段\n讓程式再每隔一段時間提醒喝250CC的水\n或是每日做100下伏地挺身\n也可以讓程式協助分段提醒',
                style: TextStyle(fontSize: 18)),
            Text(
                '一次型的任務只須設定一個時間點,讓程式提醒你去做某件事\n像是每天早上10點要記得煮水或是晚上10點要關玄關的燈\n各種執行起來不會花太多時間又或是容易忘記的事情都很適合加入',
                style: TextStyle(fontSize: 18)),
          ],
        );
      },
    );
  }
}
