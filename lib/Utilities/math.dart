class MathVariables {
  // Aircraft Variables
  double aircraftXa = 0.0;
  double aircraftXe = 0.0;
  double aircraftZa = 0.0;
  double aircraftZe = 0.0;
  double aircraftCg = 0.0;
  int aircraftFlaps = 0;
  double aircraftLookdown = 0.0;
  double aircraftPitch = 0.0;
  double aircraftSpeed = 0.0;
  int aircraftWeight = 0;
  String aircraftType = "none";

  // Runway Variables
  String runwayLights = "none";
  int runwayDecisionHeight = 100;
  int runwayEdgeSpacing = 200;
  int runwayGSOffsetX = 0;
  int runwayGSOffsetY = 0;
  int runwayGlideSlope = 0;
  String runwayICAO = "none";
  int runwayThresholdCrossingHeight = 0;
  int runwayWidth = 0;

  // VGS Variables. Assume Glide Slope is 3, RVR for FAA is 1200ft and CAA is usually 1000ft
  double xAntEye = 0.0; //the horizontal distance between the antenna(at nose of aircraft) to eyepoint.
  // Equation to find value is xAntEye = (Xa-Xe)*cos(GS)+(Ze-Za)*sin(GS)
  
  double Zeg = 0.0; // The Z(elevation) of the eyepoint(e) above the ground(g)
  // Equation to find value is Zeg = DH + Ze * cos(GlideSlope) + Xe * sin(GlideSlope)
  
  double Zag = 0.0; // The Z(elevation) of the antenna(a) above the ground(g)
  // Equation to find value is Zag = DH + Za + cos(GS) + Xa * sin(GS)  

  double xAX = 0.0; // The horizontal ground distance of the aircraft antenna to the GS transmitter Antenna(Transmitter House)
  // Equation to find value of xAX assuming no Y offset (i.e. GSAntenna is in the center of Runway) is xAX = Zag/tan(GS) 

  double realXax = 0.0; // The horizontal ground distance of the aircraft antenna to the GS transmitter Antenna using Real offsets
  // Equation is Xax = sqrt((Zag/tan(GS))^2 - (yxmtr)^2)
  //                                              ^y-offset of GSAnt
  
  int slantRVR = 1200; // general expected RVR distance from the eyepoint(Usually equal or slightly less than real ground RVR)
  int gndRVR = 0; // RVR on the ground instead of from the eye in the air. Needed for proper gnd segment calculations
  // Equation is derived from (slantRVR)^2 = (Zeg)^2 + (RVR)^2
  // Final calculation is gndRVR = sqrt((slantRVR)^2-(Zeg)^2)
  
  int cutoffAngle = 0; // The angle corresponding to the obscured view relative to the ground.
  // Equation for value is cutoffAngle = lookdown - pitch angle

  double obseg = 0.0; // The obscured segment the pilots cannot see because of the obstruction of the nose 
  // Equation for value is obseg = Zeg/tan(cutoffAngle)

  int fov = 0; // The entire Ground Segment Field of View
  // Equation for value is gndRVR-obseg

  //Info on term relative to xAX feels like this was same value mislabeled in later proof pages
  //int aXa = 0; //Glide Slope Tx Antenna to Aircraft Antenna using a zero Y-offset
  int realaXa = 0; // Same as above but using real world antenna Y offset to side of runway.

  int xThres = 0; // horizontal ground distance of aircraft antenna to the runway threshold
  // Equation to determine value is xThres = xAx(With or without GSOffsetY) - GSOffsetX

  int xEyeThres = 0; //The horizontal ground distance of the pilot's eye point to the Threshold
  // Equation to find value is xEyeThres = xThres + xAntEye

  double xAhead = 0.0; // The distance from the obscured segment to the end of the runway
  // Equation to find value is xAhead = xEyeThres - obseg

  double xBeyond = 0.0; // The distance from the edge of the runway to the end of the ground segment
  // Equation to find value is FOV - xAhead

  double publishedTCH = 0.0; //Known calculated Threshold Crossing Height of antenna (Not real world value)
  // Value typically found on airport data chart as it is used for design 

  double realTCH = 0.0;
  // This value take into account the Glide Slope Antenna Y-Offset which makes the value less typically

  double vgsZ = 0.0;
  double vgsHeading = 0.0;
  double vgsDistance = 0.0;
  double vgsGlideSlope = 0.0;
  double vgsAzimuth = 0.0;

  // Rendering Variables
  double screenX = 0.0;
  double screenY = 0.0;
  double scale = 1.0;
}
