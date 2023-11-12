import 'package:flutter/material.dart';
import 'package:cet_eventzone/main.dart';
import 'package:supabase/src/supabase_stream_builder.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final SupabaseStreamBuilder _stream =
      supabase.from('events').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Map<String, dynamic>> data =
              snapshot.data as List<Map<String, dynamic>>;
          return Column(children: [
            Text("SearchBar"),
            ListView.builder(
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
            ),
          ]);
        } else {
          return Text("loading");
        }
      },
    );
  }
}
