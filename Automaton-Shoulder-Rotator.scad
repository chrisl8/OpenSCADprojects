// Load in some defaults
include <parameters/commonParameters.scad>;

include <modules/roundedcube.scad>;

shoulderSquareWidth = 30; // 100
shoulderBlockHeight = 4; // 5
motorMountDepth = 52.2;
motorMountWidth = 38.2;

shaftDiameter = 6.2;
hubLength = 4.2 + 5;
hubDiameter = 25.4 + 0.2;
screwHoleDiameter = 3.1; // Perfect
screwHolePosition = (hubDiameter / 2) - 3;

module screwHole(rotation) {
    rotate([0, 0, rotation])
        translate([0, screwHolePosition, 0])
            cylinder(d = screwHoleDiameter, h = shoulderBlockHeight * 4, center = true);
}

difference() {
    roundedcube([shoulderSquareWidth, shoulderSquareWidth, shoulderBlockHeight], true, shoulderBlockHeight, "zmax");

    union() {
        translate([0, 0, - shoulderBlockHeight * 1.5])
            cylinder(d = hubDiameter, h = hubLength + 0.01, center = false);
        screwHole(0);
        screwHole(360 / 6);
        screwHole((360 / 6) * 2);
        screwHole((360 / 6) * 3);
        screwHole((360 / 6) * 4);
        screwHole((360 / 6) * 5);
    }
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

//automatonJointPipeHolder();
//automatonJointPipeHolder(- 1);
