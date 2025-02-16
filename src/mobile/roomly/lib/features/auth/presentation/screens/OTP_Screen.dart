import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../styleHelperComponents.dart';
import '../Widgets/CustomAppBar.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return
      Dismissible(
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

                const SizedBox(height: 20),

                RichText(
                  text: const TextSpan(
                    text: "Enter the OTP sent to ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "salmaom3r@gmail.com",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive the OTP?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Resend OTP", style: TextStyle(color:  const Color(0xFF0A3FB3))),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  const Color(0xFF0A3FB3),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      print("OTP Verified");
                    },
                    child: const Text("Verify & Proceed", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    )
      );
  }
}
