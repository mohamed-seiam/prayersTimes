import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

DateTime now = DateTime.now();

String formattedDate = DateFormat('DD-MM-YYYY').format(now);

TimeOfDay stringToTimeOfDay(String time) {
  final format = intl.DateFormat.Hm();
  return TimeOfDay.fromDateTime(format.parse(time));
}
