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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 103, 201)),
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
  // --- Data Fetching ---
  Future<List<Map<String, dynamic>>> readAircraftData() async {
    final db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection("Aircrafts").get();
    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> readRunwayData() async {
    final db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection("Runways").get();
    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  // --- State Variables ---
  int? _selectedAircraftIndex;
  int? _selectedRunwayIndex;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Aircraft Column ---
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: readAircraftData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No aircraft data available');
                  } else {
                    final aircraftData = snapshot.data!;
                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: aircraftData.length,
                        itemBuilder: (context, index) {
                          final isSelected = _selectedAircraftIndex == index;
                          return ListTile(
                            title: Text(aircraftData[index]['id']),
                            selected: isSelected,
                            selectedTileColor: Colors.blue[100],
                            onTap: () {
                              setState(() {
                                _selectedAircraftIndex =
                                    isSelected ? null : index;
                              });
                              print('Selected Aircraft ID: ${aircraftData[index]['id']}');
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            // --- Runway Column ---
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: readRunwayData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No runway data available');
                  } else {
                    final runwayData = snapshot.data!;
                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: runwayData.length,
                        itemBuilder: (context, index) {
                          final isSelected = _selectedRunwayIndex == index;
                          return ListTile(
                            title: Text(runwayData[index]['id']),
                            selected: isSelected,
                            selectedTileColor: Colors.blue[100],
                            onTap: () {
                              setState(() {
                                _selectedRunwayIndex =
                                    isSelected ? null : index;
                              });
                              print('Selected Runway ID: ${runwayData[index]['id']}');
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
// Row(
//   children: [
//     Expanded(
//       flex: 1,
//       child: Container(
//         color: Colors.grey[300],
//         padding: const EdgeInsets.all(16.0), // Added padding for spacing
//         child: 
        Row( // Changed Column to Row
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Added for spacing
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white),
              child: const Text("Add Aircraft"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 100),
              child: const Text("Delete Aircraft"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 100),
              child: const Text("Add Runway"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 100),
              child: const Text("Delete Runway"),
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
                    //color: Colors.purple,
                    child: Center(
                        child: SelectedAircraftIdWidget(
                            selectedAircraftIndex: _selectedAircraftIndex)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    //color: Colors.yellow,
                    child: Center(
                        child: SelectedRunwayIdWidget(
                            selectedRunwayIndex: _selectedRunwayIndex)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    //color: Colors.orange,
                        child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 100),
                                  child: const Text("Calculate VGS")),
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

  const SelectedAircraftIdWidget({Key? key, this.selectedAircraftIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedAircraftIndex == null) {
      return const Text("No aircraft selected");
    }
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _SelectionTableState().readAircraftData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Text(data[selectedAircraftIndex!]['id'].toString());
        } else {
          return const Text("Loading");
        }
      },
    );
  }
}

class SelectedRunwayIdWidget extends StatelessWidget {
  final int? selectedRunwayIndex;

  const SelectedRunwayIdWidget({Key? key, this.selectedRunwayIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedRunwayIndex == null) {
      return const Text("No runway selected");
    }
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _SelectionTableState().readRunwayData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Text(data[selectedRunwayIndex!]['id'].toString());
        } else {
          return const Text("Loading");
        }
      },
    );
  }
}
