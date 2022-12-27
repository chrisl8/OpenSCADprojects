// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

module BoxCornerJoint()
{
    jointLegs = [
        legInstance(rotation = [0, 90, 0], insideDiameter = horizontalPipeInsideDiameter, flatBottom = true, pinHole =
        true, length = jointLegLength + 25),
        legInstance(rotation = [45, 90, 0], insideDiameter = horizontalPipeInsideDiameter, flatBottom = true, pinHole =
        true, length = jointLegLength + 50),
        legInstance(rotation = [90, 90, 0], insideDiameter = horizontalPipeInsideDiameter, flatBottom = true, pinHole =
        true, length = jointLegLength + 25, triangleSupport = [10, -90, 60]),
        // Upright
        legInstance(insideDiameter = verticalPipeInsideDiameter, pinHole = true, triangleSupport = [10, - 45, 40]),
        ];

    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

//BoxCornerJoint();
