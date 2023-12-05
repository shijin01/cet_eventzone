import 'package:cet_eventzone/clientsupa.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParticipantList extends StatefulWidget {
  String eventname, eventdate;
  int eid;
  ParticipantList(
      {super.key,
      required this.eid,
      required this.eventname,
      required this.eventdate});

  @override
  State<ParticipantList> createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  List<dynamic> data = [];
  int? lid;
  SupabaseClient supabase = getclient();
  Future<void> getdata() async {
    final liddetails =
        await supabase.from('tickets').select('*,login(id)').match({
      'event_id': widget.eid,
    });
    List<int> lids = [];
    for (var i in liddetails) {
      lids.add(i['login']['id']);
    }
    final studentlist =
        await supabase.from('userdetails').select('*').in_('lid', lids);
    print("Student data:$studentlist");
    if (mounted) {
      setState(() {
        data = studentlist;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
        ),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              Text(
                widget.eventname,
                style: GoogleFonts.abel(fontSize: 40, color: Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getdata,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: DataTable(
                        headingTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        columnSpacing: 28,
                        columns: [
                          DataColumn(label: HeadingText(s: 'Sl No.')),
                          DataColumn(label: HeadingText(s: 'Name')),
                          DataColumn(label: HeadingText(s: 'Department')),
                          DataColumn(label: HeadingText(s: 'Year'))
                        ],
                        rows: data.isNotEmpty
                            ? List.generate(data.length, (index) {
                                {
                                  print('data length:${data.length}');
                                  return DataRow(cells: [
                                    DataCell(
                                        CellText(s: (index + 1).toString())),
                                    DataCell(CellText(s: data[index]['name'])),
                                    DataCell(
                                        CellText(s: data[index]['department'])),
                                    DataCell(CellText(s: data[index]['year']))
                                  ]);
                                }
                              })
                            : <DataRow>[
                                DataRow(cells: [
                                  const DataCell(SizedBox.shrink()),
                                  DataCell(CellText(s: "No     data")),
                                  DataCell(CellText(s: "found")),
                                  const DataCell(SizedBox.shrink()),
                                ])
                              ]),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}

// ignore: must_be_immutable
class HeadingText extends StatelessWidget {
  String s;
  HeadingText({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return Text(
      s,
      style: GoogleFonts.acme(
        color: Colors.blueGrey,
        // fontSize: 10
      ),
    );
  }
}

class CellText extends StatelessWidget {
  String s;
  CellText({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return Text(
      s,
      style: GoogleFonts.abhayaLibre(color: Colors.blueGrey, fontSize: 18),
    );
  }
}
