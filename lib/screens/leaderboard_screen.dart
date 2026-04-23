import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .order('total_score', ascending: false);

      print("DATA: $response"); // DEBUG

      setState(() {
        users = response;
        loading = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => loading = false);
    }
  }

  Color getRankColor(int index) {
    if (index == 0) return Colors.amber;
    if (index == 1) return Colors.grey;
    if (index == 2) return Colors.brown;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard "),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Text(
                "#${index + 1}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getRankColor(index),
                  fontSize: 16,
                ),
              ),

              title: Text(
                user['name'] ?? 'No Name',
                style: const TextStyle(
                    fontWeight: FontWeight.w600),
              ),

              subtitle: Text(
                "Score: ${user['total_score'] ?? 0}",
              ),

              trailing: Text(
                "Quiz: ${user['quizzes_attempted'] ?? 0}",
              ),
            ),
          );
        },
      ),
    );
  }
}