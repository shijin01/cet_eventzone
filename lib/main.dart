import 'package:cet_eventzone/clientsupa.dart';

import 'package:cet_eventzone/pages/splash_page.dart';

import 'package:flutter/material.dart';
import 'package:cet_eventzone/components/login.dart';

Future<void> main() async {
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
      },
      // home: const MyHomePage(title: 'Campus EventZone'),
    );
  }
}
