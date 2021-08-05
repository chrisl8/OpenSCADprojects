// Load in some defaults
include <parameters/commonParameters.scad>;

shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

// The + 0.15 was selected via trial and error to ensure the shaft holder and leg pipes
// don't cross into each other at all.
shaftOffset = (verticalPipeInsideDiameter / 2) + (shaftPipeInsideDiameter / 2) + (jointWallThickness + 0.15);

include <modules/jointModule.scad>;

difference() {
    union() {
        shaftHolderLegLength = 75;

        // Build the two small legs individually in order to spread them out from the center.
        smallAxisJointLegs = [
                [[90, 90, 0], horizontalPipeInsideDiameter, true, 90, shaftHolderLegLength, 70],
                [[0, 90, 0], horizontalPipeInsideDiameter, true, 90, shaftHolderLegLength, 70],
                [[270, 90, 0], horizontalPipeInsideDiameter, true, 90, shaftHolderLegLength],
            ];
        joint(smallAxisJointLegs, horizontalPipeInsideDiameter);

        largeAxisJointLegs = [
                [[0, 90, 0], horizontalPipeInsideDiameter_1_25pvc, true, 90, shaftHolderLegLength],
            ];
        translate([0, 0, (horizontalPipeInsideDiameter / 2) - .65]) joint(largeAxisJointLegs,
        horizontalPipeInsideDiameter_1_25pvc, true);
    }
    union() {
        // Drill out the mess we made
        rotate([90, 0, 0])
            translate([0, 0, - 100])
                cylinder(h = 200 + 0.02, r = horizontalPipeInsideDiameter / 2);

        rotate([90, 0, 90])
            translate([0, horizontalPipeInsideDiameter / 2 - .75, -1])
                cylinder(h = 160 + 0.02, r = horizontalPipeInsideDiameter_1_25pvc / 2);
    }
}

