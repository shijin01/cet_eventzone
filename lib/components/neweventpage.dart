import 'dart:async';

// import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/main.dart';
import 'package:cet_eventzone/pages/eventdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  // final StreamController<List<Map<String, dynamic>>> _streamController =
  //     StreamController<List<Map<String, dynamic>>>();
  // Stream<List<Map<String, dynamic>>> get _stream => _streamController.stream;

  final _streamdata =
      supabase.from('events').stream(primaryKey: ['id']).order('id');
  final searchcontroller = TextEditingController();
  String searchvalue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: 50,
              child: TextField(
                autofocus: false,
                controller: searchcontroller,
                onChanged: (value) {
                  // print("Value:$value");
                  setState(() {
                    searchvalue = value;
                  });
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.blue),
                    hintStyle:
                        const TextStyle(color: Color.fromARGB(255, 14, 58, 95)),
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            searchcontroller.text = "";
                            searchvalue = '';
                          });
                        },
                        icon: const Icon(Icons.close))),
              ),
            ),
            Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _streamdata,
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> data =
                      snapshot.data as List<Map<String, dynamic>>;
                  if (searchvalue.isNotEmpty) {
                    data = data.where((element) {
                      // print("Element:${element['event_name']}");
                      if (element['event_name']
                              .toString()
                              .toLowerCase()
                              .contains(searchvalue.toLowerCase()) ||
                          element['department']
                              .toString()
                              .toLowerCase()
                              .contains(searchvalue.toLowerCase())) {
                        return true;
                      } else {
                        return false;
                      }
                    }).toList();
                    // print("Data:$data");
                  }
                  // if (searchvalue.length == 0) {
                  //   data = snapshot.data as List<Map<String, dynamic>>;
                  // }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(data[index]['event_name'] +
                                  " " +
                                  DateFormat('dd-mm-yyyy').format(
                                      DateFormat('yyyy-mm-dd')
                                          .parse(data[index]['event_date'])) ??
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
                                        eventname: data[index]['event_name'],
                                        eventdescription: data[index]
                                            ['event_description'],
                                        eventdate: DateFormat('dd-mm-yyyy')
                                            .format(DateFormat('yyyy-mm-dd')
                                                .parse(
                                                    data[index]['event_date'])),
                                        department: data[index]['department'],
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
            )),
          ]),
        ),
      ),
    );
  }
}
