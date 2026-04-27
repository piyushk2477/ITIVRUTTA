import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';

// result available letter for api call
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();//flutter pehle initialize

  await Supabase.initialize(
    url: 'https://ftlqxpdqcqsvevksnvfe.supabase.co',
    anonKey: 'sb_publishable_RSQ_IoelpaOfJdZMHN7Y7g_8cZ3gDZ7',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // root
  @override
  Widget build(BuildContext context) {
    return const MaterialApp( //gives app design
      debugShowCheckedModeBanner: false,
      home: Login() //home is first screen hence
    );
  }
}





