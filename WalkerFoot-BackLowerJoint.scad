// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

// Pin holes are all 90 because:
// 1. I don't want the bolts/screws to touch the ground
// 2. They are easier to drill at these angles.
module walkerFootBackLowerJoint(labelText, reverseText = false)
{
    jointLegs = [
        legInstance(rotation = [0, 90, 0], insideDiameter = horizontalPipeInsideDiameter, flatBottom = true, pinHole =
        90, length = footLowerJointLegLength, labelText = "Mechanoid", reverseText = reverseText),
        legInstance(rotation = [0, 90, - walkerFootBackJointAngle], insideDiameter = horizontalPipeInsideDiameter,
        flatBottom = true, pinHole = 90, length = footLowerJointLegLength, triangleSupport = [50,
            - (walkerFootBackJointAngle * 1.5), 30], labelText = labelText, reverseText = reverseText),
        // Upright
        legInstance(insideDiameter = verticalPipeInsideDiameter, pinHole = walkerFootBackJointAngle, length = 55,
        triangleSupport = [1, - 23, 45]),
        ];

    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

// Left side
//walkerFootBackLowerJoint("Foot-Back-L");

// Right side
mirror([1, 0, 0])
    walkerFootBackLowerJoint("Foot-Back-R", true);
