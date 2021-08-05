include <jointModule.scad>;

module legsAroundTheCenterPoint(legCount = 1, legLength = false, includeTriangleSupports = true) {
    legSpacingInDegrees = 360 / legCount;

    // TODO: Triangle parameters should be arguments to the function.
    //       and/or use some fancy math to generate.
    jointLegs = [for (i = [0:legCount - 1]) legInstance(rotation = [0, 90, legSpacingInDegrees * i], insideDiameter =
    horizontalPipeInsideDiameter,
    flatBottom = true, pinHole = true, length = legLength, triangleSupport = includeTriangleSupports ? [15, - 21 + legSpacingInDegrees * i, 50] : false)];
    joint(jointLegs, horizontalPipeInsideDiameter, true);
}
