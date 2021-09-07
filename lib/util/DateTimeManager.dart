import 'package:flutter/services.dart';

class DateTimeManager {
  static String currentDateTime() {
    var dateTime = DateTime.now();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}  ${dateTime.hour}:${dateTime.minute}';
  }
}
