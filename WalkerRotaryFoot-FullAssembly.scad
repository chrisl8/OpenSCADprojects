include <regularPolygonOutsideJoint.scad>;
include<WalkerRotaryFoot-Top-ShaftHolder.scad>;
include<WalkerRotaryFoot-Lower-ShaftHolder.scad>;

walkerRotaryFootDiameter = 32 * inchesToMmConversionFactor;
walkerRotaryFootRadius = walkerRotaryFootDiameter / 2;
walkerRotaryFootHeight = 6 * inchesToMmConversionFactor;

walkerRotaryFootLegCount = 8;
walkerRotaryFootLegSpacingInDegrees = 360 / walkerRotaryFootLegCount;

walkerRotaryFootEdgeLength = sqrt(pow(walkerRotaryFootRadius, 2) + pow(walkerRotaryFootRadius, 2) - 2 * walkerRotaryFootRadius * walkerRotaryFootRadius * cos(
walkerRotaryFootLegSpacingInDegrees));

for (i = [0:walkerRotaryFootLegCount - 1]) {
    // Bottom of Foot
    rotate([0, 0, walkerRotaryFootLegSpacingInDegrees * i])
        translate([0, walkerRotaryFootRadius, 0])
            rotate([0, 0, walkerRotaryFootLegSpacingInDegrees * 2])
                regularPolygonOutsideJoint(legCount = 8, legLength = 65);

    // Bottom Spokes
    color(PipeColor)
        rotate([0, 90, walkerRotaryFootLegSpacingInDegrees * i])
            cylinder(h = walkerRotaryFootRadius, r = verticalPipeInsideDiameter_0_50pvc / 2);

    // Bottom Outside Perimiter
    color(PipeColor)
        rotate([90, 0, walkerRotaryFootLegSpacingInDegrees * i])
            translate([walkerRotaryFootRadius, 0, 0])
                rotate([0, -walkerRotaryFootLegSpacingInDegrees /2, 0])
                    cylinder(h = walkerRotaryFootEdgeLength, r = verticalPipeInsideDiameter_0_50pvc / 2);

    // Uprights
    color(PipeColor)
        rotate([0, 0, walkerRotaryFootLegSpacingInDegrees * i])
            translate([0, walkerRotaryFootRadius, 0])
                cylinder(h = walkerRotaryFootHeight, r = verticalPipeInsideDiameter_0_50pvc / 2);

    // Top of foot
    translate([0, 0, walkerRotaryFootHeight])
        rotate([180, 0, 0])
            rotate([0, 0, walkerRotaryFootLegSpacingInDegrees * i])
                translate([0, walkerRotaryFootRadius, 0])
                    rotate([0, 0, walkerRotaryFootLegSpacingInDegrees * 2])
                        regularPolygonOutsideJoint(legCount = 8, legLength = 65);

    // Top Spokes
    color(PipeColor)
        translate([0, 0, walkerRotaryFootHeight])
            rotate([0, 90, walkerRotaryFootLegSpacingInDegrees * i])
                cylinder(h = walkerRotaryFootRadius, r = verticalPipeInsideDiameter_0_50pvc / 2);

    // Top Outside Perimiter
    color(PipeColor)
        translate([0, 0, walkerRotaryFootHeight])
        rotate([90, 0, walkerRotaryFootLegSpacingInDegrees * i])
            translate([walkerRotaryFootRadius, 0, 0])
                rotate([0, -walkerRotaryFootLegSpacingInDegrees /2, 0])
                    cylinder(h = walkerRotaryFootEdgeLength, r = verticalPipeInsideDiameter_0_50pvc / 2);
}

translate([0, 0, walkerRotaryFootHeight])
    WalkerRotaryFootTopShaftHolder();

WalkerRotaryFootLowerShaftHolder(8);
