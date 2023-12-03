import 'package:cet_eventzone/components/adminprofile.dart';
import 'package:cet_eventzone/components/superuserview.dart';
import 'package:cet_eventzone/departmentpages/depteventpage.dart';
import 'package:cet_eventzone/departmentpages/participants.dart';
import 'package:cet_eventzone/userscomponent/ticketbook.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cet_eventzone/main.dart';
// import 'login.dart';
import 'eventpage.dart';

class HomeScreen extends StatefulWidget {
  final String usertype;
  final int selectedIndex;
  const HomeScreen(
      {super.key, required this.usertype, required this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late SharedPreferences pref;
  late List<Widget> _widgetOptions;
  late final bottomnavigator;
  @override
  void initState() {
    // TODO: implement initState
    setWidget();
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void setWidget() {
    print("Init");
    if (widget.usertype == 'admin') {
      _widgetOptions = const <Widget>[
        EventWidget(),
        SuperuserView(),
        AdminProfile(),
      ];

      bottomnavigator = const <BottomNavigationBarItem>[
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
      ];
    } else if (widget.usertype == 'user') {
      _widgetOptions = const <Widget>[
        EventWidget(),
        TicketBook(),
        AdminProfile(),
      ];

      bottomnavigator = const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.token),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    } else if (widget.usertype == 'department') {
      _widgetOptions = const <Widget>[
        DepartEvent(),
        ParticipantsView(),
        AdminProfile(),
      ];

      bottomnavigator = const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.token),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    }
  }

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
        items: bottomnavigator,
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
