import 'package:cet_eventzone/components/adminprofile.dart';
import 'package:cet_eventzone/components/superuserview.dart';
import 'package:flutter/material.dart';
// import 'package:cet_eventzone/main.dart';
// import 'login.dart';
import 'eventpage.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen({super.key, required this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

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
      appBar: AppBar(
        title: const Text('EventZone'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
            icon: Icon(Icons.settings),
            label: 'Settings',
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
