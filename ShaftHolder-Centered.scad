// Load in some defaults
include <commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

centerOffset = 20;

include <jointModule.scad>;

difference()
    {
        union()
            {
                jointLeg1 = [
                        [[0, 90, 0], horizontalPipeInsideDiameter, true, true],
                    ];
                translate([- centerOffset, 0, 0])
                    rotate([0, 0, 180]) joint(jointLeg1, horizontalPipeInsideDiameter, true);

                jointLeg2 = [
                        [[90, 90, 0], horizontalPipeInsideDiameter, true, true],
                    ];
                translate([0, centerOffset, 0])
                    rotate([0, 0, 180]) joint(jointLeg2, horizontalPipeInsideDiameter, true);

                jointLeg3 = [
                        [[90, 90, 180], horizontalPipeInsideDiameter, true, true],
                    ];
                translate([0, - centerOffset, 0])
                    rotate([0, 0, 180]) joint(jointLeg3, horizontalPipeInsideDiameter, true);

                jointLeg4 = [
                        [[180, 90, 0], horizontalPipeInsideDiameter, true, true],
                    ];
                translate([centerOffset, 0, 0])
                    rotate([0, 0, 180]) joint(jointLeg4, horizontalPipeInsideDiameter, true);

                shaftLeg = [
                        [[0, 0, 0], shaftPipeInsideDiameter, false, false],
                    ];
                translate([0, 0, - (horizontalPipeInsideDiameter / 2) - jointWallThickness])
                    rotate([0, 0, 180])
                        joint(shaftLeg, shaftPipeInsideDiameter, false);
            }
        union()
            {
                // The -0.01 ensures that the end of the tube is clear.
                translate([0, 0, - (horizontalPipeInsideDiameter / 2) - jointWallThickness - 0.01])
                    cylinder(h = jointLegLength, d = shaftPipeInsideDiameter);
            }
    }
