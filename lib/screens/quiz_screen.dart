import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  final int storyId;
  final String character;

  const QuizScreen({
    super.key,
    required this.storyId,
    required this.character,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  List<Quiz> questions = [];

  int currentIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();//need for setup parent class initialize
    fetchQuestions();
  }

  //fetch ques
  Future<void> fetchQuestions() async {
    try {
      final data = await Supabase.instance.client
          .from('quiz')
          .select()
          .eq('story_id', widget.storyId)
          .ilike('character', widget.character.trim())
          .order('id', ascending: true);

      setState(() {
        questions = data.map((e) => Quiz.fromMap(e)).toList();
        isLoading = false;
      });

    } catch (e) {
      print("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  //for saving code and score to profile
  Future<void> saveScore() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final existing = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing != null) {
      await Supabase.instance.client.from('profiles').update({
        'total_score': (existing['total_score'] ?? 0) + score,
        'quizzes_attempted': (existing['quizzes_attempted'] ?? 0) + 1,
      }).eq('id', user.id);
    } else {
      await Supabase.instance.client.from('profiles').insert({
        'id': user.id,
        'total_score': score,
        'quizzes_attempted': 1,
      });
    }
  }

  void checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showResult = true;

      if (answer.trim() ==
          questions[currentIndex].correctAnswer.trim()) {
        score++;
      }
    });
  }

  void nextQuestion() async {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        showResult = false;
      });
    } else {
      await saveScore();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Quiz finished Each answer is a step deeper into the Mahabharata"),
          content: Text("Score: $score / ${questions.length}",),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No questions found ")),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(


      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFBF2),
              Color(0xFFFFF8E1),
              Color(0xFFFFECB3),
              Color(0xFFFFD180),
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Text(
                  "Question ${currentIndex + 1}/${questions.length}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6D4C41),
                  ),
                ),

                const SizedBox(height: 10),

                //ques card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFFFC107),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.2),
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Text(
                    q.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ),

                const SizedBox(height: 20),


                optionButton(q.optionA, q),
                optionButton(q.optionB, q),
                optionButton(q.optionC, q),
                optionButton(q.optionD, q),

                const SizedBox(height: 20),


                if (showResult)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          selectedAnswer!.trim() ==
                              q.correctAnswer.trim()
                              ? " Correct"
                              : " Wrong",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text("Answer: ${q.correctAnswer}"),

                        const SizedBox(height: 6),

                        Text(
                          q.explanation,
                          style: const TextStyle(fontSize: 13),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: nextQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
                              foregroundColor: const Color(0xFF5D4037),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Next"),
                          ),
                        )

                      ],
                    ),
                  )

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget optionButton(String text, Quiz q) {

    final bool isSelected = selectedAnswer == text;
    final bool isCorrect = text.trim() == q.correctAnswer.trim();

    Color bgColor = Colors.white.withOpacity(0.95);

    if (showResult) {
      if (isCorrect) {
        bgColor = Colors.green.withOpacity(0.3);
      } else if (isSelected) {
        bgColor = Colors.red.withOpacity(0.3);
      }
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),

      child: ElevatedButton(
        onPressed: showResult ? null : () => checkAnswer(text),

        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: const Color(0xFF5D4037),
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(
              color: Color(0xFFFFC107),
              width: 1,
            ),
          ),
        ),

        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}