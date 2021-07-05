// Load in some defaults
include <commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <jointModule.scad>;

// Pin holes are all 90 because:
// 1. I don't want the bolts/screws to touch the ground
// 2. They are easier to drill at these angles.
module walkerFootBackLowerJoint()
{
    jointLegs = [
            [[0, 90, 0], horizontalPipeInsideDiameter, true, 90, footLowerJointLegLength],
            [[0, 90, - walkerFootBackJointAngle], horizontalPipeInsideDiameter, true, 90, footLowerJointLegLength, [50,
            - (walkerFootBackJointAngle * 1.5), 30]],
        // Upright
            [[0, 0, 0], verticalPipeInsideDiameter, false, walkerFootBackJointAngle, 55, [1, -23, 45]],
        ];

    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

