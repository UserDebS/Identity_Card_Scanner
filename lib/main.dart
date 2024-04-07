import 'package:flutter/material.dart';
import 'package:one_fa/routes/landing_page.dart';
import 'package:one_fa/routes/about_us.dart';
import 'package:one_fa/routes/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Owner: Debmalya Sarkar

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://nqwfsecktfvltnbpyesa.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xd2ZzZWNrdGZ2bHRuYnB5ZXNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgxNTUwNTMsImV4cCI6MjAyMzczMTA1M30.k4su1deYxuXIRPc237zNvJZgDCUPJdXV96eLmEqbPYI');
  runApp(const OFA());
}

class OFA extends StatelessWidget {
  const OFA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const OwnerLogIn(),
        '/aboutus': (context) => const AboutUs(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}
