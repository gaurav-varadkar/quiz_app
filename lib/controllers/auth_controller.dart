import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quiz_app/screens/otp_screen.dart';
import 'package:quiz_app/screens/quiz_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> user = Rx<User?>(null);
  final RxBool verifyingOTP = false.obs; // Tracks OTP verification status

  // final _localStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in user authentication state
    _auth.authStateChanges().listen((User? newUser) {
      user.value = newUser;
    });
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    // Set verifyingOTP to true before starting OTP verification
    verifyingOTP.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // If verification is completed automatically, set verifyingOTP to false
          verifyingOTP.value = false;
          Get.offAll(() => QuizPage());
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error", "Verification failed: ${e.message}");
          // If verification fails, set verifyingOTP to false
          verifyingOTP.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen with verification ID
          Get.to(() => OtpScreen(verificationId: verificationId));
          // Set verifyingOTP to false after navigating to OTP screen
          verifyingOTP.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (error) {
      Get.snackbar("Error", "An error occurred: $error");
      // If an error occurs during OTP verification, set verifyingOTP to false
      verifyingOTP.value = false;
    }
  }

  Future<void> signInWithOTP(String verificationId, String smsCode) async {
    // Set verifyingOTP to true before signing in with OTP
    verifyingOTP.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      // If sign-in with OTP is successful, set verifyingOTP to false
      verifyingOTP.value = false;
    } catch (error) {
      Get.snackbar("Error", "Failed to sign in: $error");
      // If sign-in with OTP fails, set verifyingOTP to false
      verifyingOTP.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      Get.snackbar("Error", "Failed to sign out: $error");
    }
  }
}
