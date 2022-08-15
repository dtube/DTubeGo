import 'package:jiffy/jiffy.dart';

bool timestampGreater7Days(int timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  return diff.inDays >= 7;
}

class TimeAgo {
  static String timeAgoClaimIn(int ts) {
    return timeInAgoDate(
        DateTime.fromMillisecondsSinceEpoch(ts).add(new Duration(days: 7)));
  }

  static String timeInAgoTS(int ts) {
    return Jiffy(DateTime.fromMillisecondsSinceEpoch(ts)).fromNow();
  }

  static String timeInAgoTSShort(int ts) {
    // return Jiffy(DateTime.fromMillisecondsSinceEpoch(ts)).fromNow();
    return Jiffy(DateTime.fromMillisecondsSinceEpoch(ts))
        .fromNow()
        .replaceAll("minute", "min")
        .replaceAll("second", "sec");
  }

  static String timeInAgoDate(DateTime date) {
    return Jiffy(date).fromNow();
  }
}
