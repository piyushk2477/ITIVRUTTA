import 'package:flutter/material.dart';
import 'package:begin/screens/profile_screen.dart';
import 'package:begin/screens/chapter_quiz_screen.dart';

class StoryCardsScreen extends StatefulWidget {
  final int storyId;

  const StoryCardsScreen({super.key, required this.storyId});

  @override
  State<StoryCardsScreen> createState() => _StoryCardsScreenState();
}

class _StoryCardsScreenState extends State<StoryCardsScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<String> cards = [
    "assets/images/chp1_1.jpeg",
    "assets/images/chpt1_2.jpeg",
    "assets/images/chpt1_3.jpeg",
    "assets/images/chpt1_4.jpeg",
    "assets/images/chpt1_5.jpeg",
  ];

  void nextCard() {
    if (currentIndex < cards.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterQuizScreen(
            storyId: widget.storyId,
            chapterId: 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE0B2),
        elevation: 0,
        title: const Text(
          "ITIVRUTTA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Color(0xFF5D4037),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF5D4037)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          )
        ],
      ),

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
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  itemCount: cards.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: nextCard,

                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFC107),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 18,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 25,
                                spreadRadius: 1,
                              )
                            ],
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),

                            child: InteractiveViewer(
                              minScale: 1,
                              maxScale: 4,
                              child: Image.asset(
                                cards[index],
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}