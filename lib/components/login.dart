import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/components/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adduser.dart';
// import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  // ignore: prefer_typing_uninitialized_variables
  var session;
  late final User? user;
  var showpassword = true;
  // final pref =await SharedPreferences.getInstance();
  // late final Session? session;
  // late final User? user;
  String? ses = "";
  late String utype;
  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final supabase = getclient();
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: passwordcontroller.text,
      );
      final pref = await SharedPreferences.getInstance();
      final session = res.session;
      final userlogindata = await supabase
          .from('login')
          .select('id,username,typeofuser')
          .match({'username': _emailController.text});
      // print(userlogindata);
      await pref.setString("SESSION", session!.persistSessionString ?? "");
      await pref.setInt("lid", userlogindata[0]['id']);
      await pref.setString("typeofuser", userlogindata[0]['typeofuser']);
      ses = await pref.getString("SESSION");
      utype = userlogindata[0]['typeofuser'];
      user = res.user;
      // print("user:$user");
    } on AuthException catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Unexpected error occurred::$error"),
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (ses != "") {
          print("inside");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(usertype: utype, selectedIndex: 0)),
          );
        }
      }
    }
  }

  @override
  void initState() {
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    if (_redirecting) return;
    // final session = data.session;
    if (ses != "") {
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
                        icon: showpassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                controller: passwordcontroller,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // print("user" + _emailController.text);
                if (!_isLoading) {
                  _signIn();
                }
              },
              child: const Text("LOGIN"),
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(),
                child: const Center(
                  child: Text(
                    "Create user",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 44, 40, 161),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddUser(typeofuser: "user")));
              },
            )
          ],
        ),
      ),
    );
  }
}
