import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'Utilities/math.dart'; // Import the math.dart file;
import 'CustomWidgets/lights_builder.dart';

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

class _SelectionTableState extends State<SelectionTable> {
  // --- State Variables ---
  int? _selectedAircraftIndex;
  int? _selectedRunwayIndex;

  List<Light> _getLightsForSystem(String lightSystem) {
    switch (lightSystem) {
      case 'MALSR':
        return generateMALSR();
      case 'MALSF':
        return [...generateMALSF(), ...generateMALSFGreenLight()];
      case 'SSALR':
        return generateSSALR();
      case 'SSALF':
        return generateSSALF();
      case 'ALSF1':
        return [...generateALSF1(), ...generateALSF1RedLights()];
      case 'ALSF2':
        return [...generateALSF2(), ...generateALSF2RedLights()];
      case 'CALVERT':
        return generateCALVERT();
      case 'CALVERT2':
        return [...generateCALVERT2(), ...generateCALVERT2RedLights()];
      case 'ODALS':
        return generateODALS();
      case 'RAIL':
        return generateRAIL();
      default:
        return []; // Return an empty list if no match
    }
  }

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
                              print(
                                  'Selected Aircraft ID: ${aircraftData[index]['id']}');
                              // Update global aircraft variables when selected
                              if (_selectedAircraftIndex != null) {
                                globalMath.aircraftXa = (aircraftData[_selectedAircraftIndex!]['Xa'] ?? 0.0).toDouble();
                                globalMath.aircraftXe = (aircraftData[_selectedAircraftIndex!]['Xe'] ?? 0.0).toDouble(); 
                                globalMath.aircraftZa = (aircraftData[_selectedAircraftIndex!]['Za'] ?? 0.0).toDouble(); 
                                globalMath.aircraftZe = (aircraftData[_selectedAircraftIndex!]['Ze'] ?? 0.0).toDouble();
                                globalMath.aircraftType = aircraftData[_selectedAircraftIndex!]['airType'] ?? "none";
                                globalMath.aircraftCg = (aircraftData[_selectedAircraftIndex!]['cg'] ?? 0.0).toDouble();
                                globalMath.aircraftFlaps = (aircraftData[_selectedAircraftIndex!]['flaps'] ?? 0.0).toDouble(); 
                                globalMath.aircraftLookdown = (aircraftData[_selectedAircraftIndex!]['lookdown'] ?? 0.0).toDouble();
                                globalMath.aircraftPitch = (aircraftData[_selectedAircraftIndex!]['pitch'] ?? 0.0).toDouble();
                                globalMath.aircraftSpeed = (aircraftData[_selectedAircraftIndex!]['speed'] ?? 0.0).toDouble();
                                globalMath.aircraftWeight = (aircraftData[_selectedAircraftIndex!]['weight'] ?? 0.0).toDouble();
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
                              print(
                                  'Selected Runway ID: ${runwayData[index]['id']}');
                              // Update global runway variables when selected
                              if (_selectedRunwayIndex != null) {
                                globalMath.runwayDecisionHeight = (runwayData[_selectedRunwayIndex!]['DH'] ?? 0.0).toDouble(); 
                                globalMath.runwayEdgeSpacing = (runwayData[_selectedRunwayIndex!]['EdgeSpacing'] ?? 0.0).toDouble(); 
                                globalMath.runwayGSOffsetX = (runwayData[_selectedRunwayIndex!]['GSOffsetX'] ?? 0.0).toDouble(); 
                                globalMath.runwayGSOffsetY= (runwayData[_selectedRunwayIndex!]['GSOffsetY'] ?? 0.0).toDouble();
                                globalMath.runwayGlideSlope = (runwayData[_selectedRunwayIndex!]['GlideSlope'] ?? 0.0).toDouble();
                                globalMath.runwayICAO = runwayData[_selectedRunwayIndex!]['ICAO'] ?? "none";
                                globalMath.runwayThresholdCrossingHeight = (runwayData[_selectedRunwayIndex!]['TCH'] ?? 0.0).toDouble(); 
                                globalMath.runwayWidth = (runwayData[_selectedRunwayIndex!]['Width'] ?? 0.0).toDouble();
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
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
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
                          // BUG FIX: Initialize slantRVR to prevent NaN calculations.
                          // This value was not being set, causing gndRVR, fov, xAhead, and xBeyond to be NaN.
                          // Using a default value of 1200.0 based on comments in the code.
                          globalMath.slantRVR = 1200.0;

                          

                          // Print Aircraft Values
                          print("Aircraft Xa: ${globalMath.aircraftXa}");
                          print("Aircraft Xe: ${globalMath.aircraftXe}");
                          print("Aircraft Za: ${globalMath.aircraftZa}");
                          print("Aircraft Ze: ${globalMath.aircraftZe}");
                          print("Aircraft Cg: ${globalMath.aircraftCg}");
                          print("Aircraft Flaps: ${globalMath.aircraftFlaps}");
                          print(
                              "Aircraft Lookdown: ${globalMath.aircraftLookdown}");
                          print("Aircraft Pitch: ${globalMath.aircraftPitch}");
                          print("Aircraft Speed: ${globalMath.aircraftSpeed}");
                          print(
                              "Aircraft Weight: ${globalMath.aircraftWeight}");
                          print("Aircraft Type: ${globalMath.aircraftType}");

                          // Print Runway Values
                          print(
                              "Runway Approach Lights: ${globalMath.runwayLights}");
                          print(
                              "Runway Decision Height: ${globalMath.runwayDecisionHeight}");
                          print(
                              "Runway Edge Light Spacing: ${globalMath.runwayEdgeSpacing}");
                          print(
                              "Runway GS building X offset: ${globalMath.runwayGSOffsetX}");
                          print(
                              "Runway GS building Y offset: ${globalMath.runwayGSOffsetY}");
                          print(
                              "Runway Glide Slope Angle: ${globalMath.runwayGlideSlope}");
                          print("Runway ICAO: ${globalMath.runwayICAO}");
                          print("Runway Threshold Crossing Height(TCH): ${globalMath.runwayThresholdCrossingHeight}");
                          print("Runway Width: ${globalMath.runwayWidth}");       

                          // Calculate VGS variables
                            // VGS Variables. Assume Glide Slope is 3, RVR for FAA is 1200ft and CAA is usually 1000ft
                          //globalMath.xAntEye = ((globalMath.aircraftXa - globalMath.aircraftXe)*cos(globalMath.aircraftPitch*globalMath.radToDeg)) + ((globalMath.aircraftZe - globalMath.aircraftZa)*sin(globalMath.aircraftPitch*globalMath.radToDeg));
                          //globalMath.Zeg = globalMath.runwayDecisionHeight + globalMath.aircraftZe * cos(globalMath.aircraftPitch*globalMath.radToDeg) + globalMath.aircraftXe * sin(globalMath.aircraftPitch*globalMath.radToDeg);
                          //globalMath.Zag = globalMath.runwayDecisionHeight + globalMath.aircraftZa + cos(globalMath.aircraftPitch*globalMath.radToDeg) + globalMath.aircraftXa * sin(globalMath.aircraftPitch*globalMath.radToDeg);
                          //globalMath.xAX0 = globalMath.Zag/tan(globalMath.runwayGlideSlope*globalMath.radToDeg);
                          //globalMath.realXax = sqrt(pow(globalMath.Zag/tan((globalMath.runwayGlideSlope*globalMath.radToDeg)), 2) - pow(globalMath.runwayGSOffsetY, 2));
                          //globalMath.gndRVR = sqrt(pow(globalMath.slantRVR, 2) - pow(globalMath.Zeg,2));
                          //globalMath.cutoffAngle = globalMath.aircraftLookdown - globalMath.aircraftPitch;
                          //globalMath.obseg = globalMath.Zeg/tan(globalMath.cutoffAngle*globalMath.radToDeg);
                          //globalMath.fov = globalMath.gndRVR - globalMath.obseg;
                          //globalMath.xThres0 = globalMath.xAX0 - globalMath.runwayGSOffsetX;
                          //globalMath.xThresReal = globalMath.realXax - globalMath.runwayGSOffsetX;
                          //globalMath.xEyeThres0 = globalMath.xThres0 + globalMath.xAntEye;
                          //globalMath.xEyeThresReal = globalMath.xThresReal + globalMath.xAntEye;
                          //globalMath.xAhead = globalMath.xEyeThresReal - globalMath.obseg;
                          //globalMath.xAhead0 = globalMath.xEyeThres0 - globalMath.obseg;
                          //globalMath.xBeyond = globalMath.fov - globalMath.xAhead;
                          //globalMath.xBeyond0 = globalMath.fov - globalMath.xAhead0;
                          globalMath.publishedTCH = globalMath.runwayThresholdCrossingHeight;
                          globalMath.realTCH = globalMath.publishedTCH + globalMath.runwayGSOffsetY;
                          globalMath.gsxOffsetTCH = globalMath.publishedTCH/tan(globalMath.runwayGlideSlope*globalMath.radToDeg);

                          globalMath.xeyethres0TCH = globalMath.xAX0 - globalMath.gsxOffsetTCH + globalMath.xAntEye;

                          /**
                           * //calculate ahead and beyond segment values assuming GS TX is on runway CL using published TCH
		let xahead0TCH = xeyethres0TCH - obseg;
		let xbeyond0TCH = fov - xahead0TCH;

		//calculate antenna to threshold distance accounting for lateral offset using published TCH
		let xeyethresrealTCH = xaxreal - gsxOffsetTCH + xanteye;

		//calculate ahead and beyond segment values assuming GS TX lateral offset using the published TCH
		let xaheadrealTCH = xeyethresrealTCH - obseg;
		let xbeyondrealTCH = fov - xaheadrealTCH;
                           */
                          

                          /**
                           * let xthres0 = xax0 - this.state.gsx;
		                          let xthresreal = xaxreal - this.state.gsx;
		                          let xeyethres0 = xthres0 + xanteye;
		                          let xeyethresreal = xthresreal + xanteye;
		                          let xahead0 = xthres0 - obseg;
		                          let xbeyond0 = fov - Math.abs(xahead0);
		                          let xaheadreal = xthresreal - obseg;
		                          let xbeyondreal = fov - Math.abs(xaheadreal);
                           */
                          

                          

                          
                          // Print the VGS calculations for verification of math
                          print(
                              "Antenna to Eye distance: ${globalMath.xAntEye}");
                          print(
                              "Elevation of eyepoint above ground: ${globalMath.Zeg}");
                          print(
                              "Elevation of antenna above ground: ${globalMath.Zag}");
                          print(
                              "Distance antenna to GS transmitter antenna: ${globalMath.xAX0}");
                          print(
                              "Real distance antenna to GS transmitter antenna: ${globalMath.realXax}");
                          print("Ground RVR: ${globalMath.gndRVR}");
                          print("Cutoff Angle: ${globalMath.cutoffAngle}");
                          print("Obstructed Segment: ${globalMath.obseg}");
                          print("Field of View: ${globalMath.fov}");
                          print(
                              "Known Threshold Crossing Height: ${globalMath.publishedTCH}");
                          print(
                              "Real Threshold Crossing Height: ${globalMath.realTCH}");
                          print(
                              "Distance of eyepoint to runway threshold: ${globalMath.xEyeThres}");
                          print(
                              "Distance from obscured segment to end of Runway: ${globalMath.xAhead}");
                          print(
                              "Distance from edge of runway to end of ground segment: ${globalMath.xBeyond}");
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
              flex: 4,
              child: Container(
                height: 500,
                color: const Color.fromARGB(255, 1, 110, 5), // Changed from Colors.red for better contrast
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: RunwayPainter(
                        xAhead: globalMath.xAhead,
                        xBeyond: globalMath.xBeyond,
                        fov: globalMath.fov,
                        lights: _getLightsForSystem(globalMath.runwayLights),
                      ),
                    ),
                    Center(
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
                                  return Opacity(
                                    opacity: 0.2,
                                    child: Text(
                                        "Runway: ${runwayData[_selectedRunwayIndex!]['id']}"),
                                  );
                                }
                              },
                            )
                          : const Opacity(
                              opacity: 0.2,
                              child: Text("Runway: None (Not selected)"),
                            ),
                    ),
                  ],
                ),
              ),
            ),
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
          ],
        )
      ],
    );
  }
}

class RunwayPainter extends CustomPainter {
  final double xAhead;
  final double xBeyond;
  final double fov;
  final List<Light> lights;

  RunwayPainter({
    required this.xAhead,
    required this.xBeyond,
    required this.fov,
    required this.lights,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final runwayPaint = Paint()..color = Colors.grey[800]!;
    final runwayCenterLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final xAheadPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;
    final xBeyondPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    // Draw the runway horizontally on the left half
    final runwayWidth = size.width / 2;
    final runwayHeight = size.height * 0.2;
    final runwayTop = (size.height - runwayHeight) / 2;
    final runwayRect =
        Rect.fromLTWH(0, runwayTop, runwayWidth, runwayHeight);
    canvas.drawRect(runwayRect, runwayPaint);

    // Draw runway centerline horizontally (only over the runway)
    const dashWidth = 10.0;
    const dashSpace = 5.0;
    double startX = 0;
    final centerY = size.height / 2;
    while (startX < runwayWidth) {
      if (startX + dashWidth <= runwayWidth) {
        canvas.drawLine(
          Offset(startX, centerY),
          Offset(startX + dashWidth, centerY),
          runwayCenterLinePaint,
        );
      }
      startX += dashWidth + dashSpace;
    }

    // --- Draw Approach Lights to the right of the runway ---
    if (lights.isNotEmpty) {
      double minX = lights.first.x;
      double maxX = lights.first.x;

      for (final light in lights) {
        if (light.x < minX) minX = light.x;
        if (light.x > maxX) maxX = light.x;
      }

      double padding = 20.0;
      double availableWidth = (size.width / 2) - padding;
      double lightSystemWidth = maxX - minX;
      if (lightSystemWidth == 0) lightSystemWidth = 1.0;

      // Scale to fit available width
      double scale = availableWidth / lightSystemWidth;
      
      // Centerline in the original light coordinates is 222.0
      const double lightCenterY = 222.0;

      final lightPaint = Paint()..style = PaintingStyle.fill;
      for (final light in lights) {
        lightPaint.color = light.color;
        lightPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
        
        double mappedX = runwayWidth + (light.x - minX) * scale;
        double mappedY = centerY + (light.y - lightCenterY) * scale;
        double mappedRadius = light.radius * scale;
        
        if (mappedRadius < 1.5) mappedRadius = 1.5;

        canvas.drawCircle(Offset(mappedX, mappedY), mappedRadius, lightPaint);
      }
    }

    // Only draw lines if fov is a valid, positive number
    if (fov.isNaN || fov <= 0) return;

    // Scale factor to map feet to pixels.
    // We use the total width and fov to maintain consistent scaling.
    double scale = size.width / fov;

    // Draw xAhead line (vertical)
    // Positioned relative to the runway threshold (runwayWidth).
    // A positive xAhead moves it to the left of the runway edge.
    final xAheadPos = runwayWidth - (xAhead * scale);
    if (xAheadPos.isFinite) {
       canvas.drawLine(
        Offset(xAheadPos, 0),
        Offset(xAheadPos, size.height),
        xAheadPaint,
      );
      TextPainter(
        text: const TextSpan(text: 'xAhead', style: TextStyle(color: Colors.black, backgroundColor: Colors.amber)),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, Offset(xAheadPos + 5, 5));
    }


    // Draw xBeyond line (vertical)
    // Positioned relative to the runway threshold (runwayWidth).
    // A negative xBeyond moves it to the right of the runway edge.
    final xBeyondPos = runwayWidth - (xBeyond * scale);
    if (xBeyondPos.isFinite) {
        canvas.drawLine(
        Offset(xBeyondPos, 0),
        Offset(xBeyondPos, size.height),
        xBeyondPaint,
      );
       TextPainter(
        text: const TextSpan(text: 'xBeyond', style: TextStyle(color: Colors.blue, backgroundColor: Colors.black)),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, Offset(xBeyondPos + 5, 25));
    }
  }

  @override
  bool shouldRepaint(covariant RunwayPainter oldDelegate) {
    return oldDelegate.xAhead != xAhead || 
           oldDelegate.xBeyond != xBeyond || 
           oldDelegate.fov != fov ||
           oldDelegate.lights != lights;
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
      future: readAircraftData(),
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
      future: readRunwayData(),
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
