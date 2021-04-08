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

include <commonParameters.scad>;

shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <jointModule.scad>;

module shaftT()
{
    jointLegs = [
            [[0, 90, 0], horizontalPipeInsideDiameter, true, true],
            [[180, 90, 0], horizontalPipeInsideDiameter, true],
            [[90, 90, 0], horizontalPipeInsideDiameter, true],
            [[270, 90, 0], horizontalPipeInsideDiameter, true, true],
        // Motor Holder
            [[0, 0, 0], verticalPipeInsideDiameter, false, true],
        ];

    rotate([0, 0, 180]) joint(jointLegs, verticalPipeInsideDiameter);
}

shaftT();

// Create offset shaft holder

shaftHolder = [
        [[0, 0, 0], shaftPipeInsideDiameter],
    ];

// The + 0.15 was selected via trial and error to ensure the shaft holder and leg pipes
// don't cross into each other at all.
shaftOffset = (verticalPipeInsideDiameter / 2) + (shaftPipeInsideDiameter / 2) + (jointWallThickness + 0.15);

// Double Wall Thickness to account for flat bottom
translate([shaftOffset, shaftOffset, - (
    horizontalPipeInsideDiameter + (jointWallThickness * 2)) / 2])
    rotate([0, 0, 180]) joint(shaftHolder, shaftPipeInsideDiameter);
