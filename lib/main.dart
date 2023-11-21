import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/components/homescreen.dart';
import 'package:cet_eventzone/pages/splash_page.dart';
import 'package:cet_eventzone/secretkey.dart';
import 'package:flutter/material.dart';
import 'package:cet_eventzone/components/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: supabaseUrl, anonKey: anonkey);
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
        '/homepage': (_) => const HomeScreen(selectedIndex: 0,),
      },
      // home: const MyHomePage(title: 'Campus EventZone'),
    );
  }
}
