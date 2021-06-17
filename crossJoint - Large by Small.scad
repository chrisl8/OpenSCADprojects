// Load in some defaults
include <commonParameters.scad>;

shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

// The + 0.15 was selected via trial and error to ensure the shaft holder and leg pipes
// don't cross into each other at all.
shaftOffset = (verticalPipeInsideDiameter / 2) + (shaftPipeInsideDiameter / 2) + (jointWallThickness + 0.15);

include <jointModule.scad>;

difference() {
    union() {
        shaftHolderLegLength = 60;

        // Build the two small legs individually in order to spread them out from the center.
        smallAxisJointLeg1 = [
                [[90, 90, 0], horizontalPipeInsideDiameter, true, 90, shaftHolderLegLength],
            ];
        translate([0, - horizontalPipeInsideDiameter_1_25pvc / 2 + horizontalPipeInsideDiameter / 2, 0])
            joint(smallAxisJointLeg1, horizontalPipeInsideDiameter);

        smallAxisJointLeg2 = [
                [[270, 90, 0], horizontalPipeInsideDiameter, true, 90, shaftHolderLegLength],
            ];
        translate([0, horizontalPipeInsideDiameter_1_25pvc / 2 - horizontalPipeInsideDiameter / 2, 0])
            joint(smallAxisJointLeg2, horizontalPipeInsideDiameter);

        // Extra triangle supports
        supportTriangleSize = 60;
        linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
            polygon(points = [[supportTriangleSize, 0], [0, 0], [0, supportTriangleSize]],
            paths =
                [[0, 1, 2]]);
        rotate([0, 0, 90])
            linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                polygon(points = [[supportTriangleSize, 0], [0, 0], [0, supportTriangleSize]],
                paths =
                    [[0, 1, 2]]);
        rotate([0, 0, 180])
            linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                polygon(points = [[supportTriangleSize, 0], [0, 0], [0, supportTriangleSize]],
                paths =
                    [[0, 1, 2]]);
        rotate([0, 0, 270])
            linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                polygon(points = [[supportTriangleSize, 0], [0, 0], [0, supportTriangleSize]],
                paths =
                    [[0, 1, 2]]);

        largeAxisJointLegs = [
                [[0, 90, 0], horizontalPipeInsideDiameter_1_25pvc, true, 90, shaftHolderLegLength],
                [[180, 90, 0], horizontalPipeInsideDiameter_1_25pvc, true, 90, shaftHolderLegLength],
            ];
        translate([0, 0, (horizontalPipeInsideDiameter / 2) - .75]) joint(largeAxisJointLegs,
        horizontalPipeInsideDiameter);
    }
    union() {
        // Drill out the mess we made
        rotate([90, 0, 0])
            translate([0, 0, - 100])
                cylinder(h = 200 + 0.02, r = horizontalPipeInsideDiameter / 2);

        rotate([90, 0, 90])
            translate([0, horizontalPipeInsideDiameter / 2 - .75, - 75])
                cylinder(h = 150 + 0.02, r = horizontalPipeInsideDiameter_1_25pvc / 2);
    }
}

