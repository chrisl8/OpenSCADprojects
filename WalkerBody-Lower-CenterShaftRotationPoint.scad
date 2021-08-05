include <parameters/commonParameters.scad>;
include <parameters/verticalShaftHolderParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <modules/jointModule.scad>;
include <modules/legsAroundTheCenterPoint.scad>;
include <verticalShaftHolderPivotPoint.scad>;

module WalkerBodyLowerCenterShaftRotationPoint() {
    difference()
        {
            union()
                {
                    legsAroundTheCenterPoint(legCount = 4, legLength = 80, includeTriangleSupports = false);

                    // Extra triangle supports
                    horizontalSupportTriangleSize = 40;
                    trianglePositions = [0, 90, 180, 270];
                    for(trianglePosition = trianglePositions) {
                        rotate([0, 270, trianglePosition])
                            translate([12, 30, 0])
                                linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                                    polygon(points = [[horizontalSupportTriangleSize, 0], [0, 0], [0,
                                        horizontalSupportTriangleSize]],
                                    paths =
                                        [[0, 1, 2]]);
                    }
                }
            union()
                {
                    // The -0.01 ensures that the end of the tube is clear.
                    translate([0, 0, - 100])
                        cylinder(h = 200, d = thrustBearingOutsideDiameter);
                }
        }

    translate([0, 0, - horizontalPipeInsideDiameter / 2 - jointWallThickness])
        verticalShaftHolderPivotPoint(outsideDiameter = thrustBearingOutsideDiameter, rollerBearingHeightAboveThrustBearing = walkerBodyLowerShaftHolderRollerBearingHeightAboveThrustBearing);
}

//WalkerBodyLowerCenterShaftRotationPoint();