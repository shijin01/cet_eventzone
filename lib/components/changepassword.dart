import 'package:cet_eventzone/components/homescreen.dart';
import 'package:cet_eventzone/dbconnect.dart';
import 'package:cet_eventzone/pages/splash_page.dart';
// import 'package:cet_eventzone/main.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final passwordcontroller = TextEditingController();
  final conpasswordcontroller = TextEditingController();
  bool showpassword = true;
  bool showpassword1 = true;
  Color colorofpass = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: showpassword,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                          icon: showpassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                  controller: passwordcontroller,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: showpassword1,
                  onChanged: (val) {
                    if (val != passwordcontroller.text) {
                      setState(() {
                        colorofpass = Color.fromARGB(255, 226, 137, 130);
                      });
                    } else {
                      setState(() {
                        colorofpass = Color.fromARGB(255, 179, 239, 180);
                      });
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: colorofpass,
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showpassword1 = !showpassword1;
                            });
                          },
                          icon: showpassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                  controller: conpasswordcontroller,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final ischanged =
                        changeuserpassword(context, conpasswordcontroller.text);
                    if (await ischanged) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Successfull"),
                        backgroundColor: Colors.green[200],
                      ));

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                usertype: usertype, selectedIndex: 2)),
                      );
                    }
                  },
                  child: const Text("CHANGE"))
            ],
          ),
        ),
      ),
    );
  }
}
