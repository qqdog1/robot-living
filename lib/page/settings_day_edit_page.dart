import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/page/settings_task_edit_page.dart';

class SettingsDayEditPage extends StatefulWidget {
  const SettingsDayEditPage({super.key});

  @override
  _SettingsDayEditPageState createState() => _SettingsDayEditPageState();
}

class _SettingsDayEditPageState extends State<SettingsDayEditPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一日計畫設定'),
      ),
      body: Stack(
        children: [
          Column(
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
              IconButton(
                icon: const Icon(FontAwesomeIcons.plus),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsTaskEditPage(),
                  ));
                },
              ),
            ],
          ),
          // 底部中間的儲存按鈕
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
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
          ),
        ],
      ),
    );
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // 當焦點離開TextField時呼叫的方法
      _handleInputComplete();
    }
  }

  void _handleInputComplete() {
    // 在這裡處理用戶輸入完成後的邏輯
    print("用戶輸入的文字是: ${_controller.text}");
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
