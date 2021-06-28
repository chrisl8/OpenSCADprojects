// Load in some defaults
include <commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

centerOffset = 20;

include <jointModule.scad>;

horizontalJointOffset = 39;

module clearShaft()
{
    // Clear shaft
    // The -0.01 ensures that the end of the tube is clear.
    translate([0, 0, - (horizontalPipeInsideDiameter / 2) - jointWallThickness - 0.01])
        cylinder(h = jointLegLength, d = shaftPipeInsideDiameter);
}

difference()
    {
        union()
            {
                ankleJointLength = 80;
                upright = [
                        [[0, 90, 0], horizontalPipeInsideDiameter, true, true, ankleJointLength + 15],
                    ];
                joint(upright, horizontalPipeInsideDiameter, false);

                horizontal = [
                        [[0, 0, 0], horizontalPipeInsideDiameter, false, 90, 75],
                    ];
                translate([horizontalJointOffset, 0, 0])
                    rotate([0, 0, 180]) joint(horizontal, horizontalPipeInsideDiameter, false);

                footBack = [
                        [[0, 90, - walkerAnkleBackAngle], horizontalPipeInsideDiameter, true, true,
                        ankleJointLength],
                    ];
                joint(footBack, horizontalPipeInsideDiameter, false);

                footFront = [
                        [[0, 90, walkerAnkleFrontAngle], horizontalPipeInsideDiameter, true, true,
                        ankleJointLength],
                    ];
                joint(footFront, horizontalPipeInsideDiameter, false);

                // Extra triangle supports
                supportTriangleHeight = 60;
                supportTriangleWidthConstraint = 25;
                // Front
                rotate([0, 0, -20])
                    linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                        polygon(points = [[0, 0], [supportTriangleHeight, supportTriangleWidthConstraint],  [supportTriangleWidthConstraint, supportTriangleHeight]],
                        paths =
                            [[0, 1, 2]]);
                // Back
                rotate([0, 0, -70])
                        linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                            polygon(points = [[0, 0], [supportTriangleHeight, supportTriangleWidthConstraint],  [supportTriangleWidthConstraint, supportTriangleHeight]],
                            paths =
                                [[0, 1, 2]]);
                horizontalSupportTriangleSize = 40;
                rotate([- 90, 270, 0])
                    translate([10, 50, 0])
                        linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                            polygon(points = [[horizontalSupportTriangleSize, 0], [0, 0], [0,
                                horizontalSupportTriangleSize]],
                            paths =
                                [[0, 1, 2]]);
            }
        union()
            {
                clearingCylinderLength = 200;

                // Clear upright
                rotate([0, 90, 0])
                    cylinder(h = clearingCylinderLength, d = horizontalPipeInsideDiameter);

                // Clear footFront
                rotate([0, 90, walkerAnkleFrontAngle])
                    cylinder(h = clearingCylinderLength, d = horizontalPipeInsideDiameter);

                // Clear footBack
                rotate([0, 90, - walkerAnkleBackAngle])
                    cylinder(h = 200, d = horizontalPipeInsideDiameter);

                // Clear horizontal
                translate([horizontalJointOffset, 0, 0])
                    cylinder(h = clearingCylinderLength, d = horizontalPipeInsideDiameter);

                clearShaft();
            }
    }

// Shaft
difference() {
    shaftLeg = [
            [[0, 0, 0], shaftPipeInsideDiameter, false, false],
        ];
    translate([0, 0, - (horizontalPipeInsideDiameter / 2) - jointWallThickness])
        rotate([0, 0, 0])
            joint(shaftLeg, shaftPipeInsideDiameter, false);

    // Clear shaft (again)
    clearShaft();
}