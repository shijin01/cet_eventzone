import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/userscomponent/upipage.dart';
import 'package:flutter/material.dart';
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: "Algerian"),
                  )),
            ],
          ),
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
              child: Image.network(imageurl),
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
                if (typeouser?.compareTo("user") == 0)
                  ElevatedButton(
                      onPressed: () async {
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
                      },
                      child: const Text("BOOK"))
                else
                  const Text("")
              ],
            )
          else
            const Text("")
        ],
      )),
    );
  }
}
