import 'package:flutter/material.dart';
import 'package:cet_eventzone/main.dart';

class SuperuserView extends StatefulWidget {
  const SuperuserView({super.key});

  @override
  State<SuperuserView> createState() => _SuperuserViewState();
}

class _SuperuserViewState extends State<SuperuserView> {
  final _stream = supabase.from('login').stream(primaryKey: ['id']);

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
                return Container(
                  padding: const EdgeInsets.all(50),
                  child: Text("loading",
                      style: TextStyle(color: Colors.blue[100])),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
