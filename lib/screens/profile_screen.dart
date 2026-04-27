import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CreateProfileScreen(),
        ),
      );
    } else {
      setState(() {
        profile = data;
        isLoading = false;
      });
    }
  }


  String getChakra(int score) {
    if (score <= 10) return "Padatik";
    if (score <= 20) return "Ashvarohi";
    if (score <= 30) return "Gaja";
    if (score <= 40) return "ArdhaRathi";
    if (score <= 50) return "Rathi";
    if (score <= 60) return "Maharathi";
    return "Ati-Maharathi";
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final score = profile!['total_score'] ?? 0;
    final quizzes = profile!['quizzes_attempted'] ?? 0;

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
          ),

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
          child: Center(
            child: Container(

              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFC107),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [


                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFFFFF3E0),
                    child: Icon(
                      Icons.person,
                      size: 42,
                      color: Color(0xFF5D4037),
                    ),
                  ),

                  const SizedBox(height: 16),


                  Text(
                    profile!['name'] ?? "Player",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),

                  const SizedBox(height: 20),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statBox("Score", score.toString()),
                      _statBox("Quizzes", quizzes.toString()),
                    ],
                  ),

                  const SizedBox(height: 20),


                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Yoddha Shreni: ${getChakra(score)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6D4C41),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _statBox(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.brown[600],
          ),
        ),
      ],
    );
  }
}