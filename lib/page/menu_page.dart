import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robot_living/page/historical_page.dart';
import 'package:robot_living/page/settings_page.dart';
import 'package:robot_living/page/today_page.dart';

import '../component/text_paging_popup.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedPage = 0;

  Widget _getPageWidget(int index) {
    switch (index) {
      case 0:
        return const TodayPage();
      case 1:
        return const SettingsPage();
      case 2:
        return const HistoricalPage();
      default:
        return const SettingsPage();
    }
  }

  final _pageTitles = [
    '今日進度',
    '設定',
    '完成紀錄',
  ];

  final _pagePopupContent = [
    [
      const Text('第一頁說明'),
    ],
    [
      const Text('這頁用來設定'),
      const Text('好好好好好好好好\n'
          '好好好好好好好好好好'),
      const Text('OKOKOKOKOK'),
      const Text('GOOOOOOOOOOOOOOOD'),
      const Text('!!!'),
    ],
    [
      const Text('說明'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedPage]),
        actions: [
          IconButton(
            onPressed: () {
              showHelpPopup(context);
            },
            icon: const Icon(FontAwesomeIcons.circleQuestion),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // ... Drawer items ...
            ListTile(
              title: Text(_pageTitles[0]),
              onTap: () {
                clickDrawer(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_pageTitles[1]),
              onTap: () {
                clickDrawer(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_pageTitles[2]),
              onTap: () {
                clickDrawer(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _getPageWidget(_selectedPage),
    );
  }

  void clickDrawer(int index) {
    if (_selectedPage != index) {
      setState(() {
        _selectedPage = index;
      });
    }
  }

  Future<void> showHelpPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TextPagingPopup(
          pageContents: _pagePopupContent[_selectedPage],
        );
      },
    );
  }
}
