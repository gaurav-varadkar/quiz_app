import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/const/background_display.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizController quizController = Get.put(QuizController());

  QuizPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BackgroundImage(
        child: Center(
          child: GetBuilder<QuizController>(
            builder: (controller) {
              final questionIndex = controller.currentQuestionIndex.value;
              final questions = controller.quizQuestions;
              if (controller.isError) {
                return const Text('Something went wrong!');
              }
              if (questions.isEmpty) {
                return const CircularProgressIndicator();
              } else {
                final questionModule = questions[questionIndex];
                final options = questionModule.options;

                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Question No : ${questionIndex + 1}',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                      const SizedBox(height: 30),
                      Text(
                        questionModule.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              controller.setSelectedOption(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.selectedOption.value == index
                                    ? Colors.blueGrey
                                    : Colors.transparent,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  options[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        controller.selectedOption.value == index
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize:
                                        controller.selectedOption.value == index
                                            ? 22
                                            : 16,
                                    fontWeight:
                                        controller.selectedOption.value == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 60,
                        width: 150,
                        
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            if (controller.selectedOption.value != -1) {
                              controller.nextQuestion();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select an option!'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(milliseconds: 1800),
                                ),
                              );
                            }
                          },
                          child: Text(
                            questionIndex == questions.length - 1
                                ? 'Submit'
                                : 'Next',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
