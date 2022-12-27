// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <modules/jointModule.scad>;
include <modules/legsAroundTheCenterPoint.scad>;
include <verticalShaftHolder.scad>;

module center(supportHeight) {
    totalPartHeight = comfortablePinnedSectionHeight + supportHeight;

    difference() {
        union() {
            cylinder(h = supportHeight, d = thrustBearingOutsideDiameter);

            // This is to support the thrust bearing
            translate([0, 0, supportHeight])
                cylinder(h = comfortablePinnedSectionHeight, d = comfortablePinningDiameter);
        }
        // Hollow out for the pipe to fit in.
        translate([0, 0, - 1]) // -1 just ensures we clear the bottom and don't leave a 2d "film"
            cylinder(h = totalPartHeight + 10, d = verticalPipeInsideDiameter_1_25pvc);

        // Make a hole near the end of the leg for pinning
        // The -0.01 ensures that the end of the tube is clear.
        rotate([90, 0, 0])
            translate([0, supportHeight + (comfortablePinnedSectionHeight / 2), 0])
                cylinder(
                h = 500, d = jointPinningHoleDiameter, center = true);
    }
}

module WalkerRotaryFootLowerShaftHolder(legCount = 8, legLength = 80) {
    difference()
        {
            union()
                {
                    legsAroundTheCenterPoint(legCount = legCount, legLength = legLength);
                }
            union()
                {
                    // The -0.01 ensures that the end of the tube is clear.
                    translate([0, 0, - (horizontalPipeInsideDiameter / 2) - jointWallThickness - 0.01])
                        cylinder(h = jointLegLength, d = shaftPipeInsideDiameter);
                }
        }

    translate([0,0,-horizontalPipeInsideDiameter/2 - jointWallThickness])
    center(supportHeight = horizontalPipeInsideDiameter + (jointWallThickness * 2));

}

//WalkerRotaryFootLowerShaftHolder();