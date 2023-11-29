import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  int? toggleval = 1;

  @override
  Widget build(BuildContext context) {
    late final XFile? pickedFile;

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: eventnamecontroller,
                  decoration: const InputDecoration(
                      hintText: "Event",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Event description",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
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
                      String formattedDate =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      setState(() {
                        eventdatecontroller.text =
                            formattedDate; //set foratted date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Date",
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      // XFile imagefile;
                      try {
                        pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ));
                      }
                    },
                    child: const Text("Select image")),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text("Need ticket? "),
                    ToggleSwitch(
                      minWidth: 90.0,
                      // initialLabelIndex: 1,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: const ['No', 'Yes'],
                      // icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                      activeBgColor: const [Colors.blue],
                      onToggle: (index) {
                        setState(() {
                          toggleval = index;
                        });
                      },
                    ),
                  ],
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
                            hintText: "Price",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                        controller: eventdetailscontroller,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "Number of Tickets",
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
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              //  initialDate: DateTime.now(), //get today's date
                              firstDate: DateTime
                                  .now(), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            setState(() {
                              ticketdate.text =
                                  formattedDate; //set foratted date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
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
                            hintText: "UPI ID",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                        controller: eventdetailscontroller,
                      ),
                    )
                  ],
                ),
              ElevatedButton(
                  onPressed: () async {
                    print(eventnamecontroller.text);
                    print(eventdetailscontroller.text);
                    print(eventdatecontroller.text);
                    print(pickedFile!.name ?? " ");
                    print(toggleval);
                    if (toggleval == 1) {
                      print(ticketdate.text);
                      print(ticketnumbercontroller.text);
                      print(pricecontroller.text);
                      print(upicontroller.text);
                      // print(eventdatecontroller.text);
                    }
                  },
                  child: const Text("REGISTER")),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
            ],
          ),
        ),
      )),
    );
  }
}
