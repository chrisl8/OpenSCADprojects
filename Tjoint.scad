// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

module tJoint()
{
    jointLegs = [
            [[0, 90, 90], horizontalPipeInsideDiameter, true, 90, false],
            [[0, 90, -90], horizontalPipeInsideDiameter, true, 90, false, [10, -90, 40]],
            [[0, 90, 0], horizontalPipeInsideDiameter, true, 90, false, true],
        ];

    rotate([0, 0, 0]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

tJoint();
