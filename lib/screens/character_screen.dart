import 'package:flutter/material.dart';
import 'package:begin/screens/quiz_screen.dart';
import 'package:begin/screens/profile_screen.dart';
class CharacterScreen extends StatelessWidget {

  final int storyId;
  //take input from previous page
  const CharacterScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {

    final List<String> characters = [
      "Bhishma",
      "Yudhishthira",
      "Bhima",
      "Arjuna",
      "Draupadi",
      "Karna",
      "Duryodhana",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE0B2),

        title: const Text(
          "ITIVRUTTA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Color(0xFF5D4037),
          ),
        ),

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


          child: Column(//column mai chahiye
            children: [//multiple widgets chahiye



              Expanded(//fill remaining space no need to write height
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  itemCount: characters.length,

                  itemBuilder: (context, index) { //inside this how much widgets eill repeat indextimes

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
                        margin: const EdgeInsets.only(bottom: 16),//add gap in bottom of each container
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 18,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),

                          borderRadius: BorderRadius.circular(14),

                          border: Border.all(
                            color: const Color(0xFFFFC107),
                            width: 1.8,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.20),
                              offset: const Offset(0, 6),//x,y position of shadow
                            )
                          ],
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,//in row add space between all children
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
    );
  }
}