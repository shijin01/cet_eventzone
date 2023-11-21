import 'package:cet_eventzone/dbconnect.dart';
import 'package:flutter/material.dart';

class AddDepartment extends StatefulWidget {
  const AddDepartment({super.key});

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  final ScrollController controller = ScrollController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final departmentcontroller = TextEditingController();
  final yearcontroller = TextEditingController();
  int? year;

  // var dropvalue = droplist[0];
  bool showpassword = true;

  @override
  Widget build(BuildContext context) {
    const List<int> droplist = <int>[1, 2, 3, 4, 5];
    int selectedyear = 1;
    final List<DropdownMenuEntry<int>> dropdownmenuentries =
        <DropdownMenuEntry<int>>[];
    for (int i in droplist) {
      dropdownmenuentries
          .add(DropdownMenuEntry<int>(value: i, label: i.toString()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: showpassword,
                decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                        icon: showpassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                controller: passwordcontroller,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: namecontroller,
                decoration: const InputDecoration(
                    hintText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: departmentcontroller,
                decoration: const InputDecoration(
                    hintText: "Department",
                    prefixIcon: Icon(Icons.home_work_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text("Year:"),
                  ),
                  DropdownMenu<int>(
                    initialSelection: selectedyear,
                    dropdownMenuEntries: dropdownmenuentries,
                    controller: yearcontroller,
                    onSelected: (i) {
                      setState(() {
                        year = i;
                      });
                    },
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final usercreated = await createuser(
                      context, emailcontroller.text, passwordcontroller.text);
                  if (usercreated!.email == emailcontroller.text) {
                    final lid = await insertintologin(
                        emailcontroller.text, "department", usercreated.id);
                    final success = await insertintouserdetails(
                        lid,
                        namecontroller.text,
                        departmentcontroller.text,
                        year ?? 0);
                    if (success) {
                      // ignore: use_build_context_synchronously
                      emailcontroller.text = "";
                      passwordcontroller.text = "";
                      departmentcontroller.text = "";
                      namecontroller.text = "";
                      yearcontroller.text = "1";
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green[200],
                          content: const Text("Successfully added")));
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red[300],
                          content: const Text(
                              "User registered ,But there is something issue occured")));
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Error occured")));
                    //
                  }

                  //
                },
                child: const Text("REGISTER"))
          ],
        ),
      ),
    );
  }
}
