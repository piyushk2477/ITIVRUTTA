import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChapterQuizScreen extends StatefulWidget {
  final int storyId;
  final int chapterId;

  const ChapterQuizScreen({
    super.key,
    required this.storyId,
    required this.chapterId,
  });

  @override
  State<ChapterQuizScreen> createState() => _ChapterQuizScreenState();
}

class _ChapterQuizScreenState extends State<ChapterQuizScreen> {
  final supabase = Supabase.instance.client;

  List questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;
  bool isQuizFinished = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final data = await supabase
        .from('chapter_questions')
        .select()
        .eq('story_id', widget.storyId)
        .eq('chapter_id', widget.chapterId)
        .order('question_order');

    setState(() {
      questions = data;
      isLoading = false;
    });
  }

  void checkAnswer(String option) {
    final correct = questions[currentIndex]['correct_answer'];

    if (option == correct) {
      score++;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          selectedOption = null;
        });
      } else {
        setState(() {
          isQuizFinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }


    if (isQuizFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text("Result")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quiz Completed 🎉",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Text(
                "$score / ${questions.length}",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Back to Home"),
              )
            ],
          ),
        ),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter Quiz"),
        backgroundColor: const Color(0xFFFFE0B2),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Text(
              "Question ${currentIndex + 1} / ${questions.length}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // Question
            Text(
              q['question'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Options
            ...['option_a', 'option_b', 'option_c', 'option_d']
                .map((opt) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = q[opt];
                  });
                  checkAnswer(q[opt]);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: selectedOption == q[opt]
                        ? Colors.orange.shade300
                        : Colors.white,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    q[opt],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}