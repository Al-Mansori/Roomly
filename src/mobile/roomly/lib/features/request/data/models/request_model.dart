
import 'package:roomly/features/request/domain/entities/request.dart';

class RequestModel extends Request {
  const RequestModel({
    required super.id,
    required super.type,
    required super.requestDate,
    required super.responseDate,
    required super.details,
    required super.status,
    required super.requestResponse,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      type: json['type'],
      requestDate: json['requestDate'],
      responseDate: json['responseDate'],
      details: json['details'],
      status: json['status'],
      requestResponse: json['requestResponse'],
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


