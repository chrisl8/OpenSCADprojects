// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

// Pin holes are all 90 because:
// 1. I don't want the bolts/screws to touch the ground
// 2. They are easier to drill at these angles.
module walkerFootFrontLowerJoint(labelText, reverseText = false)
{
    rotate([0, 0, 180]) joint(legs = [
        legInstance(rotation = [0, 90, 0], insideDiameter = horizontalPipeInsideDiameter, flatBottom = true, pinHole =
        90, length = footLowerJointLegLength, labelText = "Mechanoid", reverseText = reverseText),
        legInstance(rotation = [0, 90, walkerFootFrontJointAngle], insideDiameter = horizontalPipeInsideDiameter,
        flatBottom = true, pinHole = 90, length = footLowerJointLegLength, triangleSupport = [50,
            - (walkerFootFrontJointAngle / 2), 25], labelText = labelText, reverseText = reverseText),
        // Upright
        legInstance(rotation = [0, 0, 0], insideDiameter = verticalPipeInsideDiameter, pinHole =
            walkerFootFrontJointAngle - 90, length = 55, triangleSupport = [1, 23, 45]),
        ], sphereJointInsideDiameter = horizontalPipeInsideDiameter, closeUpWithSphere = true);
}

// Left side
walkerFootFrontLowerJoint("Foot-Front-L");

// Right side
//mirror([1, 0, 0])
//    walkerFootFrontLowerJoint("Foot-Front-R", true);
