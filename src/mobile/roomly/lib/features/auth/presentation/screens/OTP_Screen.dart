import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../GlobalWidgets/pop_p.dart';
import '../../../GlobalWidgets/show_custom_pop_up.dart';
import '../../styleHelperComponents.dart';
import '../Widgets/CustomAppBar.dart';
import '../blocs/auth_cubit.dart';

class OtpVerifyScreen extends StatelessWidget {
  final _otpController = TextEditingController();
  final String email;
  final String userId;
  final bool isStaff;
  final String password;

  OtpVerifyScreen({
    super.key,
    required this.email,
    required this.userId,
    required this.isStaff,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showCustomDialog(
            context: context,
            title: 'Error',
            message: state.message,
            alertType: AlertType.error,
          );

        } else if (state is AuthVerificationSuccess) {
          showCustomDialog(
            context: context,
            title: 'Success',
            message: 'Account Created Successfully!',
            alertType: AlertType.success,
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/Complete-profile');
            },
          );


        }
      },
      builder: (context, state) {
        return Dismissible(
          key: const Key("otp_screen"),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          child: Scaffold(
            appBar: const CustomAppBar(icon: FontAwesomeIcons.arrowLeft),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Container(
                  child: Stack(
                  alignment: Alignment.bottomCenter,
                    children: [
                      SvgPicture.asset(
                        'assets/images/Enter OTP-rafiki 1.svg',
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.4,
                      ),
                      const Text(
                        'Verify your email',
                        style: TextStyle(
                          shadows: [kCustomShadow],
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Enter the OTP sent to ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 6,
                  controller: _otpController,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                  onCompleted: (pin) {
                    context.read<AuthCubit>().verifyOtp(int.parse(pin));
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive the OTP?"),
                    TextButton(
                      onPressed: () {
                        context.read<AuthCubit>().register(
                          email: email,
                          password: password,
                          confirmPassword: password,
                          isStaff: isStaff,
                        );
                      },
                      child: const Text(
                          "Resend OTP",
                          style: TextStyle(color: Color(0xFF0A3FB3))
                      ),
                    )],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3FB3),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_otpController.text.length == 6) {
                            context.read<AuthCubit>().verifyOtp(int.parse(_otpController.text));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid OTP')),
                            );
                          }
                        },
                        child: const Text(
                            "Verify & Proceed",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
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
    );
  }
}