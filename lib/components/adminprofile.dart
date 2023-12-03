
import 'package:cet_eventzone/components/changepassword.dart';
import 'package:cet_eventzone/dbconnect.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // final supabase = getclient();
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        SizedBox(
          height: 400,
          width: 400,
          child: Image.network(
              "https://blog.vantagecircle.com/content/images/size/w1000/2019/06/company-event.png"),
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(25),
            // margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 218, 237, 242),
              // borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Change Password",
                style: TextStyle(
                  // color: Color.fromARGB(255, 218, 237, 242),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePassword()));
          },
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(25),
            // margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 218, 237, 242),
              // borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Logout",
                style: TextStyle(
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
    )));
  }
}
