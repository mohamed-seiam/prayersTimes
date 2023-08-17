import 'package:notification_app_test/models/prayer_time_model.dart';

class Data {
  Timings ? timings;
  Data({required this.timings});

  Data.fromJson(Map<String, dynamic> json) {
    timings = Timings.fromJson(json['timings']);
  }
}
