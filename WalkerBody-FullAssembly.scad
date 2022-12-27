include <parameters/commonParameters.scad>;

include <WalkerBody-Lower-CenterShaftRotationPoint.scad>

include <WalkerBody-BoxCornerJoint-withX.scad>

walkerBoxSideCount = 4;
walkerBoxWidth = 32 * inchesToMmConversionFactor;

// Angles
// This site is great for visualizing what you want: https://www.blocklayer.com/trig/scaleneeng.aspx
// Use this site to check your math and results: https://www.calculator.net/right-triangle-calculator.html
echo("=======================================================");
echo("Walker Box Parameters");
echo("walkerBoxWidth", walkerBoxWidth);
echo("=======================================================");
echo("Diagonal:");
echo("walkerBoxWidth (a)", walkerBoxWidth);
echo("walkerBoxWidth (b)", walkerBoxWidth);
walkerBoxDiagonalLength = sqrt(pow(walkerBoxWidth, 2) + pow(walkerBoxWidth, 2));
echo("walkerBoxDiagonalLength (c)", walkerBoxDiagonalLength);
echo("=======================================================");

walkerBoxSideSpacingInDegrees = 360 / walkerBoxSideCount;

module WalkerBodyFullAssembly() {
    WalkerBodyLowerCenterShaftRotationPoint();

    for (i = [0:walkerBoxSideCount - 1]) {
        // Lower BoxCornerJoints
        rotate([0, 0, walkerBoxSideSpacingInDegrees * i])
            translate([0, walkerBoxDiagonalLength / 2, 0])
                rotate([0, 0, walkerBoxSideSpacingInDegrees * 1.5])
                    BoxCornerJoint();

        // Bottom Cross pieces
        color(PipeColor)
            rotate([90, 0, walkerBoxSideSpacingInDegrees * i])
                cylinder(h = walkerBoxDiagonalLength / 2, r = verticalPipeInsideDiameter_0_50pvc / 2);

        // Bottom Outside Parimiter
        color(PipeColor)
            rotate([90, 0, walkerBoxSideSpacingInDegrees * i])
                translate([walkerBoxDiagonalLength / 2, 0, 0])
                    rotate([0, - walkerBoxSideSpacingInDegrees / 2, 0])
                        cylinder(h = walkerBoxWidth, r = verticalPipeInsideDiameter_0_50pvc / 2);
    }
}