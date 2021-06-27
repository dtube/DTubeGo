import 'package:intl/intl.dart';

String friendlyTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';
  if (diff.inSeconds > 0) {
    if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }
  } else {
    if (diff.inDays > -1) {
      if (diff.inHours == -1) {
        time = 'in ' + (diff.inHours * -1).toString() + ' hour';
      } else {
        time = 'in ' + (diff.inHours * -1).toString() + ' hours';
      }
    } else {
      if (diff.inDays > -7 && diff.inDays < 0) {
        if (diff.inDays == -1) {
          time = 'in ' + (diff.inDays * -1).toString() + ' day';
        } else {
          time = 'in ' + (diff.inDays * -1).toString() + ' days';
        }
      } else {
        if (diff.inDays == -7) {
          time = 'in ' + ((diff.inDays / 7).floor() * -1).toString() + ' week';
        } else {
          time = 'v ' + ((diff.inDays / 7).floor() * -1).toString() + ' weeks';
        }
      }
    }
  }

  return time;
}

bool timestampGreater7Days(int timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  return diff.inDays >= 7;
}

String timestamp7Days(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var dateAfter7Days = date.add(new Duration(days: 7));
  return friendlyTimestamp(dateAfter7Days.millisecondsSinceEpoch);
}
