// features/request/presentation/screens/request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';

import '../cubits/request.dart';

class RequestScreen extends StatefulWidget {
  final String staffId;

  const RequestScreen(
      {required this.staffId,
        super.key});
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _detailsController = TextEditingController();
  String? _selectedType;

  @override
  void dispose() {
    _typeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendRequestCubit, RequestState>(
      listener: (context, state) {
        if (state is RequestSuccess) {
          Navigator.of(context).pop(); // Close the request screen
          Navigator.of(context).pushNamed('/requests'); // Navigate to requests
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')),
          );
        } else if (state is RequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Request'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Request Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'MAINTENANCE',
                      child: Text('Maintenance'),
                    ),
                    DropdownMenuItem(
                      value: 'CLEANING',
                      child: Text('Cleaning'),
                    ),
                    DropdownMenuItem(
                      value: 'OTHER',
                      child: Text('Other'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a type' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter details' : null,
                ),
                const SizedBox(height: 24),
                BlocBuilder<SendRequestCubit, RequestState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is RequestLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            UserEntity? user = AppSession().currentUser;
                            final userId = user?.id;// Get from session
                            if(userId != null)
                              {
                                context.read<SendRequestCubit>().submitRequest(
                                  type: _selectedType!,
                                  details: _detailsController.text,
                                  userId: userId,
                                  staffId: widget.staffId
                                );
                              }

                          }
                        },
                        child: state is RequestLoading
                            ? const CircularProgressIndicator()
                            : const Text('Submit Request'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}