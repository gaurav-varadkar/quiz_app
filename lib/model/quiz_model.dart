class QuizModel {
    String question;
    String answer;
    List<String> options;

    QuizModel({
        required this.question,
        required this.answer,
        required this.options,
    });

    factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        question: json["question"],
        answer: json["answer"],
        options: List<String>.from(json["options"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "options": List<dynamic>.from(options.map((x) => x)),
    };
}
