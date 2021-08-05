include <parameters/commonParameters.scad>;
include <parameters/verticalShaftHolderParameters.scad>;

// This piece should be able to slide onto the shaft,
// be pinned in place,
// Have a Thrust Bearing sit on it,
// and then have a part that moves around the shaft sit on it.

module verticalShaftHolder(includePinnedRing = true, thrustBearingSupportHeight = thrustBearingHeight,
rollerBearingHeightAboveThrustBearing = thrustBearingHeight) {

    totalPartHeight = (includePinnedRing ? comfortablePinnedSectionHeight : 0) +
        thrustBearingSupportHeight +
        thrustBearingHeight +
        rollerBearingHeightAboveThrustBearing +
        rollerBearingHeight;
    echo(totalPartHeight - thrustBearingSupportHeight);

    difference() {
        union() {
            // This is for the roller bearing to work against,
            // and constitutes the overall height
            cylinder(h = totalPartHeight, d = rollerBearingInsideDiameter);

            if (includePinnedRing) {
                // Pin this part
                cylinder(h = comfortablePinnedSectionHeight, d = comfortablePinningDiameter);
            }

            // This is to support the thrust bearing
            translate([0, 0, includePinnedRing ? comfortablePinnedSectionHeight : 0])
                cylinder(h = thrustBearingSupportHeight, d = thrustBearingOutsideDiameter);
        }
        // Hollow out for the pipe to fit in.
        translate([0, 0, - 1]) // -1 just ensures we clear the bottom and don't leave a 2d "film"
            cylinder(h = totalPartHeight + 10, d = verticalPipeInsideDiameter_1_25pvc);

        if (includePinnedRing) {
            // Make a hole near the end of the leg for pinning
            // The -0.01 ensures that the end of the tube is clear.
            rotate([90, 0, 0])
                translate([0, comfortablePinnedSectionHeight / 2, 0])
                    cylinder(
                    h = 500, d = jointPinningHoleDiameter, center = true);
        }
    }
}

//verticalShaftHolder(includePinnedRing = false);

// Use this to view the two shafts together
//include<verticalShaftHolderPivotPoint.scad>;
//translate([0, 0, thrustBearingHeight * 2])
//    verticalShaftHolderPivotPoint();