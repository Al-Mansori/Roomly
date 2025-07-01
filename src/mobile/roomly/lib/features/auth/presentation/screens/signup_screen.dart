import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/data/models/otp_enum.dart';
import 'package:roomly/features/auth/presentation/Widgets/CustomAppBar.dart';

import '../../../GlobalWidgets/pop_p.dart';
import '../../../GlobalWidgets/show_custom_pop_up.dart';
import '../../data/models/validation_errors.dart';
import '../../styleHelperComponents.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';
import '../blocs/auth_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;

  // Password requirements based on your regex
  final RegExp passwordRegex = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!])(?=\S+$).{10,}$",
  );
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isEmailValid => emailRegex.hasMatch(_emailController.text);
  bool get _isPasswordValid => passwordRegex.hasMatch(_passwordController.text);
  bool get _doPasswordsMatch =>
      _passwordController.text == _confirmPasswordController.text &&
          _confirmPasswordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dismissible(
      key: const Key("signup_screen"),
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
            } else if (state is AuthRegistrationSuccess) {
              showCustomDialog(
                context: context,
                title: 'Success',
                message: 'Data Is Correct Lets check your email!',
                alertType: AlertType.success,
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.go('/verify-otp', extra: {
                    'email': state.email,
                    'userId': state.userId,
                    'isStaff': state.isStaff,
                    'password': _passwordController.text,
                     'type' : OtpVerifyType.register
                  });
                  },
              );
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
                            'assets/images/Reset password-pana 2.svg',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.3,
                          ),
                          const Text(
                            'Create an account',
                            style: TextStyle(
                              shadows: [kCustomShadow],
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableTextField(
                            hintText: "Email",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) => setState(() {}),
                            onTap: () => setState(() => _emailTouched = true),
                          ),
                          if (_emailTouched && _emailController.text.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Text(
                                'Email is required',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          if (_emailTouched && _emailController.text.isNotEmpty && !_isEmailValid)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Text(
                                'Please enter a valid email address',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableTextField(
                            hintText: "Password",
                            obscureText: true,
                            controller: _passwordController,
                            onChanged: (_) => setState(() {}),
                            onTap: () => setState(() => _passwordTouched = true),
                          ),
                          if (_passwordTouched && _passwordController.text.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Text(
                                'Password is required',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          if (_passwordTouched && _passwordController.text.isNotEmpty && !_isPasswordValid)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password must contain:',
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                  Text(
                                    '• At least 10 characters',
                                    style: TextStyle(
                                      color: _passwordController.text.length >= 10 ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '• At least one uppercase letter',
                                    style: TextStyle(
                                      color: _passwordController.text.contains(RegExp(r'[A-Z]')) ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '• At least one lowercase letter',
                                    style: TextStyle(
                                      color: _passwordController.text.contains(RegExp(r'[a-z]')) ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '• At least one number',
                                    style: TextStyle(
                                      color: _passwordController.text.contains(RegExp(r'[0-9]')) ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '• At least one special character (@#\$%^&+=!)',
                                    style: TextStyle(
                                      color: _passwordController.text.contains(RegExp(r'[@#$%^&+=!]')) ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableTextField(
                            hintText: "Confirm Password",
                            obscureText: true,
                            controller: _confirmPasswordController,
                            onChanged: (_) => setState(() {}),
                            onTap: () => setState(() => _confirmPasswordTouched = true),
                          ),
                          if (_confirmPasswordTouched && _confirmPasswordController.text.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Text(
                                'Please confirm your password',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          if (_confirmPasswordTouched &&
                              _confirmPasswordController.text.isNotEmpty &&
                              !_doPasswordsMatch)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Text(
                                'Passwords do not match',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (value) => setState(() => _termsAccepted = value!),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree to ',
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Roomly\'s Terms of Service',
                                    style: const TextStyle(
                                        color: Colors.blue, decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Open terms of service
                                      },
                                  ),
                                  const TextSpan(text: ' & '),
                                  TextSpan(
                                    text: 'Privacy Policy.',
                                    style: const TextStyle(
                                        color: Colors.blue, decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Open privacy policy
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      state is AuthLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                        text: "Register",
                        onPressed: () {
                          setState(() {
                            _emailTouched = true;
                            _passwordTouched = true;
                            _confirmPasswordTouched = true;
                          });

                          if (!_termsAccepted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please accept terms and conditions')),
                            );
                            return;
                          }

                          if (!_isEmailValid || !_isPasswordValid || !_doPasswordsMatch) {
                            return;
                          }

                          context.read<AuthCubit>().register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            isStaff: false,
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(child: Divider(thickness: 1, color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ReusableButton(
                        isGradiant: true,
                        textColor: Colors.black,
                        imagePath: 'assets/images/google 2.png',
                        text: 'Continue with Google',
                        onPressed: () {
                          // context.read<AuthCubit>().loginWithGoogle();
                        },
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