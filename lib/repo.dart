import 'models/adhan_model.dart';

abstract class Repo{
Future<AdhanModel> getPrayersTime({required double lat,required double lng,required int method});
}