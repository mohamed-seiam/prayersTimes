part of 'notification_cubit.dart';

@immutable
abstract class PrayerTimesState {}

class PrayerTimesInitial extends PrayerTimesState {}
class PrayerTimesSuccess extends PrayerTimesState {}
class PrayerTimesLoading extends PrayerTimesState {}
class PrayerTimesFaliure extends PrayerTimesState {
  final String error;

  PrayerTimesFaliure(this.error);

}