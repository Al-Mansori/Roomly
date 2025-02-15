import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';

import '../../styleHelperComponents.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration
                (
                color: Color(0xFF7F7F7F),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(FontAwesomeIcons.xmark,color: Colors.white,),
              ),
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30 ,right: 30,bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Stack(
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
                ),

                // Add spacing between the text and the text field
                const SizedBox(height: 16),
                ReusableTextField(hintText: "Email"),
                SizedBox(height: 30),
                ReusableTextField(hintText: "Password", obscureText: true),
                SizedBox(height: 30),
                ReusableButton(
                  text: "Login",
                  onPressed: () {
                    // final previousRoute = GoRouter.of(context).location;
                    // context.go(previousRoute); 
                    print("go to latest page");
                  },
                ),

                SizedBox(height: 15),
                const Text(
                  'or login with',
                  style: TextStyle(
                    shadows: [kCustomShadow],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),

                ReusableButton
                  (
                  isGradiant: true,
                  //Colo: Colors.white,
                    textColor: Colors.black,
                    imagePath: 'assets/images/google 2.png',
                    text: 'Continue with Google',
                    onPressed: (){print("object");})

            ],
            ),
          ),
        ),
      ),

    );
  }
}


