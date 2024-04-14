import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/screens/otp_screen.dart';
import 'package:quiz_app/screens/quiz_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> user = Rx<User?>(null);
  final RxBool verifyingOTP = false.obs; 



  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? newUser) {
      user.value = newUser;
    });
  }

  Future<void> verifyPhoneNumber(String phoneNumber, String name) async {
    verifyingOTP.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        
        verificationCompleted: (PhoneAuthCredential credential) async {
        
          Get.offAll(() => QuizPage()); 
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error", "Verification failed: ${e.message}");
          verifyingOTP.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.to(() => OtpScreen(verificationId: verificationId, phoneNumber: phoneNumber, name: name));
          verifyingOTP.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (error) {
      Get.snackbar("Error", "An error occurred, Please try again!",backgroundColor: Colors.redAccent);

      verifyingOTP.value = false;
    }
  }

  Future<void> signInWithOTP(String verificationId, String smsCode, String name , String phoneNumber) async {
  
    verifyingOTP.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final user =  await _auth.signInWithCredential(credential);
 
      
        if(user.user == null){
          throw Exception("User UID is null");
        }
        
          await saveUserInfo(user.user!, name, phoneNumber);
          Get.offAll(QuizPage());

      verifyingOTP.value = false;
    } catch (error) {
      Get.snackbar("Error", "Failed to sign in",backgroundColor: Colors.redAccent);
    
      verifyingOTP.value = false;
    }
  }



Future<void> saveUserInfo(User user, String name, String phone) async {

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  try {
   
    await users.doc(user.uid).set({
      'name': name,
      'phone': phone,
    });
  } catch (e) {
   
    debugPrint('Failed to save user information: $e');
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
