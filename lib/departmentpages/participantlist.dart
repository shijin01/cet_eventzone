import 'package:cet_eventzone/clientsupa.dart';
import 'package:flutter/material.dart';
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
          title: const Text("EventZone"),
        ),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              Text(widget.eventname),
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
                        columns: const [
                          DataColumn(label: Text('Sl No.')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Department')),
                          DataColumn(label: Text('Year'))
                        ],
                        rows: data.isNotEmpty
                            ? List.generate(data.length, (index) {
                                {
                                  print('data length:${data.length}');
                                  return DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(data[index]['name'])),
                                    DataCell(Text(data[index]['department'])),
                                    DataCell(Text(data[index]['year']))
                                  ]);
                                }
                              })
                            : const <DataRow>[
                                DataRow(cells: [
                                  DataCell(SizedBox.shrink()),
                                  DataCell(Text("No     data")),
                                  DataCell(Text("found")),
                                  DataCell(SizedBox.shrink()),
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
