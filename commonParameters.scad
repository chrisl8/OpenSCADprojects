// All measurements in millimeters

// 1.25" PVC Pipe:
horizontalPipeInsideDiameter_1_25pvc = 42.9;
verticalPipeInsideDiameter_1_25pvc = 42.5;

// 0.5" PVC Pipe:
horizontalPipeInsideDiameter_0_50pvc = 22.1;
verticalPipeInsideDiameter_0_50pvc = 21.7;

// Parameters
jointLegLength = 50;
jointWallThickness = 3.5;
jointPinningHoleDiameter = 7;
jointPinHoleOffset = 10;

// Colors
JointColor = "CornflowerBlue";

// Resoution
// This is perfect for 3D Printing,
// but you may want to comment it out while working to improve preview
// performance
$fa = 1;
$fs = 0.4;
// Although this makes it VERY high rez, which might be better for the slicer? Experimenting with it instead.
// NOTE that using $fn causes FreeCAD and hence .step files exported to Fusion 360 to show round items as a series of faces instead of a single object.
//$fn = 500;
