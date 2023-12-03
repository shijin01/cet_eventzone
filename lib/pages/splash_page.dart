import 'package:cet_eventzone/components/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/secretkey.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String usertype;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    _redirect();
    super.initState();
  }

  Future<void> _redirect() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: anonkey);
     OneSignal.initialize(onesignal);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
    await Future.delayed(Duration.zero);
    final pref = await SharedPreferences.getInstance();
    usertype = pref.getString("typeofuser") ?? "department";
    if (!mounted) {
      return;
    }
    final supabase = getclient();

    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen(usertype: usertype, selectedIndex: 0)),
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(child: Text("Splash screen")),
      ),
    );
  }
}
