import 'package:cet_eventzone/dbconnect.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ticket_view/ticketview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_material/ticket_material.dart';

class TicketBook extends StatefulWidget {
  const TicketBook({super.key});

  @override
  State<TicketBook> createState() => _TicketBookState();
}

class _TicketBookState extends State<TicketBook> {
  Future<List<Map<String, dynamic>>>? data;
  Future<void> getdata() async {
    // Future.delayed(Duration.zero)
    // ;
    setState(() {
      data = selectticketdetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        children: [
          const Text("Helo"),
          const SizedBox(
            height: 10,
          ),
          if (data != [])
            Expanded(
              child: RefreshIndicator(
                onRefresh: getdata,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: data,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        List<Map<String, dynamic>> data1 =
                            snapshot.data as List<Map<String, dynamic>>;
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TicketMaterial(
                              height: 100,
                              colorBackground: Colors.blue,
                              tapHandler: () {
                                print("hlo");
                              },
                              leftChild: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'PROMO TICKET',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Text(
                                      '\$10.00',
                                      style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '120 Tickets Available',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              rightChild: Text(">"),
                            );
                          },
                        );
                      }

                      /// handles others as you did on question
                      else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    )));
  }
}
