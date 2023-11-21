import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/components/changepassword.dart';
import 'package:cet_eventzone/dbconnect.dart';
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
            decoration: const BoxDecoration(
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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChangePassword()));
          },
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(25),
            // margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: const BoxDecoration(
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
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context1) => AlertDialog(
                title: const Text('Alert'),
                content: const Text('Logout?'),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    autofocus: true,
                    onPressed: () => Navigator.pop(context1, 'Cancel'),
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      logout(context);
                      Navigator.pop(context1, 'OK');
                    },
                    child:
                        const Text('OK', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ))));
  }
}
