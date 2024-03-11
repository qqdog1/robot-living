import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:robot_living/page/logo_page.dart';

import 'cache/user_settings_cache.dart';
import 'generated/l10n.dart';

void main() {
  initApp();
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserSettingsCache.instance;
  runApp(const RobotLiving());
}

class RobotLiving extends StatefulWidget {
  const RobotLiving({super.key});

  @override
  _RobotLivingState createState() => _RobotLivingState();
}

class _RobotLivingState extends State<RobotLiving> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = UserSettingsCache.instance.getLanguage();
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      debugShowCheckedModeBanner: false,
      home: const LogoPage(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
