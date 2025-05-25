import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/presentation/Widgets/CustomAppBar.dart';
import '../../../GlobalWidgets/pop_p.dart';
import '../../../GlobalWidgets/show_custom_pop_up.dart';
import '../../data/models/otp_enum.dart';
import '../../styleHelperComponents.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dismissible(
      key: const Key("forget_password_screen"),
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
            }else if (state is ForgotPasswordOtpSent) {
              context.go('/verify-otp', extra: {
                'email': state.email,
                'type' : OtpVerifyType.forgetPassword
              });

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

                      state is PasswordForgetLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                        text: "Verify",
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          context.read<AuthCubit>().sendForgotPasswordOtp(
                            _emailController.text,
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

