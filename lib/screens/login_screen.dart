import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/const/background_display.dart';
import 'package:quiz_app/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });
    

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        Get.put<AuthController>(AuthController());
    TextEditingController phoneController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: BackgroundImage(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'WELCOME  TO \n',
                                  style: TextStyle(
                                    height: 1.5,
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'QUIZ APP\n',
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: '\nEnter your phone to login ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                  .hasMatch(value)) {
                                return 'Name cannot contain special characters';
                              }
                              return null;
                            },
                            onChanged: (_) {
                              formKey.currentState!.validate();
                            },
                            autofocus: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Enter your name',
                              labelStyle: const TextStyle(color: Colors.white),
                              hintText: 'Eg. Gaurav Varadkar',
                              hintStyle:
                                  TextStyle(color: Colors.grey.withOpacity(0.3)),
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your phone number";
                              }
                              if (value.length != 10) {
                                return "Phone number should consist  10 digits";
                              }
                              return null;
                            },
                            onChanged: (_) {
                              formKey.currentState!.validate();
                            },
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            decoration: InputDecoration(
                              counterText: '',
                              border: const OutlineInputBorder(),
                              labelText: 'Enter Phone Number',
                              labelStyle: const TextStyle(color: Colors.white),
                              prefix: const Text(
                                '+ 91 ',
                                style: TextStyle(color: Colors.white),
                              ),
                              hintText: 'xxxxxxxxxx',
                              hintStyle:
                                  TextStyle(color: Colors.grey.withOpacity(0.3)),
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                          Obx(
                            () => SizedBox(
                              height: 60,
                              width: double.infinity * 0.5,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    authController.verifyPhoneNumber(
                                        phoneController.text, nameController.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: const StadiumBorder(),
                                ),
                                child: authController.verifyingOTP.value
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Proceed',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
