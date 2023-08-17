import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:notification_app_test/models/adhan_model.dart';
import '../adhan_repo_iplement.dart';
import '../cach_helper.dart';

part 'notification_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit(this.adhanRepo, this.adhanModel)
      : super(PrayerTimesInitial());
  static PrayerTimesCubit getContext(context) => BlocProvider.of(context);

  AdhanRepo adhanRepo;
  AdhanModel adhanModel;
  double? lat;
  Position? value;

  double? lng;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    ).then((value) {
      lat = value.latitude;
      CacheHelper.saveData(key: 'lat', value: lat);
      lng = value.longitude;
      CacheHelper.saveData(key: 'lng', value: lng);
    });
  }

  List<String> prayersTimes = [];

  Future<void> getPrayersTimes() async {
    emit(PrayerTimesLoading());
    try {
      final prayertime = await adhanRepo
          .getPrayersTime(
          lat: CacheHelper.getData(key: 'lat') ?? 0,
          lng: CacheHelper.getData(key: 'lng') ?? 0,
          method: 5);
      adhanModel = prayertime;
      print('hna el cubit ${adhanModel.data!.timings!.isha}');
      prayersTimes = [
        prayertime.data!.timings!.fajr ?? '',
        prayertime.data!.timings!.dhuhr ?? '',
        prayertime.data!.timings!.asr ?? '',
        prayertime.data!.timings!.maghrib ?? '',
        prayertime.data!.timings!.isha ?? '',
      ];
      emit(PrayerTimesSuccess());
    } catch (error) {
      print(error.toString());
      emit(PrayerTimesFaliure(error.toString()));
    }
  }
}

