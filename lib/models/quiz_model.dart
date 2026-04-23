

class Quiz {

  final int id;
  final int storyId;
  final String character;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String explanation;

  Quiz({
    required this.id,
    required this.storyId,
    required this.character,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.explanation,
  });

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      storyId: map['story_id'],
      character: map['character'],
      question: map['question'],
      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],
      optionD: map['option_d'],
      correctAnswer: map['correct_answer'],
      explanation: map['explanation'],
    );
  }
}