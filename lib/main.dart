import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:robot_living/page/logo_page.dart';

import 'cache/user_settings_cache.dart';
import 'generated/l10n.dart';

void main() {
  initApp();
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await requestExactAlarmPermission();
    final localeProvider = LocaleProvider();
    await localeProvider.init(); // 初始化LocaleProvider
    runApp(ChangeNotifierProvider(
      create: (context) => localeProvider,
      child: const RobotLiving(),
    ));
  } catch (e, stackTrace) {
    print("Error during app initialization: $e");
    print(stackTrace);
  }
}

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 31) { // Android 12 (API 31) and above
      // 檢查 SCHEDULE_EXACT_ALARM 權限狀態
      var status = await Permission.scheduleExactAlarm.status;

      if (status.isDenied) {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      }
    }
  }
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('zh');

  Locale get locale => _locale;

  Future<void> init() async {
    final userSettingsCache = await UserSettingsCache.getInstance();
    final languageCode = userSettingsCache.getLanguage();
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

class RobotLiving extends StatefulWidget {
  const RobotLiving({super.key});

  @override
  _RobotLivingState createState() => _RobotLivingState();
}

class _RobotLivingState extends State<RobotLiving> {
  // static const platform = MethodChannel('robot_inner');
  late Locale _locale;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadLocale();
    // _setupMethodChannel();
  }

  Future<void> _loadLocale() async {
    final userSettingsCache = await UserSettingsCache.getInstance();
    final languageCode = userSettingsCache.getLanguage();
    setState(() {
      _locale = Locale(languageCode);
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    if (!_loaded) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return MaterialApp(
      locale: localeProvider._locale,
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
