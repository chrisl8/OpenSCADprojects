include <parameters/commonParameters.scad>;
include <parameters/verticalShaftHolderParameters.scad>;
// Example part to sit on the verticalShaftHolder
// including holding a roller bearing

// The bottom should be no narrower than thrustBearingMinimumAbutmentDiameter,
// But it can be much bigger.

// The idea is that sits ON the thrust bearing, and holds a roller bearing to minimize friction around the center shaft,
// for times when there is angular stress on the system.

module verticalShaftHolderPivotPoint(outsideDiameter = thrustBearingMinimumAbutmentDiameter, rollerBearingHeightAboveThrustBearing = thrustBearingHeight) {
    difference() {
        // Height and width of this part are minimums.
        echo(rollerBearingHeightAboveThrustBearing + rollerBearingHeight);
        cylinder(h = rollerBearingHeightAboveThrustBearing + rollerBearingHeight, d =
        outsideDiameter);
        union() {
            translate([0, 0, - 1]) // -1 just ensures we clear the bottom and don't leave a 2d "film"
                cylinder(h = 200, d = thrustBearingOuterDiameterShaftWasher);
            translate([0, 0, rollerBearingHeightAboveThrustBearing])
                cylinder(h = 200, d = rollerBearingOutsideDiameter);
        }
    }
}

// Remember that the thrust bearing fits between these two parts,
// In theory one could "encapsulate" it, but remember the top and bottom
// of the thrust washer have the same outside diameter, so you can't "squeeze" it.
// In theory the INSIDE of this part should hold everything in place.

// The only possible "slop" is that the roller ball carrier and the top of the thrust bearing could "rattle" a little, but I think that the groove in the top and bottom pieces
// will center it rapidly.
// Not to mention pinning it relatively tighly will prevent it "poppping out".

// If that is an issue though, we could "capture" or "squeeze" the top "washer"
// of the thrust bearing.

// The MINIMUM outside diameter is thrustBearingMinimumAbutmentDiameter,
// which is the default if no argument is given,
// But to fully use the entire surface of the thrust washer use thrustBearingOutsideDiameter
verticalShaftHolderPivotPoint(outsideDiameter = thrustBearingOutsideDiameter);