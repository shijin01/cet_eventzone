// import 'package:cet_eventzone/components/adddepartment.dart';
import 'package:cet_eventzone/components/adddepartment.dart';
import 'package:cet_eventzone/components/adminprofile.dart';
import 'package:cet_eventzone/components/superuserview.dart';
import 'package:flutter/material.dart';
// import 'package:cet_eventzone/main.dart';
// import 'login.dart';
import 'eventpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    EventWidget(),
    SuperuserView(),
    // Text("Testing"),
    AdminProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context)=>const AddDepartment()));
              })
          : null,
      appBar: AppBar(
        title: const Text('EventZone'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_sharp),
            label: 'Super Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Home'),
    //     ),
    //     body: SafeArea(
    //         child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const Text("hello"),
    //         const Text("welcome"),
    //         const Text("Home"),
    //         ElevatedButton(
    //             onPressed: () async {
    //               try {
    //                 await supabase.auth.signOut();
    //               } catch (err) {
    //                 SnackBar(content: Text("Error occured:$err"));
    //               } finally {
    //                 if (mounted) {
    //                   Navigator.of(context).pushReplacementNamed('/login');
    //                 }
    //               }
    //             },
    //             child: const Text("Logout")),
    //       ],
    //     )),
    //   );
    // }
  }
}
