import 'package:flutter/material.dart';
import 'package:cet_eventzone/main.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final _stream = supabase.from('events').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text("Helo"),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _stream,
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              if (snapshot.hasData) {
                List<Map<String, dynamic>> data =
                    snapshot.data as List<Map<String, dynamic>>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(data[index]['event_name'] +
                                " " +
                                data[index]['event_date'] ??
                            " "),
                        subtitle: Text(data[index]['department']),
                        // trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              } else {
                return Container(child:  Text("loading",style: TextStyle(color: Colors.blue[100])), padding: EdgeInsets.all(50),);
              }
            },
          ),
        ),
      ],
    );
  }
}
