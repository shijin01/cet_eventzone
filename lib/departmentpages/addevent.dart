import 'package:cet_eventzone/clientsupa.dart';
import 'package:cet_eventzone/dbconnect.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final eventnamecontroller = TextEditingController();
  final eventdetailscontroller = TextEditingController();
  final eventdatecontroller = TextEditingController();
  final ticketdate = TextEditingController();
  final yearcontroller = TextEditingController();
  final ticketnumbercontroller = TextEditingController();
  final pricecontroller = TextEditingController();
  final upicontroller = TextEditingController();
  int? toggleval = 0;
  XFile? pickedFile;
  final ImagePicker _picker = ImagePicker();
  final supabase = getclient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: eventnamecontroller,
                decoration: const InputDecoration(
                    hintText: "Event",
                    prefixIcon: Icon(Icons.all_inclusive_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.assignment),
                    hintText: " Event description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                controller: eventdetailscontroller,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: eventdatecontroller,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      //  initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime
                          .now(), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    // String formattedDate =
                    //     "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      eventdatecontroller.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Date should be selected"),
                      // ignore: use_build_context_synchronously
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ));
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Date",
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                Container(
                  // padding: const EdgeInsets.all(3),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      onPressed: () async {
                        try {
                          final d = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          setState(() {
                            pickedFile = d;
                          });
                          print(pickedFile?.name);
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            backgroundColor:
                                // ignore: use_build_context_synchronously
                                Theme.of(context).colorScheme.error,
                          ));
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Select image")),
                ),
                if (pickedFile != null)
                  TextButton(
                    child: Text(pickedFile!.name),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context1) => AlertDialog(
                          title: const Text('Alert'),
                          content: const Text('RESET?'),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400]),
                              autofocus: true,
                              onPressed: () =>
                                  Navigator.pop(context1, 'Cancel'),
                              child: const Text(
                                'Cancel',
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                setState(() {
                                  pickedFile = null;
                                });
                                Navigator.pop(context1, 'OK');
                              },
                              child: const Text('OK',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Row(
                  children: [
                    const Text("Need ticket? ", style: TextStyle(fontSize: 20)),
                    ToggleSwitch(
                      minWidth: 50.0,
                      initialLabelIndex: toggleval,
                      cornerRadius: 20.0,
                      activeBgColors: const [
                        [Colors.blue],
                        [Colors.blue]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.grey[900],
                      totalSwitches: 2,
                      labels: ['No', 'Yes'],
                      // icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],

                      onToggle: (index) {
                        setState(() {
                          toggleval = index;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (toggleval == 1)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.price_change),
                          hintText: "Price",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: pricecontroller,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Number of Tickets",
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: ticketnumbercontroller,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: ticketdate,
                      onTap: () async {
                        if (eventdatecontroller.text != "") {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              //  initialDate: DateTime.now(), //get today's date
                              firstDate: DateTime
                                  .now(), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            DateTime d1 =
                                DateTime.parse(eventdatecontroller.text);
                            if (d1.compareTo(pickedDate) < 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text("Invalid date"),
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ));
                            } else {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                ticketdate.text =
                                    formattedDate; //set foratted date to TextField value.
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Date should be selected"),
                              // ignore: use_build_context_synchronously
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "Please select the event date first"),
                            // ignore: use_build_context_synchronously
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ));
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: "Ticket Date",
                          prefixIcon: Icon(Icons.date_range),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.perm_device_information),
                          hintText: "UPI ID",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: upicontroller,
                    ),
                  )
                ],
              ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int? lid = prefs.getInt("lid");
                  final data = await supabase
                      .from('userdetails')
                      .select()
                      .eq('lid', lid);
                  // print(data[0]['department']);
                  // if (lid != null) {
                  //   ScaffoldMessenger.of(context)
                  //       .showSnackBar(SnackBar(content: Text(lid.toString())));
                  // } else {
                  //   ScaffoldMessenger.of(context)
                  //       .showSnackBar(SnackBar(content: Text(lid.toString())));
                  // }

                  if (pickedFile != null) {
                    try {
                      final bytes = await pickedFile!.readAsBytes();
                      final fileExt = pickedFile!.path.split('.').last;
                      final fileName =
                          '${DateTime.now().toIso8601String()}.$fileExt';
                      final filePath = fileName;
                      await supabase.storage.from('eventphoto').uploadBinary(
                            filePath,
                            bytes,
                            fileOptions:
                                FileOptions(contentType: pickedFile!.mimeType),
                          );
                      final success = await addeventdetails(
                          eventnamecontroller.text,
                          eventdetailscontroller.text,
                          eventdatecontroller.text,
                          data[0]['department'],
                          fileName,
                          toggleval == 1,
                          ticketdate.text,
                          pricecontroller.text,
                          ticketnumbercontroller.text,
                          upicontroller.text);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Successfull"),
                          backgroundColor: Colors.green[200],
                        ));
                      }
                    } on StorageException catch (error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("StorageException :${error.message}"),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    } catch (error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Unexpected error occurred:$error'),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  } else {
                    try {
                      final success = await addeventdetails(
                          eventnamecontroller.text,
                          eventdetailscontroller.text,
                          eventdatecontroller.text,
                          data[0]['department'],
                          null,
                          toggleval == 1,
                          ticketdate.text,
                          pricecontroller.text,
                          ticketnumbercontroller.text,
                          upicontroller.text);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Successfull"),
                          backgroundColor: Colors.green[200],
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Unexpected error occurred'),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unexpected error occurred:$err'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }

                  // print(eventnamecontroller.text);
                  // print(eventdetailscontroller.text);
                  // print(eventdatecontroller.text);
                  // if (pickedFile != null) print(pickedFile!.name ?? " ");
                  // print(toggleval);
                  // if (toggleval == 1) {
                  //   print(ticketdate.text);
                  //   print(ticketnumbercontroller.text);
                  //   print(pricecontroller.text);
                  //   print(upicontroller.text);
                  //   // print(eventdatecontroller.text);
                  // }
                },
                child: const Text("REGISTER")),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
          ],
        ),
      )),
    );
  }
}
