import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/presentation/Widgets/CustomAppBar.dart';

import '../../styleHelperComponents.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
        body: SingleChildScrollView(
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
                  ReusableTextField(hintText: "Email"),
                  const SizedBox(height: 30),
                  ReusableTextField(hintText: "Password", obscureText: true),
                  const SizedBox(height: 30),
                  ReusableTextField(hintText: "Confirm Password", obscureText: true),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Roomly’s Terms of Service',
                                style: const TextStyle(
                                    color: Colors.blue, decoration: TextDecoration.underline),
                                recognizer: null,
                              ),
                              const TextSpan(text: ' & '),
                              TextSpan(
                                text: 'Privacy Policy.',
                                style: const TextStyle(
                                    color: Colors.blue, decoration: TextDecoration.underline),
                                recognizer: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ReusableButton(
                    text: "Register",
                    onPressed: () {
                      print("go to latest page");
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
                      print("object");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
