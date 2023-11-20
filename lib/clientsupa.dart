import 'package:cet_eventzone/secretkey.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient getclient() {
  return Supabase.instance.client;
}

SupabaseClient getAuth() {
  final supabase = SupabaseClient(supabaseUrl, serviceRoleKey);
  return supabase;
}
