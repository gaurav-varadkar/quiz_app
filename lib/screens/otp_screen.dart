import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/const/image_asset_path.dart';
import 'package:quiz_app/controllers/auth_controller.dart';
import 'package:quiz_app/screens/quiz_page.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;

  OtpScreen({super.key, required this.verificationId});
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          Image.asset(
            ImageAssetPath.bgImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            children: [
              Flexible(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async{
                  await authController.signInWithOTP(
                  verificationId,otpController.text
                );
                Get.offAll(()=> QuizPage());
                },
                child: Obx(() {
                  if (authController.verifyingOTP.value) {
                  return const CircularProgressIndicator();
                }
                else{
                  return const Text('Submit');
                }
                }
                  
              )
              )
            ],
          ),
        ],
      ),
    );
  }
}
