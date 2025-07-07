
// import 'package:roomly/features/request/domain/entities/request.dart';

// class RequestModel extends Request {
//   const RequestModel({
//     required super.id,
//     required super.type,
//     required super.requestDate,
//     required super.responseDate,
//     required super.details,
//     required super.status,
//     required super.requestResponse,
//   });

//   factory RequestModel.fromJson(Map<String, dynamic> json) {
//     return RequestModel(
//       id: json['id'],
//       type: json['type'],
//       requestDate: json['requestDate'],
//       responseDate: json['responseDate'],
//       details: json['details'],
//       status: json['status'],
//       requestResponse: json['requestResponse'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type,
//       'requestDate': requestDate,
//       'responseDate': responseDate,
//       'details': details,
//       'status': status,
//       'requestResponse': requestResponse,
//     };
//   }
// }



// v2 -------------------------------------------------------------------------------

import 'package:roomly/features/request/domain/entities/request.dart';
class RequestModel extends Request {
  const RequestModel({
    required super.id,
    required super.type,
    required super.requestDate,
    super.responseDate,
    required super.details,
    required super.status,
    super.requestResponse,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      type: json['type'] as String,
      requestDate: json['requestDate'] as String,
      responseDate: json['responseDate'] as String?,
      details: json['details'] as String,
      status: json['status'] as String,
      requestResponse: json['requestResponse'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'requestDate': requestDate,
      'responseDate': responseDate,
      'details': details,
      'status': status,
      'requestResponse': requestResponse,
    };
  }
}