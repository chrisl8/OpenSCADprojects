// All measurements in millimeters

// "horizontal" and "vertical" refer to how they are printed on the print bed,
// not how they work on the final assembly.
// ALWAYS print verticle pipes straight up if possible, that is 90 degrees from the bed.
// Attempting to print a slanted pipe will be troublesome and require testing for a proper size.
// However, you can print ANY angle ON the bed.

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

// Walker Foot Parameters
inchesToMmConversionFactor = 25.4;

// Current idea is 11 x 21 inches.
walkerFootHeight = 11 * inchesToMmConversionFactor;
walkerFootLength = 21 * inchesToMmConversionFactor;
// Back of Foot is 4 inches longer to cause foot to hang AND LOOK as desired
// I tried 1 inch and it had basically NO affect on how it hangs.
// I think it looks cool at 4 inches, so I am going to test that.
// I *THINK* that it actually doesn't affect lenght of the walker, because the front
// of one compensates for the back of the other.
walkerFootCenterOffset = 4 * inchesToMmConversionFactor; // Remember to multiply any offset by the conversion factor.
walkerFootFrontLength = (walkerFootLength / 2) - (walkerFootCenterOffset / 2);
walkerFootBackLength = (walkerFootLength / 2) + (walkerFootCenterOffset / 2);

footLowerJointLegLength = 75;

// Angles
// This site is great for visualizing what you want: https://www.blocklayer.com/trig/scaleneeng.aspx
// Use this site to check your math and results: https://www.calculator.net/right-triangle-calculator.html
echo("=======================================================");
echo("Walker Foot Parameters");
echo("walkerFootLength", walkerFootLength, walkerFootFrontLength + walkerFootBackLength);
echo("=======================================================");
echo("Front:");
echo("walkerFootHeight (a)", walkerFootHeight);
echo("walkerFootFrontLength (b)", walkerFootFrontLength);
walkerFootFrontTriangleTopLength = sqrt(pow(walkerFootHeight, 2) + pow(walkerFootFrontLength, 2));
echo("walkerFootFrontTriangleTopLength (c)", walkerFootFrontTriangleTopLength);
walkerFootFrontJointAngle = asin(walkerFootHeight / walkerFootFrontTriangleTopLength);
echo("walkerFootFrontJointAngle (α):", walkerFootFrontJointAngle);
walkerAnkleFrontAngle = asin(walkerFootFrontLength / walkerFootFrontTriangleTopLength);
echo("walkerAnkleFrontAngle (β)", walkerAnkleFrontAngle);
echo("-------------------------------------------------------");
echo("Back");
echo("walkerFootBackLength (b)", walkerFootBackLength);
walkerFootBackTriangleTopLength = sqrt(pow(walkerFootHeight, 2) + pow(walkerFootBackLength, 2));
echo("walkerFootBackTriangleTopLength (c)", walkerFootBackTriangleTopLength);
walkerFootBackJointAngle = asin(walkerFootHeight / walkerFootBackTriangleTopLength);
echo("walkerFootBackJointAngle (α):", walkerFootBackJointAngle);
walkerAnkleBackAngle = asin(walkerFootBackLength / walkerFootBackTriangleTopLength);
echo("walkerAnkleBackAngle (β)", walkerAnkleBackAngle);
echo("=======================================================");

walkerBodyLowerShaftHolderRollerBearingHeightAboveThrustBearing = 50;

// Colors
JointColor = "CornflowerBlue";
PipeColor = "Pink";

// Resoution
// This is perfect for 3D Printing,
// but you may want to comment it out while working to improve preview
// performance
//$fa = 1;
//$fs = 0.4;
// Although this makes it VERY high rez, which might be better for the slicer? Experimenting with it instead.
// NOTE that using $fn causes FreeCAD and hence .step files exported to Fusion 360 to show round items as a series of faces instead of a single object.
//$fn = 500;
