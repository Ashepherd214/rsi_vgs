import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void readData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Aircrafts").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Ground Segment',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 103, 201)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('RSi Visual Ground Segment')),
        body: const SelectionTable(),
      ),
    );
  }
}

class SelectionTable extends StatelessWidget {
  const SelectionTable({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                //child: ListView.builder(itemBuilder: itemBuilder),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                color: Colors.blue,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 400,
                color: Colors.grey[300],
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: Text("Add Aircraft"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: Text("Add Runway")),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: Text("Delete Aircraft")),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: Text("Delete Runway")),
                  const SizedBox(height: 90),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: Text("Calculate VGS")),
                ]),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Current Input Values'),
          initiallyExpanded: false,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 200,
                    color: Colors.purple,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 200,
                    color: Colors.yellow,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 500,
                color: Colors.blue[200],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 500,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
