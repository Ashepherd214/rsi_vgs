import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Ground Segment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 103, 201)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('RSi Visual Ground Segment')),
        body: const SelectionTable(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //find way to call refresh in SelectionTable
            },
            child: const Icon(Icons.refresh)),
      ),
    );
  }
}

class SelectionTable extends StatefulWidget {
  const SelectionTable({super.key});

  @override
  State<SelectionTable> createState() => _SelectionTableState();
}

class _SelectionTableState extends State<SelectionTable> {
  Future<List<Map<String, dynamic>>> readData() async {
    final db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection("Aircrafts").get();
    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  // State variables
  int? _selectedAircraftIndex; // to keep track of selection

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: readData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  final data = snapshot.data!;
                  return Expanded(
                    child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final isSelected = _selectedAircraftIndex == index;
                          return ListTile(
                            title: Text(data[index]['id']),
                            selected: isSelected,
                            selectedTileColor: Colors.blue[100],
                            onTap: () {
                              setState(() {
                                _selectedAircraftIndex =
                                    isSelected ? null : index;
                              });
                              print('Selected Aircraft ID: ${data[index]['id']}');
                              // Here you can implement what you want to do with the ID.
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 400,
                color: Colors.grey[300],
                child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text("Add Aircraft"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: const Text("Add Runway")),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: const Text("Delete Aircraft")),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: const Text("Delete Runway")),
                  const SizedBox(height: 90),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 100),
                      child: const Text("Calculate VGS")),
                ]),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Current Input Values'),
          initiallyExpanded: false,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    color: Colors.purple,
                    // New: Use a child widget to display the selected ID
                    child: Center(child: SelectedAircraftIdWidget(selectedAircraftIndex: _selectedAircraftIndex)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    color: Colors.yellow,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
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

class SelectedAircraftIdWidget extends StatelessWidget {
  final int? selectedAircraftIndex;

  const SelectedAircraftIdWidget({Key? key, this.selectedAircraftIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedAircraftIndex == null) {
      return const Text("No aircraft selected");
    }
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _SelectionTableState().readData(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final data = snapshot.data!;
          return Text(data[selectedAircraftIndex!]['id'].toString());
        } else {
          return const Text("Loading");
        }
      },
    );
  }
}
