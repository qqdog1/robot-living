import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';

class TimeUnitValue {
  static String hour(BuildContext context) => S.of(context).hour;
  static String minute(BuildContext context) => S.of(context).minute;
  static String second(BuildContext context) => S.of(context).second;
}