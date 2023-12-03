import 'package:cet_eventzone/clientsupa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParticipantsView extends StatefulWidget {
  const ParticipantsView({super.key});

  @override
  State<ParticipantsView> createState() => _ParticipantsViewState();
}

class _ParticipantsViewState extends State<ParticipantsView> {
  List<dynamic> data = [];
  int? lid;
  SupabaseClient supabase = getclient();
  Future<void> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lid = prefs.getInt('lid');
    final department =
        await supabase.from('userdetails').select('department').eq('lid', lid);
    final data1 = await supabase
        .from('events')
        .select('*')
        .match({'department': department[0]['department'], 'ticket': 'TRUE'});
    if (mounted) {
      setState(() {
        data = data1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const Text("Helo"),
            const SizedBox(
              height: 10,
            ),
            if (data.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getdata,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(data[index]['event_name']),
                          subtitle: Text(data[index]['event_date']),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              const CircularProgressIndicator(),
          ]),
        ),
      ),
    );
  }
}
