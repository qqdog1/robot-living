// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(endTime) => "結束時間: ${endTime}";

  static String m1(loopMin) => "執行間格: ${loopMin}";

  static String m2(startTime) => "開始時間: ${startTime}";

  static String m3(triggerTime) => "觸發時間: ${triggerTime}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "choose_end_time": MessageLookupByLibrary.simpleMessage("選擇結束時間: "),
        "choose_start_time": MessageLookupByLibrary.simpleMessage("選擇開始時間: "),
        "duration_type": MessageLookupByLibrary.simpleMessage("起訖類"),
        "end_time": m0,
        "error_no_end_time": MessageLookupByLibrary.simpleMessage("請設定結束時間"),
        "error_no_execution_interval":
            MessageLookupByLibrary.simpleMessage("請設定執行間隔"),
        "error_no_plan_name": MessageLookupByLibrary.simpleMessage("請輸入計畫名稱"),
        "error_no_settings_made":
            MessageLookupByLibrary.simpleMessage("無任何設定無須儲存"),
        "error_no_start_time": MessageLookupByLibrary.simpleMessage("請設定開始時間"),
        "error_no_task_name": MessageLookupByLibrary.simpleMessage("請輸入任務名稱"),
        "error_no_task_type": MessageLookupByLibrary.simpleMessage("請選擇任務類型"),
        "error_no_trigger_time":
            MessageLookupByLibrary.simpleMessage("請設定觸發時間"),
        "execution_interval": MessageLookupByLibrary.simpleMessage("執行間格"),
        "execution_interval_input": m1,
        "friday": MessageLookupByLibrary.simpleMessage("五"),
        "hour": MessageLookupByLibrary.simpleMessage("時"),
        "input_ex_plan_name":
            MessageLookupByLibrary.simpleMessage("EX: 準時下班計畫"),
        "input_ex_task_name": MessageLookupByLibrary.simpleMessage("EX: 定時學習"),
        "input_plan_name": MessageLookupByLibrary.simpleMessage("輸入計畫名稱"),
        "input_task_name": MessageLookupByLibrary.simpleMessage("輸入任務名稱"),
        "menu_1_help_1": MessageLookupByLibrary.simpleMessage("menu 1 說明第一頁"),
        "menu_1_help_2": MessageLookupByLibrary.simpleMessage("menu 1 說明第二頁"),
        "menu_2_help_1": MessageLookupByLibrary.simpleMessage("menu 2 說明第一頁"),
        "menu_3_help_1": MessageLookupByLibrary.simpleMessage("menu 3 說明第一頁"),
        "menu_completion_records": MessageLookupByLibrary.simpleMessage("完成紀錄"),
        "menu_project_settings": MessageLookupByLibrary.simpleMessage("計畫設定"),
        "menu_today_progress": MessageLookupByLibrary.simpleMessage("今日進度"),
        "minute": MessageLookupByLibrary.simpleMessage("分"),
        "monday": MessageLookupByLibrary.simpleMessage("一"),
        "ok": MessageLookupByLibrary.simpleMessage("確定"),
        "one_time_type": MessageLookupByLibrary.simpleMessage("單次類"),
        "saturday": MessageLookupByLibrary.simpleMessage("六"),
        "save": MessageLookupByLibrary.simpleMessage("儲存"),
        "second": MessageLookupByLibrary.simpleMessage("秒"),
        "segmented_type": MessageLookupByLibrary.simpleMessage("分段類"),
        "set_trigger_time": MessageLookupByLibrary.simpleMessage("設定觸發時間: "),
        "skip": MessageLookupByLibrary.simpleMessage("跳過"),
        "start_time": m2,
        "sunday": MessageLookupByLibrary.simpleMessage("日"),
        "task_edit_help_1": MessageLookupByLibrary.simpleMessage(
            "任務分三種類型:\n1.起訖類型\n2.分段類型\n3.一次性"),
        "task_edit_help_2": MessageLookupByLibrary.simpleMessage(
            "起訖類型任務需要設定\n開始時間及結束時間,\n若是想養成早睡早起的習慣,就適合把睡覺設定成起訖行任務\n又或是每日晚間養成定時讀書的習慣也很適合加入一個起訖型的任務"),
        "task_edit_help_3": MessageLookupByLibrary.simpleMessage(
            "分段類的任務適合放一些每日需要被階段完成的目標\n若訂下了每天需要喝足夠的水,從早上10點開始到晚上8點\n每隔40分鐘提醒\n或是每日做100下伏地挺身\n也可以讓程式協助分段提醒"),
        "task_edit_help_4": MessageLookupByLibrary.simpleMessage(
            "一次型的任務只須設定一個時間點,讓程式提醒你去做某件事\n像是每天早上10點要記得煮水或是晚上10點要關玄關的燈\n各種執行起來不會花太多時間又或是容易忘記的事情都很適合加入"),
        "task_type": MessageLookupByLibrary.simpleMessage("任務類型:"),
        "thursday": MessageLookupByLibrary.simpleMessage("四"),
        "title_daily_plan_settings":
            MessageLookupByLibrary.simpleMessage("一日計畫設定"),
        "title_task_nof_settings":
            MessageLookupByLibrary.simpleMessage("任務及通知設定"),
        "trigger_time": m3,
        "tuesday": MessageLookupByLibrary.simpleMessage("二"),
        "wednesday": MessageLookupByLibrary.simpleMessage("三")
      };
}
