import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizController extends GetxController {

  var _questions = <QuizQuestion>[].obs;
  List<QuizQuestion> get questions => _questions;
  int currentIndex = 0; // Define currentIndex property
  int selectedIndex = -1;


  @override
  void onInit() {
    super.onInit();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData()async{
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('quiz').get();
      _questions.value = querySnapshot.docs.map((doc) => QuizQuestion.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching quiz data: $e');
      
    }

  }

  QuizQuestion get currentQuestion {
    if (currentIndex >= 0 && currentIndex < questions.length) {
      return questions[currentIndex];
    }
    // Return a default question if currentIndex is out of bounds
    return QuizQuestion(question: "No question available", options: [], correctAnswerIndex: 0);
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      selectedIndex = -1; // Reset selected index
    } else {
      // Quiz completed, show results or navigate to result screen
    }
    update();
  }
}






class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}