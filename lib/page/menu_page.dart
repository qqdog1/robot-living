import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:robot_living/cache/user_settings_cache.dart';
import 'package:robot_living/const/language.dart';
import 'package:robot_living/page/settings_page.dart';

import '../component/text_paging_popup.dart';
import '../generated/l10n.dart';
import '../main.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedPage = 0;

  Widget _getPageWidget(int index) {
    switch (index) {
      default:
        return const SettingsPage();

      // case 0:
      //   return const TodayPage();
      // case 1:
      //   return const SettingsPage();
      // case 2:
      //   return const HistoricalPage();
      // default:
      //   return const SettingsPage();
    }
  }

  List<String> get _pageTitles => [
        // S.of(context).menu_today_progress,
        S.of(context).menu_schedule_settings,
        // S.of(context).menu_completion_records,
      ];

  // List<List<Text>> get _pagePopupContent {
  //   return [
      // [
      //   Text(S.of(context).menu_today_help_1),
      //   Text(S.of(context).menu_today_help_2),
      // ],
      // [
      //   Text(S.of(context).menu_settings_help_1),
      // ],
      // [
      //   Text(S.of(context).menu_historical_help_1),
      // ],
    // ];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedPage]),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showHelpPopup(context);
        //     },
        //     icon: const Icon(FontAwesomeIcons.circleQuestion),
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 60), // 顶部填充20像素
                  ),
                  ListTile(
                    title: Text(_pageTitles[0]),
                    onTap: () {
                      clickDrawer(0);
                      Navigator.pop(context);
                    },
                  ),
                  // ListTile(
                  //   title: Text(_pageTitles[1]),
                  //   onTap: () {
                  //     clickDrawer(1);
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(_pageTitles[2]),
                  //   onTap: () {
                  //     clickDrawer(2);
                  //     Navigator.pop(context);
                  //   },
                  // ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.language),
                onTap: () {
                  _toggleLanguage();
                },
              ),
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

  // Future<void> showHelpPopup(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return TextPagingPopup(
  //         pageContents: _pagePopupContent[_selectedPage],
  //       );
  //     },
  //   );
  // }

  Future<void> _toggleLanguage() async {
    final userSettingsCache = await UserSettingsCache.getInstance();
    String language = userSettingsCache.getLanguage();
    if (language == Language.chinese) {
      userSettingsCache.setLanguage(Language.english);
      Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale(Language.english));
    } else {
      userSettingsCache.setLanguage(Language.chinese);
      Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale(Language.chinese));
    }
  }
}
