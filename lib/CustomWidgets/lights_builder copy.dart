import 'package:flutter/material.dart';

//----------------Approach Light Types Start----------------//
/// ODALS (Needs checking)
/// MALSF (Done)
/// MALSR (Done) (Has running lights)
/// SSALF (Done)
/// SSALR (Done) (Has running lights)
/// ALSF-1 (Done)
/// ALSF-2 (Done)
/// RAIL (In Progress)
/// CALVERT (Needs Checking)
/// CLAVERT 2 (In Progress)
/// MALS
/// SALS
/// SSALS (Has running lights )
//----------------Approach Light Types End------------------//

class Light {
  final double x;
  final double y;
  final Color color;
  final double radius;

  Light(
      {required this.x,
      required this.y,
      this.color = Colors.white,
      this.radius = 1.0});
}

//------------------------Light Drawings------------------------------//
List<Light> generateODALS() {
  final items = <Light>[];
  // For two outside threshold lights located 40ft on either side
  items.add(Light(x: 550, y: 210 - 9.16));
  items.add(Light(x: 550, y: 210 + 9.16));

  //For all middle aligned lights
  for (int i = 0; i < 5; i++) {
    items.add(Light(
      x: 550 + 68.7 * (i + 1),
      y: 222,
    ));
  }
  return items;
}

List<Light> generateMALSF() {
  final items = <Light>[];
  //For all middle aligned lights
  for (int i = 0; i < 4; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 45.8 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
  }
  // For further spaced white light bars after row 5
  for (int i = 0; i < 2; i++) {
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 779 + 45.8 * (i + 1),
        y: 210 + 4.0 * t,
      ));
    }
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 871.6 + 45.8 * (i + 1),
        y: 222,
      ));
    }
  }
  return items;
}

List<Light> generateMALSFGreenLight() {
  final items = <Light>[];
  const forestGreen = Color(0xFF228B22);
  // For center forest green lights at row 5
  for (int t = 1; t <= 5; t++) {
    items.add(Light(
      x: 650,
      y: 210 + 4.0 * t,
      color: forestGreen,
    ));
  }
  // For extra forest green lights above center at row 5
  for (int t = 1; t <= 8; t++) {
    items.add(Light(
      x: 650,
      y: 140 + 4.0 * t,
      color: forestGreen,
    ));
  }
  //For extra forest green lights below center at row 5
  for (int t = 1; t <= 8; t++) {
    items.add(Light(
      x: 650,
      y: 268 + 4.0 * t,
      color: forestGreen,
    ));
  }
  return items;
}

List<Light> generateMALSR() {
  final items = <Light>[];
  //For all middle aligned lights
  for (int i = 0; i < 5; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 45.8 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
    // For further spaced white light bars after row 5
    for (int t = 1; t <= 1; t++) {
      items.add(Light(
        x: 779 + 45.8 * (i + 1),
        y: 222,
      ));
    }
  }
  // For extra white lights above center
  for (int t = 1; t <= 8; t++) {
    items.add(Light(
      x: 650,
      y: 140 + 4.0 * t,
    ));
  }
  //For extra white lights below center
  for (int t = 1; t <= 8; t++) {
    items.add(Light(
      x: 650,
      y: 268 + 4.0 * t,
    ));
  }
  return items;
}

List<Light> generateSSALF() {
  final items = <Light>[];
  for (int i = 0; i < 7; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 45.8 * (i + 1),
        y: 210 + 4.0 * j,
        color: Colors.blue,
      ));
    }
    if (i == 4) {
      // Draw the extra running light next to the bars
      // Specifically at the 5th bar draw the two decision light bars on either side of the center light bar
      items.add(Light(
        x: 781,
        y: 222,
        color: Colors.blue,
      ));
      // For extra white lights above center
      for (int t = 1; t <= 5; t++) {
        items.add(Light(
          x: 779,
          y: 183 + 4.0 * t,
          color: Colors.blue,
        ));
      }
      //For extra white lights below center
      for (int t = 1; t <= 5; t++) {
        items.add(Light(
          x: 779,
          y: 239 + 4.0 * t,
          color: Colors.blue,
        ));
      }
    }
    if (i > 4) {
      // Draw the extra running light next to the bars
      items.add(Light(
        x: 553 + 45.8 * (i + 1),
        y: 222,
        color: Colors.blue,
      ));
    }
  }
  return items;
}

List<Light> generateSSALR() {
  final items = <Light>[];
  for (int i = 0; i < 7; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 40.0 * (i + 1),
        y: 210 + 4.0 * j,
        color: Colors.red,
      ));
    }
    if (i == 4) {
      // For extra white lights above center
      for (int t = 1; t <= 5; t++) {
        items.add(Light(
          x: 779,
          y: 183 + 4.0 * t,
          color: Colors.red,
        ));
      }
      //For extra white lights below center
      for (int t = 1; t <= 5; t++) {
        items.add(Light(
          x: 779,
          y: 239 + 4.0 * t,
          color: Colors.red,
        ));
      }
    }
  }
  for (int i = 7; i < 12; i++) {
    for (int j = 3; j <= 5; j++) {
      items.add(Light(
        x: 550 + 40.0 * (i + 1),
        y: 222,
        color: Colors.red,
      ));
    }
  }
  return items;
}

List<Light> generateALSF1() {
  final items = <Light>[];
  // For main center white light bars up to 10 rows
  for (int i = 0; i < 10; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 570 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
  }
  // For main center white light bars past row 10
  for (int i = 0; i < 10; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 799 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
  }
  // For single bright directional LEDS in between after row 10 light bars
  for (int i = 0; i < 10; i++) {
    for (int j = 1; j <= 1; j++) {
      items.add(Light(
        x: 801 + 22.9 * (i + 1),
        y: 222,
      ));
    }
  }
  // The extra white lights at row 10
  for (int i = 1; i <= 8; i++) {
    items.add(Light(
      x: 650,
      y: 132 + 4.0 * i,
    ));
  }
  for (int i = 1; i <= 8; i++) {
    items.add(Light(
      x: 650,
      y: 280 + 4.0 * i,
    ));
  }
  return items;
}

List<Light> generateALSF1RedLights() {
  final items = <Light>[];
  for (int i = 0; i < 1; i++) {
    // Middle red led bar on second row
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
        color: Colors.red,
      ));
    }
    // For extra red lights above first row
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 550 + 11.45 * (i + 1),
        y: 140 + 4.0 * t,
        color: Colors.red,
      ));
    }
    //For extra red lights below first row
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 550 + 11.45 * (i + 1),
        y: 292 + 4.0 * t,
        color: Colors.red,
      ));
    }
  }
  for (int i = 0; i < 1; i++) {
    // For extra red lights above second row
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 550 + 45.8 * (i + 1),
        y: 160 + 4.0 * t,
        color: Colors.red,
      ));
    }
    //For extra red lights below second row
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 550 + 45.8 * (i + 1),
        y: 272 + 4.0 * t,
        color: Colors.red,
      ));
    }
  }
  return items;
}

List<Light> generateALSF2() {
  final items = <Light>[];
  // For main center white light bars up to 10 rows
  for (int i = 0; i < 10; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
    if (i == 4) {
      // The extra lights at row 5
      for (int t = 1; t <= 3; t++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 182 + 4.0 * t,
        ));
      }
      for (int l = 1; l <= 3; l++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 250 + 4.0 * l,
        ));
      }
    }

    if (i == 9) {
      // The extra white lights at row 10
      for (int t = 1; t <= 8; t++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 132 + 4.0 * t,
        ));
      }
      for (int l = 1; l <= 8; l++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 280 + 4.0 * l,
        ));
      }
    }
  }
  // For main center white light bars past row 10
  for (int i = 10; i < 20; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
    // For single bright directional LEDS in between after row 10 light bars
    for (int t = 1; t <= 1; t++) {
      items.add(Light(
        x: 553 + 22.9 * (i + 1),
        y: 222,
      ));
    }
  }
  return items;
}

List<Light> generateALSF2RedLights() {
  final items = <Light>[];
  for (int i = 0; i < 9; i++) {
    // For extra red lights above center
    for (int t = 1; t <= 3; t++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 140 + 4.0 * t,
        color: Colors.red,
      ));
    }
    //For extra red lights below center
    for (int t = 1; t <= 3; t++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 292 + 4.0 * t,
        color: Colors.red,
      ));
    }
  }
  return items;
}

List<Light> generateRAIL() {
  final items = <Light>[];
  for (int i = 0; i < 1; i++) {
    // Middle red led bar on second row
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
    // For extra red lights above first row
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 550 + 11.45 * (i + 1),
        y: 140 + 4.0 * t,
      ));
    }
    //For extra red lights below first row
    for (int t = 1; t <= 5; t++) {
      items.add(Light(
        x: 550 + 11.45 * (i + 1),
        y: 292 + 4.0 * t,
      ));
    }
  }
  return items;
}

List<Light> generateCALVERT() {
  final items = <Light>[];
  // For main center white lights up to 10 rows
  for (int i = 0; i < 10; i++) {
    items.add(Light(
      x: 550 + 22.54 * (i + 1),
      y: 222,
    ));
    // Add the additional Lights on either side of Row 5
    if (i == 4) {
      for (int l = 1; l <= 4; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * l,
        ));
      }
      for (int l = 1; l <= 4; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * l,
        ));
      }
    }
    // For Row 10
    if (i == 9) {
      for (int t = 1; t <= 5; t++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * t,
        ));
      }
      for (int t = 1; t <= 5; t++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * t,
        ));
      }
    }
  }
  // For main center white light bars between rows 10 to 20 i.e. 2 lights light bars
  for (int i = 10; i < 20; i++) {
    for (int j = 1; j <= 2; j++) {
      items.add(Light(
        x: 550 + 22.54 * (i + 1),
        y: 215.5 + 4.5 * j,
      ));
    }
    // For the additional lights on the sides of Row 15
    if (i == 14) {
      for (int l = 1; l <= 6; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * l,
        ));
      }
      for (int l = 1; l <= 6; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * l,
        ));
      }
    }
    // For Row 20
    if (i == 19) {
      for (int l = 1; l <= 7; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * l,
        ));
      }
      for (int l = 1; l <= 7; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * l,
        ));
      }
    }
  }
  // For center lights past row 20 i.e. 3 lights light-bar
  for (int i = 20; i < 30; i++) {
    for (int j = 1; j <= 3; j++) {
      items.add(Light(
        x: 550 + 22.54 * (i + 1),
        y: 214 + 4.5 * j,
      ));
    }
    // For the additional lights on the sides of Row 25
    if (i == 24) {
      for (int l = 1; l <= 8; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * l,
        ));
      }
      for (int l = 1; l <= 8; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * l,
        ));
      }
    }
  }
  return items;
}

List<Light> generateCALVERT2() {
  final items = <Light>[];
  // This section is for the front half of the lighting system that is the same as ALSF2
  // For main center white light bars up to 10 rows
  for (int i = 0; i < 10; i++) {
    for (int j = 1; j <= 5; j++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 210 + 4.0 * j,
      ));
    }
    if (i == 4) {
      // The extra lights at row 5
      for (int t = 1; t <= 3; t++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 182 + 4.0 * t,
        ));
      }
      for (int l = 1; l <= 3; l++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 250 + 4.0 * l,
        ));
      }
    }

    if (i == 9) {
      // The extra white lights at row 10
      for (int t = 1; t <= 8; t++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 132 + 4.0 * t,
        ));
      }
      for (int l = 1; l <= 8; l++) {
        items.add(Light(
          x: 550 + 22.9 * (i + 1),
          y: 280 + 4.0 * l,
        ));
      }
    }
  }

  //------- This section is for the second half of the approach lighting that is the same as CALVERT1

  for (int i = 10; i < 20; i++) {
    items.add(Light(
      x: 550 + 22.54 * (i + 1),
      y: 222,
    ));
    // Add the additional Lights on either side of Row 15
    if (i == 14) {
      for (int l = 1; l <= 6; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * l,
        ));
      }
      for (int l = 1; l <= 6; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * l,
        ));
      }
    }
    // For Row 20
    if (i == 19) {
      for (int t = 1; t <= 7; t++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * t,
        ));
      }
      for (int t = 1; t <= 7; t++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * t,
        ));
      }
    }
  }
  // For main center white light bars between rows 10 to 20 i.e. 2 lights light bars
  for (int i = 20; i < 25; i++) {
    for (int j = 1; j <= 2; j++) {
      items.add(Light(
        x: 550 + 22.54 * (i + 1),
        y: 215.5 + 4.5 * j,
      ));
    }
    // For the additional lights on the sides of Row 15
    if (i == 24) {
      for (int l = 1; l <= 8; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 212 - 4.0 * l,
        ));
      }
      for (int l = 1; l <= 8; l++) {
        items.add(Light(
          x: 550 + 22.54 * (i + 1),
          y: 232 + 4.0 * l,
        ));
      }
    }
  }

  return items;
}

List<Light> generateCALVERT2RedLights() {
  final items = <Light>[];
  for (int i = 0; i < 9; i++) {
    // For extra red lights above center
    for (int t = 1; t <= 3; t++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 140 + 4.0 * t,
        color: Colors.red,
      ));
    }
    //For extra red lights below center
    for (int t = 1; t <= 3; t++) {
      items.add(Light(
        x: 550 + 22.9 * (i + 1),
        y: 292 + 4.0 * t,
        color: Colors.red,
      ));
    }
  }
  return items;
}
//---------------------------End Section------------------------------//

//---------------------------Light Classes----------------------------//

class LightPainter extends CustomPainter {
  final List<Light> lights;

  LightPainter({required this.lights});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final light in lights) {
      paint.color = light.color;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawCircle(Offset(light.x, light.y), light.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LightPainter oldDelegate) =>
      oldDelegate.lights != lights;
}

class MALSR extends StatelessWidget {
  const MALSR({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightPainter(lights: generateMALSR()),
    );
  }
}

class MALSF extends StatelessWidget {
  const MALSF({super.key});
  @override
  Widget build(BuildContext context) {
    final allLights = [...generateMALSF(), ...generateMALSFGreenLight()];
    return CustomPaint(
      painter: LightPainter(lights: allLights),
    );
  }
}

class SSALR extends StatelessWidget {
  const SSALR({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightPainter(lights: generateSSALR()),
    );
  }
}

class SSALF extends StatelessWidget {
  const SSALF({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightPainter(lights: generateSSALF()),
    );
  }
}

class ALSF1 extends StatelessWidget {
  const ALSF1({super.key});
  @override
  Widget build(BuildContext context) {
    final allLights = [...generateALSF1(), ...generateALSF1RedLights()];
    return CustomPaint(
      painter: LightPainter(lights: allLights),
    );
  }
}

class ALSF2 extends StatelessWidget {
  const ALSF2({super.key});
  @override
  Widget build(BuildContext context) {
    final allLights = [...generateALSF2(), ...generateALSF2RedLights()];
    return CustomPaint(
      painter: LightPainter(lights: allLights),
    );
  }
}

class CALVERT extends StatelessWidget {
  const CALVERT({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightPainter(lights: generateCALVERT()),
    );
  }
}

class CALVERT2 extends StatelessWidget {
  const CALVERT2({super.key});
  @override
  Widget build(BuildContext context) {
    final allLights = [...generateCALVERT2(), ...generateCALVERT2RedLights()];
    return CustomPaint(
      painter: LightPainter(lights: allLights),
    );
  }
}

class RAIL extends StatelessWidget {
  const RAIL({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightPainter(lights: generateRAIL()),
    );
  }
}

class ODALS extends StatelessWidget {
  const ODALS({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightPainter(lights: generateODALS()),
    );
  }
}
