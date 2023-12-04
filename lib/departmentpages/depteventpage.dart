import 'package:cet_eventzone/departmentpages/addevent.dart';
import 'package:cet_eventzone/main.dart';
import 'package:cet_eventzone/pages/eventdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DepartEvent extends StatefulWidget {
  const DepartEvent({super.key});

  @override
  State<DepartEvent> createState() => _DepartEventState();
}

class _DepartEventState extends State<DepartEvent> {
  final _stream =
      supabase.from('events').stream(primaryKey: ['id']).order('id');
  final searchcontroller = TextEditingController();
  String searchvalue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 141, 154, 157),
          child: const Icon(Icons.add_rounded,
              color: Color.fromARGB(255, 218, 237, 242), size: 30),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddEvent()));
          }),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
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
                      prefixIcon:
                          Icon(Icons.search_rounded, color: Colors.blue),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 14, 58, 95)),
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
                  stream: _stream,
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
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(2),
                            // decoration: const BoxDecoration(
                            //     borderRadius: BorderRadius.all(Radius.circular(25)),
                            //     gradient: LinearGradient(colors: [
                            //       // Color.fromARGB(255, 255, 106, 134),
                            //       Color.fromARGB(255, 236, 239, 239),
                            //       Color.fromARGB(255, 209, 226, 230),

                            //       // Color.fromARGB(255, 255, 106, 134),
                            //     ])),
                            child: Card(
                              color: Color.fromARGB(255, 218, 237, 242),
                              // const Color.fromARGB(255, 169, 210, 239),
                              child: ListTile(
                                title: Text(
                                  data[index]['event_name'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 165, 112, 208)),
                                ),
                                subtitle: Text(
                                  data[index]['department'] +
                                      "\n" +
                                      DateFormat('dd-mm-yyyy').format(
                                        DateFormat('yyyy-mm-dd')
                                            .parse(data[index]['event_date']),
                                      ),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 100, 95, 95)),
                                ),
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
                                              eventdate: DateFormat(
                                                      'dd-mm-yyyy')
                                                  .format(
                                                      DateFormat('yyyy-mm-dd')
                                                          .parse(data[index]
                                                              ['event_date'])),
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
