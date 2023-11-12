import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cet_eventzone/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;

  // late final StreamSubscription<AuthState> _authStateSubscription;

  final _emailController = TextEditingController();
  final passwordcontroller = TextEditingController();
  Session? session = null;
  late final User? user;
  var showpassword = true;

  // late final Session? session;
  // late final User? user;
  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: passwordcontroller.text,
      );
      session = res.session;
      user = res.user;
      print("user:$user");
    } on AuthException catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (session != null) {
          Navigator.of(context).pushReplacementNamed('/homepage');
        }
      }
    }
  }

  @override
  void initState() {
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    if (_redirecting) return;
    // final session = data.session;
    if (session != null) {
      _redirecting = true;
      Navigator.of(context).pushReplacementNamed('/homepage');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent[200],
        title: const Text("Welcome"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              controller: _emailController,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
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
                      icon: const Icon(Icons.remove_red_eye)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              controller: passwordcontroller,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                print("user" + _emailController.text);
                if (!_isLoading) {
                  _signIn();
                }
              },
              child: const Text("LOGIN"))
        ],
      )),
    );
  }
}
