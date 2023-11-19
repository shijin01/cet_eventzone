import 'package:cet_eventzone/clientsupa.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = getclient();
    return SafeArea(
        child: Column(
      children: [
        Card( child: TextButton(onPressed: () {}, child: const Text("Details"))),
        Card(
          
          child: TextButton(
              onPressed: () async {
                await supabase.auth.reauthenticate();
              },
              child: const Text("Change password")),
        ),
        Card(
          child: TextButton(
              onPressed: () async {
                try {
                  await supabase.auth.reauthenticate();
                } catch (err) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Erroe:$err")));
                }
              },
              child: const Text("Logout")),
        )
      ],
    ));
  }
}
