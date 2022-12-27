// Print at 100% infill

// Load in some defaults
include <parameters/commonParameters.scad>;

shaftDiameter = 6.2;
hubLength = 20;
hubDiameter = 18.5;
screwHoleDiameter = 3.1; // Perfect
screwHolePosition = (hubDiameter / 2) - 3;

difference() {
    cylinder(d = hubDiameter, h = hubLength, center = true);
    union() {
        cylinder(d = shaftDiameter, h = hubLength + 0.2, center = true);
        translate([0, screwHolePosition, 0])
            cylinder(d = screwHoleDiameter, h = hubLength + 0.2, center = true);
        rotate([0, 0, 120])
            translate([0, screwHolePosition, 0])
                cylinder(d = screwHoleDiameter, h = hubLength + 0.2, center = true);
        rotate([0, 0, 120 * 2])
            translate([0, screwHolePosition, 0])
                cylinder(d = screwHoleDiameter, h = hubLength + 0.2, center = true);
    }
}

rotate([0, 0, 120 / 2])
    translate([0, 3.5, 0])
        cube([6, 2, hubLength], center = true);