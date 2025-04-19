import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'Utilities/math.dart'; // Import the math.dart file

// --- Global Variables ---
// Create a global instance of MathVariables
MathVariables globalMath = MathVariables();

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
                              // Update global aircraft variables when selected
                              if (_selectedAircraftIndex != null) {
                                globalMath.aircraftXa = aircraftData[_selectedAircraftIndex!]['Xa'] ?? 0.0;
                                globalMath.aircraftXe = aircraftData[_selectedAircraftIndex!]['Xe'] ?? 0.0; 
                                globalMath.aircraftZa = aircraftData[_selectedAircraftIndex!]['Za'] ?? 0.0; 
                                globalMath.aircraftZe = aircraftData[_selectedAircraftIndex!]['Ze'] ?? 0.0;
                                globalMath.aircraftType = aircraftData[_selectedAircraftIndex!]['airType'] ?? "none";
                                globalMath.aircraftCg = aircraftData[_selectedAircraftIndex!]['cg'] ?? 0.0;
                                globalMath.aircraftFlaps = aircraftData[_selectedAircraftIndex!]['flaps'] ?? 0; 
                                globalMath.aircraftLookdown = aircraftData[_selectedAircraftIndex!]['lookdown'] ?? 0.0;
                                globalMath.aircraftPitch = aircraftData[_selectedAircraftIndex!]['pitch'] ?? 0.0;
                                globalMath.aircraftSpeed = aircraftData[_selectedAircraftIndex!]['speed'] ?? 0.0;
                                globalMath.aircraftWeight = aircraftData[_selectedAircraftIndex!]['weight'] ?? 0.0;
                              }
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
                              // Update global runway variables when selected
                              if (_selectedRunwayIndex != null) {
                                globalMath.runwayDecisionHeight = runwayData[_selectedRunwayIndex!]['DH'] ?? 0.0; 
                                globalMath.runwayEdgeSpacing = runwayData[_selectedRunwayIndex!]['EdgeSpacing'] ?? 0.0; 
                                globalMath.runwayGSOffsetX = runwayData[_selectedRunwayIndex!]['GSOffsetX'] ?? 0.0; 
                                globalMath.runwayGSOffsetY= runwayData[_selectedRunwayIndex!]['GSOffsetY'] ?? 0.0;
                                globalMath.runwayGlideSlope = runwayData[_selectedRunwayIndex!]['GlideSlope'] ?? 0.0;
                                globalMath.runwayICAO = runwayData[_selectedRunwayIndex!]['ICAO'] ?? "none";
                                globalMath.runwayThresholdCrossingHeight = runwayData[_selectedRunwayIndex!]['TCH'] ?? 0.0; 
                                globalMath.runwayWidth = runwayData[_selectedRunwayIndex!]['Width'] ?? 0.0;
                                globalMath.runwayLights = runwayData[_selectedRunwayIndex!]['ApproachLights'] ?? "none";
                              }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  child: SizedBox(
                    height: 50,
                    child: Center(
                        child: SelectedAircraftIdWidget(
                            selectedAircraftIndex: _selectedAircraftIndex)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: Center(
                        child: SelectedRunwayIdWidget(
                            selectedRunwayIndex: _selectedRunwayIndex)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                        child: ElevatedButton(
                        onPressed: () {
                          // Print Aircraft Values
                          print("Aircraft Xa: ${globalMath.aircraftXa}");
                          print("Aircraft Xe: ${globalMath.aircraftXe}");
                          print("Aircraft Za: ${globalMath.aircraftZa}");
                          print("Aircraft Ze: ${globalMath.aircraftZe}");
                          print("Aircraft Cg: ${globalMath.aircraftCg}");
                          print("Aircraft Flaps: ${globalMath.aircraftFlaps}");
                          print("Aircraft Lookdown: ${globalMath.aircraftLookdown}");
                          print("Aircraft Pitch: ${globalMath.aircraftPitch}");
                          print("Aircraft Speed: ${globalMath.aircraftSpeed}");
                          print("Aircraft Weight: ${globalMath.aircraftWeight}");
                          print("Aircraft Type: ${globalMath.aircraftType}");

                          // Print Runway Values
                          print("Runway Approach Lights: ${globalMath.runwayLights}");
                          print("Runway Decision Height: ${globalMath.runwayDecisionHeight}");
                          print("Runway Edge Light Spacing: ${globalMath.runwayEdgeSpacing}");
                          print("Runway GS building X offset: ${globalMath.runwayGSOffsetX}");
                          print("Runway GS building Y offset: ${globalMath.runwayGSOffsetY}");
                          print("Runway Glide Slope Angle: ${globalMath.runwayGlideSlope}");
                          print("Runway ICAO: ${globalMath.runwayICAO}");
                          print("Runway Threshold Crossing Height(TCH): ${globalMath.runwayThresholdCrossingHeight}");
                          print("Runway Width: ${globalMath.runwayWidth}");       

                          // Calculate VGS variables
                            // VGS Variables. Assume Glide Slope is 3, RVR for FAA is 1200ft and CAA is usually 1000ft
                          globalMath.xAntEye = (globalMath.aircraftXa - globalMath.aircraftXe)*cos(globalMath.runwayGlideSlope) + (globalMath.aircraftZe - globalMath.aircraftZa)*sin(globalMath.runwayGlideSlope);
                          globalMath.Zeg = globalMath.runwayDecisionHeight + globalMath.aircraftZe * cos(globalMath.runwayGlideSlope) + globalMath.aircraftXe * sin(globalMath.runwayGlideSlope);
                          globalMath.Zag = globalMath.runwayDecisionHeight + globalMath.aircraftZa + cos(globalMath.runwayGlideSlope) + globalMath.aircraftXa * sin(globalMath.runwayGlideSlope);
                          globalMath.xAX = globalMath.Zag/tan(globalMath.runwayGlideSlope);
                          globalMath.realXax = sqrt((globalMath.Zag/tan(pow(globalMath.runwayGlideSlope, 2)) - pow(globalMath.runwayGSOffsetY, 2)));
                          globalMath.gndRVR = sqrt(pow(globalMath.slantRVR, 2) - pow(globalMath.Zeg,2));
                          globalMath.cutoffAngle = globalMath.aircraftLookdown - globalMath.aircraftPitch;
                          globalMath.obseg = globalMath.Zeg/tan(globalMath.cutoffAngle);
                          globalMath.fov = globalMath.gndRVR - globalMath.obseg;
                          globalMath.xThres = globalMath.realXax - globalMath.runwayGSOffsetX;
                          globalMath.xEyeThres = globalMath.xThres + globalMath.xAntEye;
                          globalMath.xAhead = globalMath.xEyeThres - globalMath.obseg;
                          globalMath.xBeyond = globalMath.fov - globalMath.xAhead;
                          globalMath.publishedTCH = globalMath.runwayThresholdCrossingHeight;
                          globalMath.realTCH = globalMath.publishedTCH + globalMath.runwayGSOffsetY;
                          

                          

                          
                          // Print the VGS calculations for verification of math
                          print("Antenna to Eye distance: ${globalMath.xAntEye}");
                          print("Elevation of eyepoint above ground: ${globalMath.Zeg}");
                          print("Elevation of antenna above ground: ${globalMath.Zag}");
                          print("Distance antenna to GS transmitter antenna: ${globalMath.xAX}");
                          print("Real distance antenna to GS transmitter antenna: ${globalMath.realXax}");
                          print("Ground RVR: ${globalMath.gndRVR}");
                          print("Cutoff Angle: ${globalMath.cutoffAngle}");
                          print("Obstructed Segment: ${globalMath.obseg}");
                          print("Field of View: ${globalMath.fov}");
                          print("Known Threshold Crossing Height: ${globalMath.publishedTCH}");
                          print("Real Threshold Crossing Height: ${globalMath.realTCH}");
                          print("Distance of eyepoint to runway threshold: ${globalMath.xEyeThres}");
                          print("Distance from obscured segment to end of Runway: ${globalMath.xAhead}");
                          print("Distance from edge of runway to end of ground segment: ${globalMath.xBeyond}");
                        },
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
                child: Center(
                  child: _selectedAircraftIndex != null
                      ? FutureBuilder<List<Map<String, dynamic>>>(
                          future: readAircraftData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No aircraft data available');
                            } else {
                              final aircraftData = snapshot.data!;
                              return Text(
                                  "Aircraft: ${aircraftData[_selectedAircraftIndex!]['id']}");
                            }
                          },
                        )
                      : const Text("Aircraft: None"),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 500,
                color: Colors.red,
                child: Center(
                  child: _selectedRunwayIndex != null
                      ? FutureBuilder<List<Map<String, dynamic>>>(
                          future: readRunwayData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No runway data available');
                            } else {
                              final runwayData = snapshot.data!;
                              return Text(
                                  "Runway: ${runwayData[_selectedRunwayIndex!]['id']}");
                            }
                          },
                        )
                      : const Text("Runway: None"),
                ),
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

  const SelectedAircraftIdWidget({super.key, this.selectedAircraftIndex});

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

  const SelectedRunwayIdWidget({super.key, this.selectedRunwayIndex});

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
