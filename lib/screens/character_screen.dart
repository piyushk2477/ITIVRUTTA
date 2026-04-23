import 'package:flutter/material.dart';
import 'package:begin/screens/quiz_screen.dart';
import 'package:begin/screens/profile_screen.dart';
class CharacterScreen extends StatelessWidget {

  final int storyId;

  const CharacterScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {

    final List<String> characters = [
      "Bhishma",
      "Yudhishthira",
      "Bhima",
      "Arjun",
      "Draupadi",
      "Karna",
      "Duryodhan",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE0B2), // softer gold (matches image)
        elevation: 0,
        title: const Text(
          "ITIVRUTTA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Color(0xFF5D4037), // royal brown
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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: characters.length,

                  itemBuilder: (context, index) {

                    final character = characters[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              storyId: storyId,
                              character: character,
                            ),
                          ),
                        );
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 18,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),

                          borderRadius: BorderRadius.circular(18),

                          border: Border.all(
                            color: const Color(0xFFFFC107),
                            width: 1.8,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.18),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [


                            Text(
                              character,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5D4037),
                                letterSpacing: 0.5,
                              ),
                            ),


                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Color(0xFF5D4037),
                            ),

                          ],
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