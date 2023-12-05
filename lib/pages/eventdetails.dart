import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/userscomponent/upipage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetails extends StatefulWidget {
  final int id;
  final String eventname, eventdescription, department, eventdate;
  final String? image, upi, ticketbookdate, reciever;
  final bool? ticket;
  final int? maxticket, remticket;
  final int? price;

  const EventDetails(
      {super.key,
      required this.id,
      required this.eventname,
      required this.eventdescription,
      required this.department,
      required this.eventdate,
      required this.ticket,
      required this.image,
      required this.upi,
      required this.ticketbookdate,
      required this.maxticket,
      required this.remticket,
      required this.price,
      required this.reciever});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  // late int id;
  // late String eventname, eventdescription, department, eventdate;
  // String? image, upi, ticketbookdate;
  // bool? ticket;
  // int? maxticket, remticket;
  // double? price;
  late String imageurl;
  String? typeouser;
  Future<void> getImageURL() async {
    final supabase = getclient();
    if (widget.image != null && widget.image != "") {
      imageurl =
          supabase.storage.from('eventphoto').getPublicUrl(widget.image!);
    }
  }

  getusertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      typeouser = prefs.getString("typeofuser");
    });
    // typeouser = prefs.getString("typeofuser");
    // print(typeouser);
  }

  @override
  Widget build(BuildContext context) {
    getusertype();
    getImageURL();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: (widget.image != null)
                            ? NetworkImage(imageurl)
                            : const NetworkImage(
                                'https://images.unsplash.com/photo-1657363599860-d2595309673e?q=80&w=1854&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                    height: MediaQuery.sizeOf(context).height * .65,
                    width: MediaQuery.sizeOf(context).width * .95,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Image(
                              // fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * .75,
                              width: MediaQuery.of(context).size.width * .75,
                              image: (widget.image != null)
                                  ? NetworkImage(imageurl)
                                  : const NetworkImage(
                                      'https://images.unsplash.com/photo-1657363599860-d2595309673e?q=80&w=1854&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                            );
                          });
                    },
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.sizeOf(context).height * .65,
                        width: MediaQuery.sizeOf(context).width * .95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.grey.withOpacity(0.0),
                                  Colors.black,
                                ],
                                stops: const [
                                  0.0,
                                  1.0
                                ])),
                        child: Text(
                          widget.eventname,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34.0,
                              fontFamily: "Algerian"),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Date:",
                    style: TextStyle(color: Colors.teal[300], fontSize: 20.0),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.eventdate,
                    style: TextStyle(
                      color: Colors.teal[300],
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Department:",
                    style: TextStyle(color: Colors.teal[300], fontSize: 20.0),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.department,
                    style: TextStyle(color: Colors.teal[300], fontSize: 20.0),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Descriptions",
                    style: TextStyle(
                        color: Color.fromARGB(255, 228, 155, 255),
                        fontSize: 26.0,
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromARGB(255, 228, 155, 255)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  widget.eventdescription,
                  style: const TextStyle(
                      letterSpacing: 1.25,
                      color: Color.fromARGB(255, 244, 215, 255),
                      fontSize: 20.0),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (widget.ticket!)
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FittedBox(
                            child: Text(
                              "Purchase ticket on or before ${DateFormat('dd-mm-yyyy').format(DateFormat('yyyy-mm-dd').parse(widget.ticketbookdate!))}",
                              style: const TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                backgroundColor: Color.fromRGBO(233, 98, 98, 1),
                              ),
                              // fontSize: 20.0),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Ticket Price:${widget.price}",
                            style: const TextStyle(
                                color: Color.fromRGBO(252, 211, 211, 1),
                                fontSize: 20.0))
                      ],
                    ),
                    if (typeouser?.compareTo("user") == 0)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    Color.fromARGB(255, 8, 93, 104),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            onPressed: (DateFormat('yyyy-mm-dd')
                                        .parse(DateFormat('yyyy-mm-dd')
                                            .format(DateTime.now()))
                                        .compareTo(DateFormat('yyyy-mm-dd')
                                            .parse(widget.ticketbookdate!)) <
                                    0)
                                ? () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    int? lid = prefs.getInt("lid");
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpiPageView(
                                                  upi: widget.upi,
                                                  reciever: widget.reciever,
                                                  eventname: widget.eventname,
                                                  price: widget.price,
                                                  eid: widget.id,
                                                  lid: lid,
                                                )));
                                  }
                                : null,
                            child: const Text("PURCHASE NOW")),
                      )
                    else
                      const Text(""),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              else
                const Text("")
            ],
          ),
        ),
      )),
    );
  }
}
