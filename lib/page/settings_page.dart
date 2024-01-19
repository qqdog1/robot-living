import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool _showPlus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: Visibility(
                visible: _showPlus,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _showPlus = false;
                    });
                    showSettingsPopup(context);
                  },
                  child: const Icon(FontAwesomeIcons.plus),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Future<void> showSettingsPopup(BuildContext context) async {
    String dropdownValue = '起訖類'; // 初始選項，放在函數外部

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // 使用 StatefulBuilder
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('新增通知'),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.xmark),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('通知類型'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(FontAwesomeIcons.caretDown),
                            onChanged: (String? newValue) {
                              setState(() { // 更新 dropdownValue
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['起訖類', '分段類', '單次類']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
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
          },
        );
      },
    );
    // 關閉這個popup後必須再次顯示加號
    setState(() {
      _showPlus = true;
    });
  }
}
