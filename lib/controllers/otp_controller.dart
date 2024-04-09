// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:quiz_app/screens/home_page.dart';

// class OtpController extends GetxController {
//   final TextEditingController otpController = TextEditingController();
//   final RxBool verifying = false.obs;

//   final _localStorage = GetStorage();

//   Future<void> verifyOTP(String verificationId) async {
//     verifying.value = true;

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: otpController.text.toString(),
//       );
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         // Save user authentication state locally
//         _localStorage.write('isAuthenticated', true);
//         Get.offAll(() => const HomePage());
//       } else {
//         Get.snackbar("Error", "Authentication failed. Please try again.");
//       }
//     } catch (error) {
//       Get.snackbar("Error", "An error occurred: $error");
//     } finally {
//       verifying.value = false;
//     }
//   }

//   bool get isAuthenticated => _localStorage.read('isAuthenticated') ?? false;

//   void clearSession() {
//     _localStorage.remove('isAuthenticated');
//   }
// }
