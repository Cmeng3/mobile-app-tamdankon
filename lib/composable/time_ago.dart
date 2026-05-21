import 'package:intl/intl.dart';

String timeAgo(String datetime, DateTime now) {
  // becuase the datetime in database by default is the zulu time, so we add 7 hours to get our region-time-zone
  DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(datetime).add(const Duration(hours: 7));


  Duration difference = now.difference(parsedDate);

  if(difference.inSeconds < 60) {
    return 'Just now';
  } else if(difference.inMinutes < 60) {
    // also return check for the plural-term
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if(difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  }
}