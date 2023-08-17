import 'package:notification_app_test/api_services/api_services.dart';
import 'package:notification_app_test/models/adhan_model.dart';
import 'package:notification_app_test/repo.dart';

class AdhanRepo implements Repo {
  final ApiServices apiServices;

  AdhanRepo(this.apiServices);

  @override
  Future<AdhanModel> getPrayersTime(
      {required double lat, required double lng, required int method}) async {
    AdhanModel adhanModel = AdhanModel();
    var query = {
      'latitude': lat,
      'longitude': lng,
      'method': method,
    };
    try {
      var response = await apiServices.getData(
          endPoint: apiServices.endPoint, query: query);
      if (response.statusCode == 200) {
        adhanModel = AdhanModel.fromJson(response.data);
        print(response.data);
      } else {
        throw response.data["data"];
      }
      return adhanModel;
    } catch (error) {
      rethrow;
    }
  }
}
