import 'package:dio/dio.dart';
import '../constance.dart';

class ApiServices {
  static Dio? dio;
   static String baseUrl = 'http://api.aladhan.com/v1/';
   String endPoint = 'timings/$formattedDate';

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 40),
          headers: {'Content-Type': 'application/json'}),
    );
  } //end init()
   Future<Response> getData(
      {required String endPoint, required Map<String, dynamic> query}) async {
    var response = await dio!.get(
      '$baseUrl$endPoint',
      queryParameters: query,
    );
    return response;
  }
}
