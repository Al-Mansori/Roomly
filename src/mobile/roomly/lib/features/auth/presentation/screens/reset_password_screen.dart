import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../GlobalWidgets/pop_p.dart';
import '../../../GlobalWidgets/show_custom_pop_up.dart';
import '../../styleHelperComponents.dart';
import '../Widgets/CustomAppBar.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';
import '../blocs/auth_cubit.dart';

class ResetPasswordScreen extends StatefulWidget{
  final String email;

  const ResetPasswordScreen({super.key, required this.email});


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;

  // Password requirements based on your regex
  final RegExp passwordRegex = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!])(?=\S+$).{10,}$",
  );


  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isPasswordValid => passwordRegex.hasMatch(_passwordController.text);
  bool get _doPasswordsMatch =>
      _passwordController.text == _confirmPasswordController.text &&
          _confirmPasswordController.text.isNotEmpty;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dismissible(
      key: const Key("reset_password_screen"),
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
            } else if (state is PasswordResetSuccess) {
              showCustomDialog(
                context: context,
                title: 'Success',
                message: 'Password Updated Successfully!',
                alertType: AlertType.success,
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.go('/login');
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
                            'Reset Password',
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
                      state is PasswordResetLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                        text: "Reset!",
                        onPressed: () {
                          setState(() {
                            _passwordTouched = true;
                            _confirmPasswordTouched = true;
                          });


                          if ( !_isPasswordValid || !_doPasswordsMatch) {
                            return;
                          }

                          context.read<AuthCubit>().resetPassword(
                            widget.email,
                            _passwordController.text,
                          );
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