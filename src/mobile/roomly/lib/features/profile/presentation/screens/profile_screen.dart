import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import 'package:roomly/features/profile/presentation/widgets/custom_text_field.dart';
import 'package:roomly/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:roomly/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:roomly/features/profile/presentation/widgets/success_popup.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditing = false;
  UserEntity? _currentUser;
  final userData = AppSession().currentUser;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = UserModel.fromEntity(userData!);
    print("[ProfileScreen] initState called");
    print("[ProfileScreen] Loading Current User Data");
    print("[ProfileScreen] Current User " + _currentUser.toString());
    context.read<ProfileCubit>().loadUser();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(UserEntity user) {
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email;
    _passwordController.text = '•••••••••••';
    _locationController.text = user.address ?? '';
    _phoneController.text = user.phone ?? '';
    _currentUser = user;
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() && _currentUser != null) {
      final updatedUser = UserEntity(
        id: _currentUser!.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: userModel?.password, // Use the original password
        // password: _currentUser!.password, // Keep original password
        phone: _phoneController.text.trim(),
        address: _locationController.text.trim(),
        isStaff: _currentUser!.isStaff,
      );

      context.read<ProfileCubit>().updateUserData(updatedUser);
    }
  }

  void _deleteAccount(ProfileCubit profileCubit) {
    if (_currentUser?.id != null) {
      showDialog(
        context: context,
        builder:
            (context) => BlocProvider.value(
              value: profileCubit,
              child: AlertDialog(
                title: const Text('Delete Account'),
                content: const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // context.read<ProfileCubit>().deleteUserAccount(
                      //   _currentUser!.id!,
                      // );
                      profileCubit.deleteUserAccount(_currentUser!.id!);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        title: const Text(
          'Account Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _populateFields(state.user);
          } else if (state is ProfileUpdateSuccess) {
            setState(() {
              _isEditing = false;
            });
            SuccessPopup.show(
              context,
              message: 'User Data Updated Successfully',
              iconPath: 'assets/icons/user-edit.png',
              onClose: () {
                context.read<ProfileCubit>().loadUser();
              },
            );
          } else if (state is ProfileDeleteSuccess) {
            SuccessPopup.show(
              context,
              message: 'User Deleted Successfully',
              iconPath: 'assets/icons/user-delete.png',
              onClose: () {
                context.go('/login');
              },
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar Section
                    const ProfileAvatar(),
                    const SizedBox(height: 32),

                    // Form Fields
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'First Name',
                            controller: _firstNameController,
                            readOnly: !_isEditing,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'Last Name',
                            controller: _lastNameController,
                            readOnly: !_isEditing,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      readOnly: true, // Email should not be editable
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Password',
                      controller: _passwordController,
                      readOnly: true, // Password should not be editable here
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Location',
                      controller: _locationController,
                      readOnly: !_isEditing,
                      suffixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Phone',
                      controller: _phoneController,
                      readOnly: !_isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    if (!_isEditing) ...[
                      // Delete Account Button
                      ProfileActionButton(
                        text: 'Delete Account',
                        onPressed: () {
                          _deleteAccount(context.read<ProfileCubit>());
                        },
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 16),

                      // Edit Profile Button
                      ProfileActionButton(
                        text: 'Edit Profile',
                        onPressed: _toggleEditing,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                      ),
                    ] else ...[
                      // Cancel Button (when editing)
                      ProfileActionButton(
                        text: 'Cancel',
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                          if (_currentUser != null) {
                            _populateFields(_currentUser!);
                          }
                        },
                        backgroundColor: Colors.grey,
                        textColor: Colors.grey,
                        isOutlined: true,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
