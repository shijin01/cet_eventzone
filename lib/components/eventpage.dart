import 'package:cet_eventzone/departmentpages/addevent.dart';
import 'package:cet_eventzone/pages/eventdetails.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetails(
                                            id: data[index]['id'],
                                            eventname: data[index]
                                                ['event_name'],
                                            eventdescription: data[index]
                                                ['event_description'],
                                            eventdate: data[index]
                                                ['event_date'],
                                            department: data[index]
                                                ['department'],
                                            ticket: data[index]['ticket'],
                                            image: data[index]['image'],
                                            maxticket: data[index]
                                                ['max_no_of_tickets'],
                                            remticket: data[index]
                                                ['remaining_ticket'],
                                            price: data[index]['price'],
                                            ticketbookdate: data[index]
                                                ['ticket_book_date'],
                                            upi: data[index]['upi'],
                                            reciever: data[index]['upi'],
                                          )),
                                );
                              },
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
          ),
        ),
      ),
    );
  }
}
