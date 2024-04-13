import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/const/image_asset_path.dart';
import 'package:quiz_app/controllers/auth_controller.dart';
import 'package:quiz_app/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController =
      Get.put<AuthController>(AuthController());
  TextEditingController phoneController = TextEditingController();
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'WELCOME TO QUIZ APP\n',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: '\nEnter your phone to login ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextField(
                            controller: phoneController,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Phone Number',
                              labelStyle: TextStyle(color: Colors.white),
                              prefix: Text(
                                '+ 91 ',
                                style: TextStyle(color: Colors.white),
                              ),
                              hintText: 'xxxxxxxxxx',
                              hintStyle: TextStyle(color: Colors.white),
                              errorStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),

                            style: const TextStyle(color: Colors.white),

                            //
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException authException) {},
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    Get.to(() => OtpScreen(
                                        verificationId: verificationId));
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                  phoneNumber: "+91${phoneController.text}");
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text(
                              'Proceed',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
