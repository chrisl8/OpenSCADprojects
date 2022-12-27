include <parameters/commonParameters.scad>;
include <parameters/verticalShaftHolderParameters.scad>;
include <Generic12vBatteryBox.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <modules/jointModule.scad>;
include <modules/legsAroundTheCenterPoint.scad>;
include <verticalShaftHolderPivotPoint.scad>;

// TODO: Should this part incorporate the batteryholder?
// TODO: This part needs to accomodate a thrust bearing on top and a pinned piece above it.

module attachedBatteryBox() {
    // Battery box
    translate([
            (batteryWidth / 2) + (thrustBearingOutsideDiameter / 2),
        0,
                (batteryBoxDepth / 2) + (
                horizontalPipeInsideDiameter / 2) + (batteryHolderWallThickness / 2)
        ])
        Generic12vBatteryBox();

    // Floor extension to bottom of bed
}

module WalkerBodyLowerCenterShaftRotationPoint() {
    difference()
        {
            // Legs plus a cut to ensure they don't protrude into the center.
            union()
                {
                    legsAroundTheCenterPoint(legCount = 4, legLength = 125, includeTriangleSupports = false);
                }
            union()
                {
                    // The -0.01 ensures that the end of the tube is clear.
                    translate([0, 0, - 100])
                        cylinder(h = 200, d = thrustBearingOutsideDiameter);
                }
        }

    // Center shaft holder itself
    translate([0, 0, - horizontalPipeInsideDiameter / 2 - jointWallThickness])
        verticalShaftHolderPivotPoint(outsideDiameter = thrustBearingOutsideDiameter,
        rollerBearingHeightAboveThrustBearing = walkerBodyLowerShaftHolderRollerBearingHeightAboveThrustBearing);

    rotate([0, 0, 45])
        attachedBatteryBox();

    rotate([0, 0, -135])
        attachedBatteryBox();
}

WalkerBodyLowerCenterShaftRotationPoint();

// Initial desing filament: 328.44g, but it will require supports.
// 0.20mm Quality w/ 15% infill, Supports Overhang threshold 5 and brim: 384.18g @ 1d7h27m
// 5% infill: 333.28g @ 1d3h14m
// Draft 15% infill: 421.84g @ 19h33m
// Draft  5% infill 370.71g 18h10m