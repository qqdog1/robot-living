import 'package:robot_living/const/daily_task_type.dart';

class DailyTaskTypeValue {
  static const String startEndTask = "起訖類";
  static const String oneTimeTask = "單次類";
  static const String segmentedTask = "分段類";

  static String getValueByType(DailyTaskType dailyTaskType) {
    switch (dailyTaskType) {
      case DailyTaskType.startEndTask:
        return startEndTask;
      case DailyTaskType.oneTimeTask:
        return oneTimeTask;
      case DailyTaskType.segmentedTask:
        return segmentedTask;
    }
  }
}
