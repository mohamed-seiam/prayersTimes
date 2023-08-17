import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app_test/cach_helper.dart';
import 'package:notification_app_test/notification_bloc/notification_cubit.dart';
import 'package:notification_app_test/notification_handelr.dart';

import '../constance.dart';

class NotificationHOmeTest extends StatefulWidget {
  const NotificationHOmeTest({Key? key}) : super(key: key);

  @override
  State<NotificationHOmeTest> createState() => _NotificationHOmeTestState();
}

class _NotificationHOmeTestState extends State<NotificationHOmeTest> {
  @override
  void initState() {
    CacheHelper.getData(key: 'areNotificationsScheduled') ?? false;
    AwesomeNotifications().isNotificationAllowed().then((notificationAllowed) {
      if (!notificationAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: const Text(
                  'Allow',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: RefreshIndicator(
        onRefresh: () async {
          await PrayerTimesCubit.getContext(context).getPrayersTimes();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, state) {
              var cubit = BlocProvider.of<PrayerTimesCubit>(context).adhanModel;
              return state is PrayerTimesLoading
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          'استني يا عصام ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                    )
                  : Builder(builder: (context) {
                      List<TimeOfDay> prayerTimesTiming = [];
                      List<String> prayersName = [];
                      if (cubit.data != null) {
                        prayerTimesTiming = [
                          stringToTimeOfDay(cubit.data!.timings!.fajr!),
                          stringToTimeOfDay(cubit.data!.timings!.dhuhr!),
                          stringToTimeOfDay(cubit.data!.timings!.asr!),
                          stringToTimeOfDay(cubit.data!.timings!.maghrib!),
                          stringToTimeOfDay(cubit.data!.timings!.isha!),
                        ];
                        prayersName = [
                          'الفجر',
                          'الضهر',
                          'العصر',
                          'المغرب',
                          'العشاء',
                        ];
                      }
                      return Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Enable Notifications'),
                            value: CacheHelper.getData(
                                    key: 'areNotificationsScheduled') ??
                                false,
                            onChanged: toggleNotifications,
                          ),
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                BlocProvider.of<PrayerTimesCubit>(context)
                                    .prayersTimes
                                    .length,
                            itemBuilder: (context, index) {
                              return buildPrayerRow(
                                  prayerName: prayersName[index],
                                  time:
                                      prayerTimesTiming[index].format(context));
                            },
                          ),
                        ],
                      );
                    });
            },
          ),
        ),
      ),
    );
  }

  Widget buildPrayerRow({required String prayerName, required String time}) {
    return ListTile(
      title: Text(prayerName),
      subtitle: Text(time),
    );
  }

  void toggleNotifications(bool value) {
    setState(() {
      CacheHelper.saveData(key: 'areNotificationsScheduled', value: value);
      if (value) {
        NotificationHandelr.scheduleNotifications(
            prayerTimes:
                BlocProvider.of<PrayerTimesCubit>(context).prayersTimes);
      } else {
        NotificationHandelr.cancelNotifications(
            prayerTimes:
                BlocProvider.of<PrayerTimesCubit>(context).prayersTimes);
      }
    });
  }
}
