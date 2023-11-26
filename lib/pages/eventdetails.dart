import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  final int id;
  final String eventname, eventdescription, department, eventdate;
  final String? image, upi, ticketbookdate;
  final bool? ticket;
  final int? maxticket, remticket;
  final int? price;

  const EventDetails({
    super.key,
    required this.id,
    required this.eventname,
    required this.eventdescription,
    required this.department,
    required this.eventdate,
    required this.ticket,
    this.image,
    this.upi,
    this.ticketbookdate,
    this.maxticket,
    this.remticket,
    this.price,
  });

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('https://picsum.photos/250?image=9'),
                  ),
                ),
                height: MediaQuery.sizeOf(context).height * .5,
                width: MediaQuery.sizeOf(context).width * .75,
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.sizeOf(context).height * .5,
                  width: MediaQuery.sizeOf(context).width * .75,
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: "Algerian"),
                  )),
            ],
          ),

          // ,Text(
          //   widget.eventname,
          //   style: const TextStyle(
          //       color: Color.fromARGB(255, 88, 244, 86),
          //       fontSize: 40.0,
          //       ),
          // ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.eventdate,
                style: TextStyle(
                  color: Colors.teal[300],
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                widget.department,
                style: TextStyle(color: Colors.teal[300], fontSize: 20.0),
              )
            ],
          ),
          const SizedBox(height: 5),
          if (widget.image != null)
            SizedBox(
              height: 100,
              width: 100,
              child: Image.network("https://picsum.photos/250?image=9"),
            )
          else
            const Text(""),
          const SizedBox(height: 5),
          Text(
            widget.eventdescription,
            style: const TextStyle(
                color: Color.fromARGB(255, 228, 155, 255), fontSize: 20.0),
          ),
          if (widget.ticket!)
            Column(
              children: [
                Text(
                    "Ticket Price:${widget.price}\nLast date to book ticket:${widget.ticketbookdate}",
                    style: const TextStyle(
                        color: Color.fromRGBO(213, 42, 42, 1), fontSize: 20.0)),
                ElevatedButton(onPressed: () {}, child: const Text("BOOK"))
              ],
            )
          else
            const Text("")
        ],
      )),
    );
  }
}
