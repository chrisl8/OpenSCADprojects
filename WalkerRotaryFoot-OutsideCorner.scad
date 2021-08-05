// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

module regularPolygonOutsideJoint(legCount = 4, legLength = false) {

    legSpacingInDegrees = ((legCount - 2) * 180) / legCount;

    jointLegs = [
        // Center Leg
        legInstance(rotation = [0, 90, 0], insideDiameter = horizontalPipeInsideDiameter, flatBottom = true, pinHole =
        true, length = legLength),
        // Perimiter Legs
        legInstance(rotation = [legSpacingInDegrees / 2, 90, 0], insideDiameter = horizontalPipeInsideDiameter,
        flatBottom = true, pinHole =
        true, length = legLength, triangleSupport = [0, -8, 40]),
        legInstance(rotation = [- legSpacingInDegrees / 2, 90, 0], insideDiameter = horizontalPipeInsideDiameter,
        flatBottom = true, pinHole =
        true, length = legLength, triangleSupport = [0, (-legSpacingInDegrees /2) -10, 40]),
        // Upright Leg
        legInstance(rotation = [0, 0, 0], insideDiameter = verticalPipeInsideDiameter, pinHole = true, length =
        legLength, triangleSupport = [0, 0, 40]),
        ];

    rotate([0, 0, 180])
        joint(jointLegs, horizontalPipeInsideDiameter, true);
}

//regularPolygonOutsideJoint(legCount = 8, legLength = 65);