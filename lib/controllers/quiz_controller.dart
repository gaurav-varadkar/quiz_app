// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quiz_app/model/quiz_model.dart';
import 'package:quiz_app/screens/result_page.dart';

class QuizController extends GetxController {
  final CollectionReference _quizCollection =
      FirebaseFirestore.instance.collection('quiz');


  RxList<QuizModel> quizQuestions = <QuizModel>[].obs;
  RxInt currentQuestionIndex = 0.obs;
  RxInt selectedOption = (-1).obs;
  RxInt correctAnswers = 0.obs;
  String? phoneNumber;
  bool isError = false;

  @override
  void onInit() {
    super.onInit();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      isError = false;
      final querySnapshot = await _quizCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        final result = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        quizQuestions.value = (result[0]['quiz_questions'] as List<dynamic>)
            .map((e) => QuizModel.fromJson(e))
            .toList();
      } else {
        isError = true;
        throw "No question found";
      }
    } catch (e) {
      debugPrint('Error fetching quiz: $e');
      isError = true;
    } finally {
      update();
    }
  }

  void nextQuestion() {
    calculateCorrectAnswers();
    if (currentQuestionIndex < quizQuestions.length - 1) {
      currentQuestionIndex++;

      selectedOption.value = -1;
    } else {
      Get.to(() => const ResultPage());
    }
    update();
  }



  void calculateCorrectAnswers() {
    if (currentQuestionIndex <= quizQuestions.length - 1) {
      var currentQuestion = quizQuestions[currentQuestionIndex.value];
      var answerIndex =
          (currentQuestion.options.indexOf(currentQuestion.answer));

      if (answerIndex == selectedOption.value) {
        correctAnswers++;
      }
      update();
    }
  }

  void setSelectedOption(int value) {
    selectedOption.value = value;
    update();
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    selectedOption.value = -1;
    correctAnswers.value = 0;
  }

  Future<void> saveCorrectAnswers({String? name}) async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) throw "User UID is null";
   
      await users.doc(user.uid).update({
        "results":{
          'total_questions': quizQuestions.length,
        'correct_answers': correctAnswers.value,
        'timestamp': Timestamp.now(),
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

 
}
