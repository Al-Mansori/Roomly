import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/presentation/Widgets/CustomAppBar.dart';

import '../../styleHelperComponents.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  ReusableTextField(hintText: "Email"),
                  const SizedBox(height: 30),
                  ReusableTextField(hintText: "Password", obscureText: true),
                  const SizedBox(height: 30),
                  ReusableButton(
                    text: "Login",
                    onPressed: () {
                      print("go to latest page");
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
