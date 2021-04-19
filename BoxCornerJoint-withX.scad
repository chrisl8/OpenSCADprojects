// Load in some defaults
include <commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <jointModule.scad>;

module BoxCornerJoint()
{
    jointLegs = [
            [[0, 90, 0], horizontalPipeInsideDiameter, true, true, jointLegLength + 25],
            [[45, 90, 0], horizontalPipeInsideDiameter, true, true, jointLegLength + 50],
            [[90, 90, 0], horizontalPipeInsideDiameter, true, true, jointLegLength + 25],
        // Upright
            [[0, 0, 0], verticalPipeInsideDiameter, false, true],
        ];

    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

BoxCornerJoint();
