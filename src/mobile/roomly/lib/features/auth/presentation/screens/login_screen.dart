import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/presentation/Widgets/CustomAppBar.dart';
import '../../../GlobalWidgets/pop_p.dart';
import '../../../GlobalWidgets/show_custom_pop_up.dart';
import '../../styleHelperComponents.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import 'complete_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isStaff = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dismissible(
      key: const Key("login_screen"),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(icon: FontAwesomeIcons.xmark),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              showCustomDialog(
                context: context,
                title: 'Error',
                message: state.message,
                alertType: AlertType.error,
              );
            } else if (state is AuthLoggedIn) {
              final user = state.user;
              if (user.firstName == null ||
                  user.lastName == null ||
                  user.phone == null ||
                  user.address == null) {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withValues(alpha: 0.7),
                  builder: (context) => ProfileForm(
                    email: state.user.email,
                    onSavePressed: (profileData) {
                      context.read<AuthCubit>().completeProfile(profileData).then((_) {
                        Navigator.of(context).pop(); // Close the dialog
                        context.go('/home'); // Navigate to home
                      });
                    },
                  ),
                );
              } else {
                // Profile is complete, navigate to home
                showCustomDialog(
                  context: context,
                  title: 'Success',
                  message: 'Logged in Successfully!',
                  alertType: AlertType.success,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/home');
                  },
                );
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SvgPicture.asset(
                            'assets/images/Fingerprint-rafiki 1.svg',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.4,
                          ),
                          const Text(
                            'Login to Process further',
                            style: TextStyle(
                              shadows: [kCustomShadow],
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ReusableTextField(
                        hintText: "Email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      ReusableTextField(

                        hintText: "Password",
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 30),
                      // Add staff toggle if needed
                      // SwitchListTile(
                      //   title: const Text('Staff Login'),
                      //   value: _isStaff,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _isStaff = value;
                      //     });
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      state is AuthLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                        text: "Login",
                        onPressed: () {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          context.read<AuthCubit>().login(
                            _emailController.text,
                            _passwordController.text,
                            _isStaff,
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'or login with',
                        style: TextStyle(
                          shadows: [kCustomShadow],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ReusableButton(
                        isGradiant: true,
                        textColor: Colors.black,
                        imagePath: 'assets/images/google 2.png',
                        text: 'Continue with Google',
                        onPressed: () {
                          // Handle Google login
                          // context.read<AuthCubit>().loginWithGoogle();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member yet?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go('/signup');
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

