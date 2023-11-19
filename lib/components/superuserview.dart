import 'package:flutter/material.dart';
// import 'package:cet_eventzone/main.dart';
import 'package:cet_eventzone/dbconnect.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class SuperuserView extends StatefulWidget {
  const SuperuserView({super.key});

  @override
  State<SuperuserView> createState() => _SuperuserViewState();
}

class _SuperuserViewState extends State<SuperuserView> {
  @override
  Widget build(BuildContext context) {
    // final data = getdata();
    final data = selectdepartmentusers();

    // getdata();
    return Column(
      children: [
        const Text("Helo"),
        const SizedBox(
          height: 10,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<Map<String, dynamic>> data1 =
                    snapshot.data as List<Map<String, dynamic>>;
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(data1[index]['username']),
                          subtitle: Text(data1[index]['typeofuser']),
                        ),
                      );
                    },
                  ),
                );
              }

              /// handles others as you did on question
              else {
                return const CircularProgressIndicator();
              }
            })
      ],
    );
  }
}
