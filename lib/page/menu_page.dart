import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot_living/page/historical_page.dart';
import 'package:robot_living/page/settings_page.dart';
import 'package:robot_living/page/today_page.dart';

import '../component/paging_popup.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedPage = 0;

  final _pageOptions = [
    const TodayPage(),
    const SettingsPage(),
    const HistoricalPage(),
  ];

  final _pageTitles = [
    '今日進度',
    '設定',
    '完成紀錄',
  ];

  final _pagePopupPageCount = [
    1,5,1
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
            icon: const Icon(Icons.question_mark_sharp),
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
                setState(() {
                  _selectedPage = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_pageTitles[1]),
              onTap: () {
                setState(() {
                  _selectedPage = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_pageTitles[2]),
              onTap: () {
                setState(() {
                  _selectedPage = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pageOptions[_selectedPage],
    );
  }

  Future<void> showHelpPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PagingPopup(
          totalPages: _pagePopupPageCount[_selectedPage],
          pageContents:_pagePopupContent[_selectedPage],
        );
      },
    );
  }
}