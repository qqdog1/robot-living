// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(endTime) => "End Time: ${endTime}";

  static String m1(loopMin) => "Execution Interval: ${loopMin}";

  static String m2(startTime) => "Start Time: ${startTime}";

  static String m3(triggerTime) => "Trigger Time: ${triggerTime}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "choose_end_time":
            MessageLookupByLibrary.simpleMessage("Choose End Time: "),
        "choose_start_time":
            MessageLookupByLibrary.simpleMessage("Choose Start Time: "),
        "currently_executing":
            MessageLookupByLibrary.simpleMessage("Currently Executing"),
        "duration_type": MessageLookupByLibrary.simpleMessage("Duration Type"),
        "end_time": m0,
        "error_no_end_time":
            MessageLookupByLibrary.simpleMessage("Please set end time."),
        "error_no_execution_interval": MessageLookupByLibrary.simpleMessage(
            "Please set execution interval."),
        "error_no_plan_name":
            MessageLookupByLibrary.simpleMessage("No plan name."),
        "error_no_settings_made":
            MessageLookupByLibrary.simpleMessage("No settings made."),
        "error_no_start_time":
            MessageLookupByLibrary.simpleMessage("Please set start time."),
        "error_no_task_name":
            MessageLookupByLibrary.simpleMessage("Please enter task name."),
        "error_no_task_type":
            MessageLookupByLibrary.simpleMessage("Please enter task type."),
        "error_no_trigger_time":
            MessageLookupByLibrary.simpleMessage("Please set trigger time."),
        "execution_interval":
            MessageLookupByLibrary.simpleMessage("Execution Interval"),
        "execution_interval_input": m1,
        "friday": MessageLookupByLibrary.simpleMessage("Fri"),
        "hour": MessageLookupByLibrary.simpleMessage("Hour"),
        "input_ex_plan_name":
            MessageLookupByLibrary.simpleMessage("EX: work smart day"),
        "input_ex_task_name": MessageLookupByLibrary.simpleMessage("EX: Study"),
        "input_plan_name":
            MessageLookupByLibrary.simpleMessage("Enter Plan Name"),
        "input_task_name":
            MessageLookupByLibrary.simpleMessage("Enter Task Name"),
        "menu_completion_records":
            MessageLookupByLibrary.simpleMessage("Completion Records"),
        "menu_historical_help_1":
            MessageLookupByLibrary.simpleMessage("menu_historical_help_1"),
        "menu_schedule_settings":
            MessageLookupByLibrary.simpleMessage("Schedule Settings"),
        "menu_settings_help_1":
            MessageLookupByLibrary.simpleMessage("menu_settings_help_1"),
        "menu_today_help_1":
            MessageLookupByLibrary.simpleMessage("menu_today_help_1"),
        "menu_today_help_2":
            MessageLookupByLibrary.simpleMessage("menu_today_help_2"),
        "menu_today_progress":
            MessageLookupByLibrary.simpleMessage("Today\'s Progress"),
        "minute": MessageLookupByLibrary.simpleMessage("Minute"),
        "monday": MessageLookupByLibrary.simpleMessage("Mon"),
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "one_time_type": MessageLookupByLibrary.simpleMessage("One-time Type"),
        "reset": MessageLookupByLibrary.simpleMessage("reset"),
        "reset_help": MessageLookupByLibrary.simpleMessage(
            "Notifications may fail in certain situations,\nsuch as after a reboot, enabling airplane mode.\nWhen notifications fail, pressing the reset button can help restore normal functionality."),
        "saturday": MessageLookupByLibrary.simpleMessage("Sat"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "scheduled_days":
            MessageLookupByLibrary.simpleMessage("Scheduled Days"),
        "second": MessageLookupByLibrary.simpleMessage("Second"),
        "segmented_type":
            MessageLookupByLibrary.simpleMessage("Segmented Type"),
        "set_trigger_time":
            MessageLookupByLibrary.simpleMessage("Set Trigger Time: "),
        "skip": MessageLookupByLibrary.simpleMessage("skip"),
        "start_time": m2,
        "sunday": MessageLookupByLibrary.simpleMessage("Sun"),
        "task_edit_help_1": MessageLookupByLibrary.simpleMessage(
            "task have 3 different types:\n1. duration type\n2. segmented type\n3. one time type"),
        "task_edit_help_2":
            MessageLookupByLibrary.simpleMessage("blahblahblah"),
        "task_edit_help_3": MessageLookupByLibrary.simpleMessage("cooooool"),
        "task_edit_help_4": MessageLookupByLibrary.simpleMessage("ok"),
        "task_type": MessageLookupByLibrary.simpleMessage("Task Type:"),
        "thursday": MessageLookupByLibrary.simpleMessage("Thus"),
        "title_daily_plan_settings":
            MessageLookupByLibrary.simpleMessage("Daily Plan Settings"),
        "title_task_nof_settings": MessageLookupByLibrary.simpleMessage(
            "Task and Notification Settings"),
        "trigger_time": m3,
        "tuesday": MessageLookupByLibrary.simpleMessage("Tue"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Wed")
      };
}
