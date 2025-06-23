// import 'package:flutter/material.dart';
// import 'package:roomly/features/request/domain/entities/request.dart';

// class RequestCard extends StatelessWidget {
//   final Request request;
//   final VoidCallback onTap;

//   const RequestCard({
//     Key? key,
//     required this.request,
//     required this.onTap,
//   }) : super(key: key);

//   Color _getStatusColor(String status) {
//     switch (status.toUpperCase()) {
//       case 'APPROVED':
//         return Colors.green;
//       case 'REJECTED':
//         return Colors.red;
//       case 'PENDING':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12.0),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     request.type,
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Container(
//                     width: 12.0,
//                     height: 12.0,
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(request.status),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8.0),
//               Text(
//                 request.details,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
//               ),
//               const SizedBox(height: 8.0),
//               Text(
//                 'Request Date: ${request.requestDate}',
//                 style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 4.0),
//               Text(
//                 'Status: ${request.status}',
//                 style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// v2 ----------------------------------------------------------------------------------


import 'package:flutter/material.dart';
import 'package:roomly/features/request/domain/entities/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback onTap;

  const RequestCard({
    Key? key,
    required this.request,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 6.0, // Increased elevation for a more modern look
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // More rounded corners
      color: Colors.white.withOpacity(0.95), // Slightly opaque white card
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      request.type,
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800], // Darker blue for type
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 15.0, // Larger status circle
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: _getStatusColor(request.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                request.details,
                maxLines: 3, // Allow more lines for details
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.0, color: Colors.grey[800]), // Slightly darker grey
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Request Date: ${request.requestDate}',
                    style: TextStyle(fontSize: 13.0, color: Colors.grey[600]),
                  ),
                  Text(
                    'Status: ${request.status}',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(request.status), // Status text color matches circle
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


