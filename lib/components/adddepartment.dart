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
  bool showpassword = false;

  @override
  Widget build(BuildContext context) {
    const List<int> droplist = <int>[1, 2, 3, 4, 5];
    final List<DropdownMenuEntry<int>> dropdownmenuentries =
        <DropdownMenuEntry<int>>[];
    for (int i in droplist) {
      dropdownmenuentries
          .add(DropdownMenuEntry<int>(value: i, label: i.toString()));
    }

    return Column(
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
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off)),
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
            initialSelection: 1,
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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "email:${emailcontroller.text}\npassword:${passwordcontroller.text}\nname:${namecontroller.text}\ndepartment:${departmentcontroller.text}\nyear:$year\n")));
        },
        child: const Text("REGISTER"))
      ],
    );
  }
}
