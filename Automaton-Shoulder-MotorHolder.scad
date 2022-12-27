// Load in some defaults
include <parameters/commonParameters.scad>;

include <modules/roundedcube.scad>;

shoulderSquareWidth = 100;
shoulderBlockHeight = 5;
motorMountDepth = 52.2;
motorMountWidth = 38.2;

difference() {
    roundedcube([shoulderSquareWidth, shoulderSquareWidth, shoulderBlockHeight], true, shoulderBlockHeight, "zmax");

    // Motor bracket cutout
    translate([0, shoulderSquareWidth / 2 - 25, shoulderBlockHeight * 2 - 2.2])
        cube([motorMountWidth, motorMountDepth, shoulderBlockHeight], true);
}

pipeHolderWidth = (horizontalPipeInsideDiameter_0_50pvc) + (jointWallThickness * 2);

module automatonJointPipeHolder(oppositeSide = 1) {
    rotate([0, 90, 0])
        translate([- ((pipeHolderWidth / 2) + (shoulderBlockHeight)), 0, oppositeSide * ((shoulderSquareWidth / 2) - (
            pipeHolderWidth / 2))])
            difference() {
                roundedcube([pipeHolderWidth, shoulderSquareWidth, pipeHolderWidth], true, 5, "xmin");
                union() {
                    rotate([90, 0, 0])
                        cylinder(d = horizontalPipeInsideDiameter_0_50pvc, h = shoulderSquareWidth + 10, center = true);
                    // Make a hole near the end of the leg for pinning
                    // The -0.01 ensures that the end of the tube is clear.
                    rotate([0, 0, 0])
                        translate([0, - ((shoulderSquareWidth / 2) - (jointPinHoleOffset * 2)), 0])
                            cylinder(
                            h = pipeHolderWidth + 0.01 + 100, d = jointPinningHoleDiameter, center
                            = true);
                }
            }
}

automatonJointPipeHolder();
automatonJointPipeHolder(- 1);
