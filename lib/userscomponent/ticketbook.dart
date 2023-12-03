import 'package:cet_eventzone/dbconnect.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:flutter_ticket_view/ticketview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket_material/ticket_material.dart';
import 'package:ticket_widget/ticket_widget.dart';

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
                            return Card(
                                child: TicketMaterial(
                              radiusBorder: 5.0,
                              height: 100,
                              colorBackground:
                                  Color.fromARGB(255, 159, 206, 245),
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
                                      data1[index]['events']['department'],
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Text(
                                      data1[index]['events']['event_name'],
                                      style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      data1[index]['events']['event_date'],
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              rightChild: GestureDetector(
                                onTap: () {
                                  showBottomSheet(
                                      enableDrag: true,
                                      context: context,
                                      builder: (BuildContext context1) {
                                        return TicketWidget(
                                          width: 350,
                                          height: 500,
                                          isCornerRounded: true,
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20.0),
                                                child: Text(
                                                  data1[index]['events']
                                                      ['event_name'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ticketDetailsWidget(
                                                        'Department',
                                                        data1[index]['events']
                                                            ['department'],
                                                        'Date',
                                                        data1[index]['events']
                                                            ['event_date']),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0,
                                                              right: 52.0),
                                                      child:
                                                          ticketDetailsWidget(
                                                              'Ticket no',
                                                              data1[index]
                                                                  ['ticket_no'],
                                                              '',
                                                              ''),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 40.0,
                                                          right: 40.0),
                                                  child: QrImageView(
                                                      size: 182,
                                                      data: data1[index]
                                                          ['ticket_no'])),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Center(
                                  child: Icon(Icons.double_arrow),
                                ),
                              ),
                            ));
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

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Wrap(
    // alignment: WrapAlignment.start,
    direction: Axis.horizontal,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
