import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/components/homescreen.dart';
import 'package:cet_eventzone/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:cet_eventzone/components/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ibvtrimojltdjeksznji.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlidnRyaW1vamx0ZGpla3N6bmppIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2OTYyMTMsImV4cCI6MjAxNTI3MjIxM30.tpu3nR9IRvRezM15O4Z28TLz8El7Kh8zbHwomd8HGpg',
  );
  runApp(const MyApp());
}

final supabase = getclient();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus EventZone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/homepage': (_) => const HomeScreen(),
      },
      // home: const MyHomePage(title: 'Campus EventZone'),
    );
  }
}
