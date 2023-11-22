// ignore_for_file: control_flow_in_finally
import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> createuser(BuildContext context, email, String password) async {
  try {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res.user;
  } catch (err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error:$err"),
      backgroundColor: Colors.red,
    ));
    return null;
  }
  // print("result after singup:" + res.user.toString());
}

Future<int> insertintologin(
    String username, String typeofuser, String uid) async {
  final List<Map<String, dynamic>> data = await supabase.from('login').insert([
    {'username': username, 'typeofuser': typeofuser, 'uid': uid},
  ]).select();
  // print("-----\n\nREturn at insertinto login:${data[0]['id']}");
  return data[0]['id'];
}

Future<bool> insertintouserdetails(
    int lid, String name, String department, int year) async {
  bool success = true;
  try {
    await supabase.from('userdetails').insert([
      {
        'lid': lid,
        'name': name,
        "department": department,
        "year": year.toString()
      },
    ]);
    // print("-----\n\nResult at login:$res");
  } catch (err) {
    success = false;
  } finally {
    // print("-----\n\nSuccess at insertintouserdetails:$success");
    return success;
  }
}

Future<List<Map<String, dynamic>>> selectdepartmentusers() async {
  // print("inside fun");
  // const typeofuser = "department";
  final List<Map<String, dynamic>> data =
      await supabase.from('login').select('id,username,typeofuser');
  List<Map<String, dynamic>> d = [];
  for (var i in data) {
    print(i);
    if (i['typeofuser'] != 'admin') {
      d.add(i);
    }
  }
  return d;
}

void deletedepartmentusers(BuildContext context, int id) async {
  // print("inside fun");
  final List<Map<String, dynamic>> data =
      await supabase.from('userdetails').delete().match({'lid': id}).select();
  if (data.isNotEmpty) {
    List<Map<String, dynamic>> data1 =
        await supabase.from('login').delete().match({'id': id}).select();
    if (data1.isNotEmpty) {
      final supaAuth = getAuth();
      try {
        await supaAuth.auth.admin.deleteUser(data1[0]['uid']);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[200],
            content: const Text("Successfully deleted")));
      } catch (err) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error in login")));
    }
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Error in userdetails")));
  }
}

void logout(BuildContext context) async {
  try {
    await supabase.auth.signOut();
    final pref = await SharedPreferences.getInstance();
    await pref.setString("SESSION", "");
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/login');
  } catch (err) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error occured:$err")));
  }
}

Future<bool> changeuserpassword(BuildContext context, String pwd) async {
  try {
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        password: pwd,
      ),
    );
    final User? updatedUser = res.user;
    return true;
  } on AuthException catch (err) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(err.message),
      backgroundColor: Colors.red[300],
    ));
    return false;
  } catch (err) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Something went Wrong"),
      backgroundColor: Colors.red[300],
    ));
    return false;
  }
}
