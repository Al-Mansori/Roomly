import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import '../../../GlobalWidgets/pop_p.dart';
import '../../../GlobalWidgets/show_custom_pop_up.dart';
import '../blocs/auth_cubit.dart';

class ProfileForm extends StatefulWidget {
  final String email;
  final Function(Map<String, dynamic>) onSavePressed;
  final VoidCallback onClose;
  final bool requireCompletion;

  const ProfileForm({
    super.key,
    required this.email,
    required this.onSavePressed,
    required this.onClose,
    this.requireCompletion = false,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;

  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _locationController = TextEditingController();
    _phoneController = TextEditingController();

    // Add listeners to detect changes
    _firstNameController.addListener(_checkChanges);
    _lastNameController.addListener(_checkChanges);
    _locationController.addListener(_checkChanges);
    _phoneController.addListener(_checkChanges);

    _loadUserData();
  }

  void _checkChanges() {
    final currentChanges = _firstNameController.text.isNotEmpty ||
        _lastNameController.text.isNotEmpty ||
        _locationController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty;

    if (_hasChanges != currentChanges) {
      setState(() {
        _hasChanges = currentChanges;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userData = AppSession().currentUser;
      if (userData != null) {
        _firstNameController.text = userData.firstName ?? '';
        _lastNameController.text = userData.lastName ?? '';
        _locationController.text = userData.address ?? '';
        _phoneController.text = userData.phone ?? '';
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges || !widget.requireCompletion) {
      return true;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false), // Cancel: return false
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true), // Exit: return true
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }
  @override
  void dispose() {
    _firstNameController.removeListener(_checkChanges);
    _lastNameController.removeListener(_checkChanges);
    _locationController.removeListener(_checkChanges);
    _phoneController.removeListener(_checkChanges);

    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthProfileCompleted) {
              // Pop the profile form screen
              Navigator.of(context, rootNavigator: true).pop();
              // Show success dialog using the current context
              showCustomDialog(
                context: context, // Use the current context
                title: 'Success',
                message: state.response['message'] ?? 'Profile updated successfully',
                alertType: AlertType.success,
                buttonText: 'OK',
                onPressed: () {},

              );
            } else if (state is AuthError) {
              showCustomDialog(
                context: context,
                title: 'Error',
                message: state.message,
                alertType: AlertType.error,
                buttonText: 'OK',
                onPressed: () {},
              );
            }
          },
          builder: (context, state) {
            return Material(
              type: MaterialType.transparency,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minWidth: 300,
                  ),
                  margin: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Material(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header with close button
                                  Container(
                                    width: double.infinity,
                                    height: 86,
                                    color: const Color(0xFFEBEBEB),
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        const Center(
                                          child: Text(
                                            'Complete your profile',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 20,
                                          top: 20,
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () async {
                                              if (await _onWillPop()) {
                                                widget.onClose();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Avatar and Email
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        // Avatar
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD9D9D9),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF0A3FB3),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          widget.email,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF808080),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Form Fields
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Column(
                                      children: [
                                        // Name
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Name',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF808080),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: _buildInputField(
                                                      hint: 'First',
                                                      controller: _firstNameController,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Required';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: _buildInputField(
                                                      hint: 'Last',
                                                      controller: _lastNameController,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Required';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),

                                        // Email (read-only)
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Email',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF808080),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                enabled: false,
                                                initialValue: widget.email,
                                                decoration: InputDecoration(
                                                  hintText: widget.email,
                                                  hintStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF8E8991),
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                        color: Color(0xFFDBD9DC)),
                                                  ),
                                                ),
                                              ),
                                            )],
                                        ),
                                        const SizedBox(height: 20),

                                        // Location
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Location',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF808080),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildInputField(
                                                hint: '30street-dokki',
                                                controller: _locationController,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),

                                        // Phone
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Phone',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF808080),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildInputField(
                                                hint: 'xxx-xxx-xxx',
                                                controller: _phoneController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Required';
                                                  }
                                                  if (!RegExp(r'^[0-9\-]+$').hasMatch(value)) {
                                                    return 'Invalid phone number';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Save Button
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : () {
                                          if (_formKey.currentState?.validate() ?? false) {
                                            final profileData = {
                                              'firstName': _firstNameController.text,
                                              'lastName': _lastNameController.text,
                                              'address': _locationController.text,
                                              'phone': _phoneController.text,
                                            };
                                            widget.onSavePressed(profileData);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0A3FB3),
                                          minimumSize: const Size(double.infinity, 44),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        child: state is AuthLoading
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                            : const Text(
                                          'Save',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Loading overlay
                          if (state is AuthLoading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFF8E8991),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDBD9DC)),
        ),
        errorStyle: const TextStyle(fontSize: 10),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}