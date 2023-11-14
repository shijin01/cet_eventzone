// ignore_for_file: control_flow_in_finally

import 'package:cet_eventzone/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List> createuser(String email, String password) async {
  final AuthResponse res = await supabase.auth.signUp(
    email: 'example@email.com',
    password: 'example-password',
  );
  final Session? session = res.session;
  final User? user = res.user;
  return [session, user];
}

Future<int> insertintologin(String username, String typeofuser) async {
  final List<Map<String, dynamic>> data = await supabase.from('login').insert([
    {'username': username, 'typeofuser': typeofuser},
  ]).select();
  return data[0]['id'];
}

Future<bool> insertintouserdetails(
    int lid, String name, String department, int year) async {
  bool success = true;
  try {
    final List<Map<String, dynamic>> data =
        await supabase.from('login').insert([
      {'lid': lid, 'name': name, "department": department, "year": year},
    ]).select();
  } catch (err) {
    success = false;
  } finally {
    return success;
  }
}
