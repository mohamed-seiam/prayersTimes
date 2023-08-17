import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationHandelr{
 static void scheduleNotifications({required List<String> prayerTimes}) async {
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    for (int index = 0; index < prayerTimes.length; index++) {
      List<int> timeParts = prayerTimes[index].split(':').map(int.parse).toList();
      DateTime now = DateTime.now();
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        timeParts[0],
        timeParts[1],
      );

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: index,
          channelKey: 'basic key',
          title: 'Prayer Time Notification',
          body: 'It\'s time for prayer ${index + 1}!',
          displayOnBackground: true,
          displayOnForeground: true,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: 'asset://assets/adhan.png',
        ),
        schedule:NotificationCalendar(
          hour: scheduledDate.hour,
          minute: scheduledDate.minute,
          second: 0,
          repeats: true,
          allowWhileIdle: true,
          timeZone: localTimeZone,
          preciseAlarm: true,
        ),
      );
    }
  }

static void cancelNotifications({required List<String> prayerTimes}) {
   for (int index = 0; index < prayerTimes.length; index++) {
     AwesomeNotifications().cancel(index);
   }
 }
}



