import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/const/background_display.dart';
import 'package:quiz_app/const/image_asset_path.dart';
import 'package:quiz_app/controllers/auth_controller.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/quiz_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final QuizController quizController = Get.find();
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    quizController.saveCorrectAnswers();
  }

  @override
  Widget build(BuildContext context) {
    final int score = quizController.correctAnswers.value;
    final String resultText = score >= 3
        ? 'Congratulation !!'
        : 'You can do better !!\n Please try again';
    final Color resultTextColor = score >= 3 ? Colors.green : Colors.red;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: BackgroundImage(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  'Quiz Result!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 80),
                Image.asset(
                  score >= 3
                      ? ImageAssetPath.passImage
                      : ImageAssetPath.failImage,
                  width: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Your Score:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Obx(
                  () => Text(
                    '${quizController.correctAnswers} / ${quizController.quizQuestions.length}',
                    style: TextStyle(
                        fontSize: 24,
                        color: score >= 3 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  resultText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: resultTextColor),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 160,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          quizController.resetQuiz();
                          Get.off(() => QuizPage());
                        },
                        child: const Text(
                          'Restart Quiz',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 160,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          authController.signOut();
                          Get.offAll(()=>const LoginScreen());
                        },
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'App Developed by   -   Gaurav Santosh Varadkar',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void openUrl(String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
