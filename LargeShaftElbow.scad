// ******************************************
// This is to print a T shapd intersection piece,
// used to hold an offset shaft,
// and a center mounted rod to hold a motor.
// It is based off of Tardis Console.scad,
// so some modules should match exactly.
// ******************************************

// ******************************************
// To Export a part for printing:
// If there is one command per part,
// prefix it with ! to say "only show this".
// ******************************************

// Resoution
// This is perfect for 3D Printing,
// but you may want to comment it out while working to improve preview
// performance
$fa = 1;
$fs = 0.4;

// Load in some defaults
include <commonParameters.scad>;

jointLegLength = 75;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_1_25pvc;

include <jointModule.scad>;

// TODO: It broke:
//       1. Too narrow, make it wider.
//       2. Might be too thin.

module BoxCornerJoint()
{
    jointLegs = [
            [[0, 90, 0], horizontalPipeInsideDiameter, true, true],
            [[90, 90, 0], horizontalPipeInsideDiameter, true, true],
        ];

    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

BoxCornerJoint();
