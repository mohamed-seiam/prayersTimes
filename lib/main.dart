import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app_test/adhan_repo_iplement.dart';
import 'package:notification_app_test/api_services/api_services.dart';
import 'package:notification_app_test/cach_helper.dart';
import 'package:notification_app_test/models/adhan_model.dart';
import 'package:notification_app_test/screens/notification_home_test.dart';

import 'notification_bloc/notification_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await ApiServices.init();
  AwesomeNotifications().initialize(
      'resource://drawable/res_adhan',
      [
        NotificationChannel(
            channelKey: 'basic key',
            channelName: 'test channel',
            channelDescription: 'notification test',
          playSound: true,
          channelShowBadge: true,
          soundSource: 'resource://raw/res_adhan',
          importance: NotificationImportance.Max,
          criticalAlerts: true,
          enableVibration: true,
          enableLights: true,
          locked: true,
        )
      ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider
        (create: (context)=>PrayerTimesCubit(AdhanRepo(ApiServices()),AdhanModel())..determinePosition()..getPrayersTimes(),
        child: const NotificationHOmeTest()),
    );
  }
}


