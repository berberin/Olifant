import 'package:intl/intl.dart';

int daysRemaining(DateTime due) {
  var now = DateTime.now().toUtc();
  var diff = due.difference(now);
  return diff.inDays;
}

DateTime timeStampToDateTime(int timetampSeconds) {
  return DateTime.fromMillisecondsSinceEpoch(timetampSeconds);
}

String dateToDisplay(DateTime date) {
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}
