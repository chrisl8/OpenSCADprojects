// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

// Joint "legs" to go under battery for strength
underHolderLegLength = 86;
difference() {
    union() {
        batteryHolderLeg1 = [
                [[90, 90, 0], horizontalPipeInsideDiameter, true, false, underHolderLegLength],
            ];
        rotate([0, 0, - 90]) joint(batteryHolderLeg1, horizontalPipeInsideDiameter, false);

        batteryHolderLeg2 = [
                [[90, 90, 0], horizontalPipeInsideDiameter, true, false, underHolderLegLength],
            ];
        translate([0, (batteryLength / 2) - horizontalPipeInsideDiameter, 0])
            rotate([0, 0, - 90]) joint(batteryHolderLeg2, horizontalPipeInsideDiameter, false);

        batteryHolderLeg3 = [
                [[90, 90, 0], horizontalPipeInsideDiameter, true, false, underHolderLegLength],
            ];
        translate([0, - ((batteryLength / 2) - horizontalPipeInsideDiameter), 0])
            rotate([0, 0, - 90]) joint(batteryHolderLeg3, horizontalPipeInsideDiameter, false);
    }
    union() {
        // Clean the bits of these legs out of the mounting pipes
        rotate([90, 0, 0])
            cylinder(h = 150 + 0.02, d = horizontalPipeInsideDiameter + 0.1, center = true);
        rotate([0, 0, 0])
            cylinder(h = 150 + 0.02, d = verticalPipeInsideDiameter, center = false);
    }
}

// Large T-Joint
module BoxCornerJoint()
{
    jointLegs = [
            // Horizontal
            [[90, 90, 0], horizontalPipeInsideDiameter, true, 90, 75],
            [[90, 90, 180], horizontalPipeInsideDiameter, true, 90, 75],

            // Upright
            [[0, 0, 0], verticalPipeInsideDiameter, false, true, 140],
        ];

    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, true);
}

BoxCornerJoint();

batteryHolderWallThickness = 5;

// Battery Dimensions
// https://www.power-sonic.com/product/ps-1290/
batteryHeight = 94;
batteryWidth = 65;
batteryLength = 141;

translate([- (horizontalPipeInsideDiameter * 2) - batteryHolderWallThickness + 0.8, 0, (batteryHeight / 2) - (
    batteryHolderWallThickness / 2) - 0.5 + batteryHolderWallThickness * 4])
    difference() {
        union() {
            cube([
                    batteryWidth + (batteryHolderWallThickness * 2),
                batteryLength,
                    batteryHeight +
                        batteryHolderWallThickness * 4
                ], center = true);
        }
        union() {
            // Cut out the space for the battery
            translate([0, 0, batteryHolderWallThickness])
                cube([batteryWidth, batteryLength + batteryHolderWallThickness, batteryHeight +
                        batteryHolderWallThickness * 3], center = true);

            // Cut some holes in the top for strapping the sides together
            rotate([0, 90, 0])
                translate([- batteryHeight / 2 - batteryHolderWallThickness / 2, batteryLength / 3, 0])
                    cylinder(h = batteryWidth * 2, d = jointPinningHoleDiameter, center = true);
            rotate([0, 90, 0])
                translate([- batteryHeight / 2 - batteryHolderWallThickness / 2, - batteryLength / 3, 0])
                    cylinder(h = batteryWidth * 2, d = jointPinningHoleDiameter, center = true);
            rotate([0, 90, 0])
                translate([- batteryHeight / 2 - batteryHolderWallThickness / 2, horizontalPipeInsideDiameter / 1.25, 0]
                )
                    cylinder(h = batteryWidth * 2, d = jointPinningHoleDiameter, center = true);
            rotate([0, 90, 0])
                translate([- batteryHeight / 2 - batteryHolderWallThickness / 2, - horizontalPipeInsideDiameter / 1.25,
                    0])
                    cylinder(h = batteryWidth * 2, d = jointPinningHoleDiameter, center = true);

            // Hollow out legs beneath battery box
            translate([50, 0, - ((batteryHeight / 2) - (
                batteryHolderWallThickness / 2) - 0.5 + batteryHolderWallThickness * 4)]) {
                rotate([0, - 90, 0])
                    cylinder(h = 150 + 0.02, d = horizontalPipeInsideDiameter + 0.1, center = false);

                translate([0, (batteryLength / 2) - horizontalPipeInsideDiameter, 0])
                    rotate([0, - 90, 0])
                        cylinder(h = 150 + 0.02, d = horizontalPipeInsideDiameter + 0.1, center = false);

                translate([0, - ((batteryLength / 2) - horizontalPipeInsideDiameter), 0])
                    rotate([0, - 90, 0])
                        cylinder(h = 150 + 0.02, d = horizontalPipeInsideDiameter + 0.1, center = false);
            }
        }
    }


// Fun Triangles for supports on the T side
b = 15;
b2 = 9;
h = 98;
h2 = - 4;
w = 8;

translate([- horizontalPipeInsideDiameter / 2 - 1, jointLegLength / 1.75, horizontalPipeInsideDiameter / 2])
    rotate([- 90, - 90, 0])
        union() {
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h, 0], [0, b]], paths = [[0, 1, 2]]);
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h2, 0], [0, b2]], paths = [[0, 1, 2]]);
        }

translate([- horizontalPipeInsideDiameter / 2 - 1, - jointLegLength / 1.75, horizontalPipeInsideDiameter / 2])
    rotate([- 90, - 90, 0])
        union() {
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h, 0], [0, b]], paths = [[0, 1, 2]]);
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h2, 0], [0, b2]], paths = [[0, 1, 2]]);
        }
