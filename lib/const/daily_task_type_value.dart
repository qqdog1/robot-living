import 'package:flutter/cupertino.dart';
import 'package:robot_living/const/daily_task_type.dart';

import '../generated/l10n.dart';

class DailyTaskTypeValue {

  static String getValueByType(BuildContext context, DailyTaskType dailyTaskType) {
    switch (dailyTaskType) {
      case DailyTaskType.durationTask:
        return S.of(context).duration_type;
      case DailyTaskType.oneTimeTask:
        return S.of(context).one_time_type;
      case DailyTaskType.segmentedTask:
        return S.of(context).segmented_type;
    }
  }
}
