import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizController quizController = Get.put(QuizController());

   QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Obx(() {
        if (quizController.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Question ${quizController.currentIndex + 1} of ${quizController.questions.length}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(quizController.currentQuestion.question),
              ),
              const SizedBox(height: 20),
              Column(
                children: quizController.currentQuestion.options
                    .asMap()
                    .entries
                    .map((entry) {
                      int index = entry.key;
                      String option = entry.value;
                      return RadioListTile<int>(
                        title: Text(option),
                        value: index,
                        groupValue: quizController.selectedIndex,
                        onChanged: (value) => quizController.selectedIndex = value!,
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: quizController.nextQuestion,
                child: const Text('Next'),
              ),
            ],
          );
        }
      }),
    );
  }
}
