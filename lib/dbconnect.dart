// ignore_for_file: control_flow_in_finally

import 'package:cet_eventzone/main.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> createuser(BuildContext context, email, String password) async {
  try {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res.user!.email == email;
  } catch (err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error:$err"),
      backgroundColor: Colors.red,
    ));
    return false;
  }
  // print("result after singup:" + res.user.toString());
}

Future<int> insertintologin(String username, String typeofuser) async {
  final List<Map<String, dynamic>> data = await supabase.from('login').insert([
    {'username': username, 'typeofuser': typeofuser},
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
  print("inside fun");
  final List<Map<String, dynamic>> data = await supabase
      .from('login')
      .select('id,username,typeofuser,userdetails(name,department,year)');
  return data;
}
