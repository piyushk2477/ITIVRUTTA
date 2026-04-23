import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:begin/screens/home_screen.dart';
import 'package:begin/screens/create_profile_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/iti1.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 400),
                const SizedBox(height: 100),

                // EMAIL
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.brown),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // PASSWORD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.brown),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // LOGIN BUTTON
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {

                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    setState(() => isLoading = true);

                    try {
                      final response = await Supabase.instance.client.auth
                          .signInWithPassword(
                        email: email,
                        password: password,
                      );

                      final user = response.user;

                      if (user == null) return;

                      // check profile exists
                      final profile = await Supabase.instance.client
                          .from('profiles')
                          .select()
                          .eq('id', user.id)
                          .maybeSingle();

                      if (!mounted) return;

                      if (profile == null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const CreateProfileScreen(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const HomeScreen(),
                          ),
                        );
                      }

                    } catch (e) {
                      print("Login Failed $e");
                    }

                    setState(() => isLoading = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  child: Text(
                    isLoading ? "Loading..." : "Login",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // SIGNUP BUTTON
                ElevatedButton(
                  onPressed: () async {

                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    try {
                      final response =
                      await Supabase.instance.client.auth.signUp(
                        email: email,
                        password: password,
                      );

                      final user = response.user;

                      if (user == null) return;

                      //  direct to profile creation
                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const CreateProfileScreen(),
                        ),
                      );

                    } catch (e) {
                      print("Signup error: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Signup",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}