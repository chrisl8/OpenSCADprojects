// Load in some defaults
include <commonParameters.scad>;

// Pick what size pipes you are using
walkerAnkleShaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <jointModule.scad>;

// Just touches the shaft holder itself, to improve stability by printing as one part.
// Do double check that this looks OK in the slicer.
horizontalJointOffset = 39;

module clearShaft()
{
    // Clear shaft
    // The -0.01 ensures that the end of the tube is clear.
    translate([0, 0, - (horizontalPipeInsideDiameter_0_50pvc / 2) - jointWallThickness - 0.01])
        cylinder(h = jointLegLength, d = walkerAnkleShaftPipeInsideDiameter);
}

difference()
    {
        union()
            {
                ankleJointLength = 80;
                // Slightly longer to ensure pin hole is easy to reach and drill.
                upright = [
                        [[0, 90, 0], horizontalPipeInsideDiameter_0_50pvc, true, true, ankleJointLength + 20],
                    ];
                joint(upright, horizontalPipeInsideDiameter_0_50pvc, false);

                horizontal = [
                        [[0, 0, 0], verticalPipeInsideDiameter_0_50pvc, false, true, 75, true],
                    ];
                translate([horizontalJointOffset, 0, 0])
                    rotate([0, 0, 180]) joint(horizontal, horizontalPipeInsideDiameter_0_50pvc, false);

                // NOTE: Keeping pin holes oriented front to back to avoid any possibility of
                // pins or nuts interfearing with the legs as they rotate,
                // although this will make them difficult to drill from both sides.
                footBack = [
                        [[0, 90, - walkerAnkleBackAngle], horizontalPipeInsideDiameter_0_50pvc, true, 90,
                        ankleJointLength, [25, - (walkerAnkleBackAngle * 1.5), 60]],
                    ];
                joint(footBack, horizontalPipeInsideDiameter_0_50pvc, false);

                footFront = [
                        [[0, 90, walkerAnkleFrontAngle], horizontalPipeInsideDiameter_0_50pvc, true, 90,
                        ankleJointLength, [25, (- walkerAnkleFrontAngle * 0.5), 60]],
                    ];
                joint(footFront, horizontalPipeInsideDiameter_0_50pvc, false);

                // Extra triangle supports
                horizontalSupportTriangleSize = 40;
                rotate([- 90, 270, 0])
                    translate([10, 50, 0])
                        linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                            polygon(points = [[horizontalSupportTriangleSize, 0], [0, 0], [0,
                                horizontalSupportTriangleSize]],
                            paths =
                                [[0, 1, 2]]);
            }
        union()
            {
                clearingCylinderLength = 200;
                // The legs overlap, and the only way to have them empty on the inside is by doing
                // another clear here.

                // Clear upright
                rotate([0, 90, 0])
                    cylinder(h = clearingCylinderLength, d = horizontalPipeInsideDiameter_0_50pvc);

                // Clear footFront
                rotate([0, 90, walkerAnkleFrontAngle])
                    cylinder(h = clearingCylinderLength, d = horizontalPipeInsideDiameter_0_50pvc);

                // Clear footBack
                rotate([0, 90, - walkerAnkleBackAngle])
                    cylinder(h = 200, d = horizontalPipeInsideDiameter_0_50pvc);

                // Clear horizontal
                translate([horizontalJointOffset, 0, 0])
                    cylinder(h = clearingCylinderLength, d = horizontalPipeInsideDiameter_0_50pvc);

                clearShaft();
            }
    }

// Shaft
difference() {
    shaftLeg = [
            [[0, 0, 0], walkerAnkleShaftPipeInsideDiameter, false, false],
        ];
    translate([0, 0, - (horizontalPipeInsideDiameter_0_50pvc / 2) - jointWallThickness])
        rotate([0, 0, 0])
            joint(shaftLeg, walkerAnkleShaftPipeInsideDiameter, false);

    // Clear shaft (again)
    clearShaft();
}