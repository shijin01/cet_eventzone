import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/departmentpages/participantlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
    // print("Data:$data1");
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
            const SizedBox(
              height: 20,
            ),
            if (data.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getdata,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 218, 237, 242),
                        child: ListTile(
                          title: Text(
                            data[index]['event_name'],
                            style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 165, 112, 208)),
                          ),
                          subtitle: Text(DateFormat('dd-mm-yyyy').format(
                              DateFormat('yyyy-mm-dd')
                                  .parse(data[index]['event_date']))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParticipantList(
                                    eid: data[index]['id'],
                                    eventname: data[index]['event_name'],
                                    eventdate: DateFormat('dd-mm-yyyy').format(
                                        DateFormat('yyyy-mm-dd')
                                            .parse(data[index]['event_date']))),
                              ),
                            );
                          },
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
