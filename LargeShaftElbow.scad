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
