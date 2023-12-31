import 'package:cet_eventzone/components/adduser.dart';
import 'package:flutter/material.dart';
// import 'package:cet_eventzone/main.dart';
import 'package:cet_eventzone/dbconnect.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class SuperuserView extends StatefulWidget {
  const SuperuserView({super.key});

  @override
  State<SuperuserView> createState() => _SuperuserViewState();
}

class _SuperuserViewState extends State<SuperuserView> {
  Future<List<Map<String, dynamic>>>? data;
  Future<void> getdata() async {
    // Future.delayed(Duration.zero)
    // ;
    setState(() {
      data = selectdepartmentusers();
    });
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddUser(typeofuser: "department")));
            }),
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
                                color: const Color.fromARGB(255, 218, 237, 242),
                                child: ListTile(
                                  title: Text(
                                    data1[index]['login']['username'],
                                    style: GoogleFonts.dhurjati(
                                        // fontStyle: GoogleFonts.dhurjati,
                                        fontSize: 20,
                                        // fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 165, 112, 208)),
                                  ),
                                  subtitle: Text(
                                    data1[index]['department'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 203, 112, 208)),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_rounded,
                                        color: Colors.red[500]),
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context1) =>
                                            AlertDialog(
                                          title: const Text('Alert'),
                                          content: const Text(
                                              'Do you want to delete?'),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green[400]),
                                              autofocus: true,
                                              onPressed: () => Navigator.pop(
                                                  context1, 'Cancel'),
                                              child: const Text(
                                                'Cancel',
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () {
                                                deletedepartmentusers(context,
                                                    data1[index]['id']);
                                                Navigator.pop(context1, 'OK');
                                              },
                                              child: const Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
        ))));
  }
}
