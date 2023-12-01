import 'package:cet_eventzone/components/homescreen.dart';
import 'package:cet_eventzone/dbconnect.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_india/upi_india.dart';

// ignore: must_be_immutable
class UpiPageView extends StatefulWidget {
  String? upi, reciever, eventname;
  int? price, eid, lid;
  UpiPageView(
      {super.key,
      required this.upi,
      required this.reciever,
      required this.eventname,
      required this.price,
      required this.eid,
      required this.lid});

  @override
  State<UpiPageView> createState() => _UpiPageViewState();
}

class _UpiPageViewState extends State<UpiPageView> {
  String? typeouser;
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  getusertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      typeouser = prefs.getString("typeofuser");
    });
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: widget.upi!,
      receiverName: widget.reciever!,
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: "${widget.eventname} ticket",
      amount: widget.price!.toDouble(),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      // ignore: curly_braces_in_flow_control_structures
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () async {
                  _transaction = initiateTransaction(app);
                  final booked = await bookticket(widget.eid!, widget.lid!,
                      "${widget.eventname?.substring(0, 4)}${widget.eid}${DateTime.now().toIso8601String()}");
                  if (booked) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Successfull"),
                      backgroundColor: Colors.green[200],
                    ));
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Error"),
                      backgroundColor: Colors.red,
                    ));
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                              usertype: typeouser!, selectedIndex: 0)));
                  setState(() {});
                },
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      // ignore: type_literal_in_constant_pattern
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      // ignore: type_literal_in_constant_pattern
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      // ignore: type_literal_in_constant_pattern
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      // ignore: type_literal_in_constant_pattern
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        // print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        // print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        // print('Transaction Failed');
        break;
      default:
      // print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getusertype();
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text("Successfull"),
                    //   backgroundColor: Colors.green[200],
                    // ));

                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        style: header,
                      ), // Print's text message on screen
                    );
                  }

                  // If we have data then definitely we will have UpiResponse.
                  // It cannot be null
                  // ignore: no_leading_underscores_for_local_identifiers
                  UpiResponse _upiResponse = snapshot.data!;

                  // Data in UpiResponse can be null. Check before printing
                  String txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  _checkTxnStatus(status);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else
                  // ignore: curly_braces_in_flow_control_structures
                  return const Center(
                    child: Text(''),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}
