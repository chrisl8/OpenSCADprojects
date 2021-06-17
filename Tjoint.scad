// Load in some defaults
include <commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;

include <jointModule.scad>;

module BoxCornerJoint()
{
    jointLegs = [
            [[0, 90, 0], horizontalPipeInsideDiameter, true, 90, false, true],
            [[90, 90, 0], horizontalPipeInsideDiameter, true, 90, false, true],
            [[90, 90, 180], horizontalPipeInsideDiameter, true, 90, false, true],
        ];

    rotate([0, 0, 0]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

BoxCornerJoint();
