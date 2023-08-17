import 'data_model.dart';

class AdhanModel {
  int? code;
  String? status;
  Data ? data;

  AdhanModel({this.code, this.status,this.data});

  AdhanModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data =  Data.fromJson(json['data']);
  }
}
