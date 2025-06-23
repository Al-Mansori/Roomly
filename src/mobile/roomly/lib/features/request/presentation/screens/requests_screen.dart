// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
// import 'package:roomly/features/request/presentation/cubit/requests_cubit.dart';
// import 'package:roomly/features/request/presentation/cubit/requests_state.dart';
// import 'package:roomly/features/request/presentation/widgets/request_card.dart';

// class RequestsScreen extends StatefulWidget {
//   const RequestsScreen({Key? key}) : super(key: key);

//   @override
//   State<RequestsScreen> createState() => _RequestsScreenState();
// }

// class _RequestsScreenState extends State<RequestsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<RequestsCubit>().fetchRequests('usr001');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Requests'),
//       ),
//       body: BlocBuilder<RequestsCubit, RequestsState>(
//         builder: (context, state) {
//           if (state is RequestsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is RequestsLoaded) {
//             return ListView.builder(
//               itemCount: state.requests.length,
//               itemBuilder: (context, index) {
//                 final request = state.requests[index];
//                 return RequestCard(
//                   request: request,
//                   onTap: () {
//                     GoRouter.of(context).push('/request-details', extra: request);
//                   },
//                 );
//               },
//             );
//           } else if (state is RequestsError) {
//             return Center(child: Text(state.message));
//           }
//           return const Center(child: Text('No requests found.'));
//         },
//       ),
//     );
//   }
// }




// v2 --------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
import 'package:roomly/features/request/presentation/cubit/requests_cubit.dart';
import 'package:roomly/features/request/presentation/cubit/requests_state.dart';
import 'package:roomly/features/request/presentation/widgets/request_card.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    final userId = await SecureStorage.getId();
    if (userId != null) {
      context.read<RequestsCubit>().fetchRequests(userId);
    } else {
      print('User ID not found in secure storage.');
      context.read<RequestsCubit>().emit(const RequestsError(message: 'User not logged in.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Requests',
          style: TextStyle(color: Colors.white), // White text for app bar title
        ),
        backgroundColor: Colors.blue[800], // Darker blue for app bar
        iconTheme: const IconThemeData(color: Colors.white), // White icons
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[800]!, // Darker blue at the top
              Colors.blue[400]!, // Lighter blue at the bottom
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners for the image
                child: Image.asset(
                  'assets/images/request.jpg', // Path to your image
                  fit: BoxFit.cover,
                  height: 270,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (context, state) {
                  if (state is RequestsLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  } else if (state is RequestsLoaded) {
                    return ListView.builder(
                      itemCount: state.requests.length,
                      itemBuilder: (context, index) {
                        final request = state.requests[index];
                        return RequestCard(
                          request: request,
                          onTap: () {
                            GoRouter.of(context).push('/request-details', extra: request);
                          },
                        );
                      },
                    );
                  } else if (state is RequestsError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
                  }
                  return const Center(child: Text('No requests found.', style: TextStyle(color: Colors.white)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


