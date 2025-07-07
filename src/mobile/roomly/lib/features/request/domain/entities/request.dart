// import 'package:equatable/equatable.dart';

// class Request extends Equatable {
//   final String id;
//   final String type;
//   final String requestDate;
//   final String responseDate;
//   final String details;
//   final String status;
//   final String requestResponse;

//   const Request({
//     required this.id,
//     required this.type,
//     required this.requestDate,
//     required this.responseDate,
//     required this.details,
//     required this.status,
//     required this.requestResponse,
//   });

//   @override
//   List<Object> get props => [
//         id,
//         type,
//         requestDate,
//         responseDate,
//         details,
//         status,
//         requestResponse,
//       ];
// }




// v2 ===========================================================================

import 'package:equatable/equatable.dart';
class Request extends Equatable {
  final String id;
  final String type;
  final String requestDate;
  final String? responseDate;  // Make nullable
  final String details;
  final String status;
  final String? requestResponse;  // Make nullable

  const Request({
    required this.id,
    required this.type,
    required this.requestDate,
    this.responseDate,
    required this.details,
    required this.status,
    this.requestResponse,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        requestDate,
        responseDate,
        details,
        status,
        requestResponse,
      ];
}