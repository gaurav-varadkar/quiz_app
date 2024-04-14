import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/const/background_display.dart';
import 'package:quiz_app/controllers/auth_controller.dart';

import 'package:quiz_app/screens/quiz_page.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;

  OtpScreen(
      {super.key,
      required this.verificationId,
      required this.phoneNumber,
      required this.name});
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: BackgroundImage(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Verify your OTP \n to enter the QuizMania!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: otpController,
                    style: const TextStyle(color: Colors.white),
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter OTP',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                     const SizedBox(height: 25),
                        SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  await authController.signInWithOTP(verificationId,
                      otpController.text, name, phoneNumber);
                  // Get.offAll(() => QuizPage());
                },
                child: Obx(() {
                  if (authController.verifyingOTP.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text('Submit',style: TextStyle(color: Colors.white , fontSize: 18),);
                  }
                })),
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
