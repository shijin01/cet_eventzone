import 'package:flutter/material.dart';
import 'package:cet_eventzone/main.dart';

class SuperuserView extends StatefulWidget {
  const SuperuserView({super.key});

  @override
  State<SuperuserView> createState() => _SuperuserViewState();
}

class _SuperuserViewState extends State<SuperuserView> {
  Future<List<Map<String, dynamic>>> getdata() async {
    final List<Map<String, dynamic>> data = await supabase.from('login').select('');
    return data;
    // await Future.delayed(Duration.zero);
  }

  

  @override
  Widget build(BuildContext context) {
    // final data = getdata();
    final data=getdata();
    print("\n------\nAfter datacall\------n");
    print(data);
    // getdata();
    return Column(
      children: [
        const Text("Helo"),
        SizedBox(
            height: 10,),
        Expanded(child:  FutureBuilder<List<Map<String, dynamic>>>(
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
            child: ListTile(
              title: Text(data1[index]['username']),
              subtitle: Text(data1[index]['typeofuser']),
            ),
          );
        },
      );
    }

    /// handles others as you did on question
    else {
      return const CircularProgressIndicator();
    }
  }))
      ],
    );
  }
}
