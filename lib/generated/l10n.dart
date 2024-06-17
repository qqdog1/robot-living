// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Today's Progress`
  String get menu_today_progress {
    return Intl.message(
      'Today\'s Progress',
      name: 'menu_today_progress',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Settings`
  String get menu_schedule_settings {
    return Intl.message(
      'Schedule Settings',
      name: 'menu_schedule_settings',
      desc: '',
      args: [],
    );
  }

  /// `Completion Records`
  String get menu_completion_records {
    return Intl.message(
      'Completion Records',
      name: 'menu_completion_records',
      desc: '',
      args: [],
    );
  }

  /// `Daily Plan Settings`
  String get title_daily_plan_settings {
    return Intl.message(
      'Daily Plan Settings',
      name: 'title_daily_plan_settings',
      desc: '',
      args: [],
    );
  }

  /// `Task and Notification Settings`
  String get title_task_nof_settings {
    return Intl.message(
      'Task and Notification Settings',
      name: 'title_task_nof_settings',
      desc: '',
      args: [],
    );
  }

  /// `Enter Plan Name`
  String get input_plan_name {
    return Intl.message(
      'Enter Plan Name',
      name: 'input_plan_name',
      desc: '',
      args: [],
    );
  }

  /// `EX: work smart day`
  String get input_ex_plan_name {
    return Intl.message(
      'EX: work smart day',
      name: 'input_ex_plan_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Task Name`
  String get input_task_name {
    return Intl.message(
      'Enter Task Name',
      name: 'input_task_name',
      desc: '',
      args: [],
    );
  }

  /// `EX: Study`
  String get input_ex_task_name {
    return Intl.message(
      'EX: Study',
      name: 'input_ex_task_name',
      desc: '',
      args: [],
    );
  }

  /// `Task Type:`
  String get task_type {
    return Intl.message(
      'Task Type:',
      name: 'task_type',
      desc: '',
      args: [],
    );
  }

  /// `Duration Type`
  String get duration_type {
    return Intl.message(
      'Duration Type',
      name: 'duration_type',
      desc: '',
      args: [],
    );
  }

  /// `One-time Type`
  String get one_time_type {
    return Intl.message(
      'One-time Type',
      name: 'one_time_type',
      desc: '',
      args: [],
    );
  }

  /// `Segmented Type`
  String get segmented_type {
    return Intl.message(
      'Segmented Type',
      name: 'segmented_type',
      desc: '',
      args: [],
    );
  }

  /// `Choose Start Time: `
  String get choose_start_time {
    return Intl.message(
      'Choose Start Time: ',
      name: 'choose_start_time',
      desc: '',
      args: [],
    );
  }

  /// `Start Time: {startTime}`
  String start_time(Object startTime) {
    return Intl.message(
      'Start Time: $startTime',
      name: 'start_time',
      desc: '',
      args: [startTime],
    );
  }

  /// `Choose End Time: `
  String get choose_end_time {
    return Intl.message(
      'Choose End Time: ',
      name: 'choose_end_time',
      desc: '',
      args: [],
    );
  }

  /// `End Time: {endTime}`
  String end_time(Object endTime) {
    return Intl.message(
      'End Time: $endTime',
      name: 'end_time',
      desc: '',
      args: [endTime],
    );
  }

  /// `Set Trigger Time: `
  String get set_trigger_time {
    return Intl.message(
      'Set Trigger Time: ',
      name: 'set_trigger_time',
      desc: '',
      args: [],
    );
  }

  /// `Trigger Time: {triggerTime}`
  String trigger_time(Object triggerTime) {
    return Intl.message(
      'Trigger Time: $triggerTime',
      name: 'trigger_time',
      desc: '',
      args: [triggerTime],
    );
  }

  /// `Execution Interval: {loopMin}`
  String execution_interval_input(Object loopMin) {
    return Intl.message(
      'Execution Interval: $loopMin',
      name: 'execution_interval_input',
      desc: '',
      args: [loopMin],
    );
  }

  /// `Execution Interval`
  String get execution_interval {
    return Intl.message(
      'Execution Interval',
      name: 'execution_interval',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled Days`
  String get scheduled_days {
    return Intl.message(
      'Scheduled Days',
      name: 'scheduled_days',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message(
      'skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get monday {
    return Intl.message(
      'Mon',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tuesday {
    return Intl.message(
      'Tue',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wednesday {
    return Intl.message(
      'Wed',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thus`
  String get thursday {
    return Intl.message(
      'Thus',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get friday {
    return Intl.message(
      'Fri',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get saturday {
    return Intl.message(
      'Sat',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sunday {
    return Intl.message(
      'Sun',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get minute {
    return Intl.message(
      'Minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `menu_today_help_1`
  String get menu_today_help_1 {
    return Intl.message(
      'menu_today_help_1',
      name: 'menu_today_help_1',
      desc: '',
      args: [],
    );
  }

  /// `menu_today_help_2`
  String get menu_today_help_2 {
    return Intl.message(
      'menu_today_help_2',
      name: 'menu_today_help_2',
      desc: '',
      args: [],
    );
  }

  /// `menu_settings_help_1`
  String get menu_settings_help_1 {
    return Intl.message(
      'menu_settings_help_1',
      name: 'menu_settings_help_1',
      desc: '',
      args: [],
    );
  }

  /// `menu_historical_help_1`
  String get menu_historical_help_1 {
    return Intl.message(
      'menu_historical_help_1',
      name: 'menu_historical_help_1',
      desc: '',
      args: [],
    );
  }

  /// `task have 3 different types:\n1. duration type\n2. segmented type\n3. one time type`
  String get task_edit_help_1 {
    return Intl.message(
      'task have 3 different types:\n1. duration type\n2. segmented type\n3. one time type',
      name: 'task_edit_help_1',
      desc: '',
      args: [],
    );
  }

  /// `blahblahblah`
  String get task_edit_help_2 {
    return Intl.message(
      'blahblahblah',
      name: 'task_edit_help_2',
      desc: '',
      args: [],
    );
  }

  /// `cooooool`
  String get task_edit_help_3 {
    return Intl.message(
      'cooooool',
      name: 'task_edit_help_3',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get task_edit_help_4 {
    return Intl.message(
      'ok',
      name: 'task_edit_help_4',
      desc: '',
      args: [],
    );
  }

  /// `Notifications may fail in certain situations,\nsuch as after a reboot, enabling airplane mode, or due to a bug.\nWhen notifications fail, pressing the reset button can help restore normal functionality.`
  String get reset_help {
    return Intl.message(
      'Notifications may fail in certain situations,\nsuch as after a reboot, enabling airplane mode, or due to a bug.\nWhen notifications fail, pressing the reset button can help restore normal functionality.',
      name: 'reset_help',
      desc: '',
      args: [],
    );
  }

  /// `reset`
  String get reset {
    return Intl.message(
      'reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `No settings made.`
  String get error_no_settings_made {
    return Intl.message(
      'No settings made.',
      name: 'error_no_settings_made',
      desc: '',
      args: [],
    );
  }

  /// `No plan name.`
  String get error_no_plan_name {
    return Intl.message(
      'No plan name.',
      name: 'error_no_plan_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter task name.`
  String get error_no_task_name {
    return Intl.message(
      'Please enter task name.',
      name: 'error_no_task_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter task type.`
  String get error_no_task_type {
    return Intl.message(
      'Please enter task type.',
      name: 'error_no_task_type',
      desc: '',
      args: [],
    );
  }

  /// `Please set start time.`
  String get error_no_start_time {
    return Intl.message(
      'Please set start time.',
      name: 'error_no_start_time',
      desc: '',
      args: [],
    );
  }

  /// `Please set end time.`
  String get error_no_end_time {
    return Intl.message(
      'Please set end time.',
      name: 'error_no_end_time',
      desc: '',
      args: [],
    );
  }

  /// `Please set execution interval.`
  String get error_no_execution_interval {
    return Intl.message(
      'Please set execution interval.',
      name: 'error_no_execution_interval',
      desc: '',
      args: [],
    );
  }

  /// `Please set trigger time.`
  String get error_no_trigger_time {
    return Intl.message(
      'Please set trigger time.',
      name: 'error_no_trigger_time',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
