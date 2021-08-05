include <parameters/commonParameters.scad>;

include <WalkerFoot-Ankle.scad>;


// NOTE: The pipes are shown extending to the CENTER of the parts,
//       because that is how the measurements are taken.
//       You will have to determine the actual lengths to cut each pipe by hand later,
//       or devise some way to calculate and ECHO it here.
//       The primary purpose of this is to display the parts and prove that they work together,
//       not to provide pipe lengths.

// TODO: Remember to comment out the internal run of the module on each included joint,
//       except for the ankle.

// Foot Front Pipe
color(PipeColor)
    rotate([0, 90, walkerAnkleFrontAngle])
        cylinder(h = walkerFootFrontTriangleTopLength, r = verticalPipeInsideDiameter_0_50pvc / 2);

include <WalkerFoot-FrontLowerJoint.scad>;
rotate([0, 0, walkerAnkleFrontAngle])
    translate([walkerFootFrontTriangleTopLength, 0, 0])
        rotate([0, 0, 0])
            walkerFootFrontLowerJoint();

// Foot Back Pipe
color(PipeColor)
    rotate([0, 90, - walkerAnkleBackAngle])
        cylinder(h = walkerFootBackTriangleTopLength, r = verticalPipeInsideDiameter_0_50pvc / 2);

include <WalkerFoot-BackLowerJoint.scad>;
rotate([0, 0, - walkerAnkleBackAngle])
    translate([walkerFootBackTriangleTopLength, 0, 0])
        rotate([0, 0, 0])
            walkerFootBackLowerJoint();

// Foot Bottom Pipe - It needs to be split into two, because it is offset
// Front
color(PipeColor)
    rotate([- 90, 0, 0])
        translate([walkerFootHeight, 0, 0])
            cylinder(h = walkerFootFrontLength, r = verticalPipeInsideDiameter_0_50pvc / 2);
// Back
color(PipeColor)
    rotate([90, 0, 0])
        translate([walkerFootHeight, 0, 0])
            cylinder(h = walkerFootBackLength, r = verticalPipeInsideDiameter_0_50pvc / 2);

// Upright Support
include <Tjoint.scad>
translate([walkerFootHeight, 0, 0])
    rotate([0, 0, 180])
        tJoint();