import 'package:cet_eventzone/clientsupa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = getclient();
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
      children: [
        GestureDetector(
            child: Container(
                padding: const EdgeInsets.all(25),
                // margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 219, 145, 145),
                  // borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Text(
                  "Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )))),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(25),
            // margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 219, 145, 145),
              // borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Change Password",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          onTap: () async {
            try {
              await supabase.auth.reauthenticate();
            } catch (err) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Erroe:$err")));
            }
          },
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(25),
            // margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 229, 159, 159),
              // borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          onTap: () async {
            try {
              await supabase.auth.signOut();
              final pref = await SharedPreferences.getInstance();
              await pref.setString("SESSION", "");
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed('/login');
            } catch (err) {
              SnackBar(content: Text("Error occured:$err"));
            }
          },
        ),
      ],
    ))));
  }
}
