// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
walkerAnkleShaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <modules/jointModule.scad>;

// Keeping this as close as possible,
// because if it is any further away, the two pipes (the one in here and the shaft) create a nasty pinch point
// Keeping them close prevents that. I think 1/4 inch is the minimum considered a pinch point.
horizontalJointOffset = 35.8;

module clearShaft()
{
    // Clear shaft
    // The -0.01 ensures that the end of the tube is clear.
    translate([0, 0, - (horizontalPipeInsideDiameter_0_50pvc / 2) - jointWallThickness - 0.01])
        cylinder(h = jointLegLength, d = walkerAnkleShaftPipeInsideDiameter);
}

// TODO: We could add a bearing to the shaft holder

module walkerFootAnkle(sideLabelText, reverseText = false) {
    difference()
        {
            union()
                {
                    ankleJointLength = 80;
                    // Slightly longer to ensure pin hole is easy to reach and drill.
                    upright = [
                        legInstance(rotation = [0, 90, 0], insideDiameter = horizontalPipeInsideDiameter_0_50pvc,
                        flatBottom
                        = true, pinHole = true, length = ankleJointLength + 20, labelText = sideLabelText, reverseText =
                        reverseText)];
                    joint(upright, horizontalPipeInsideDiameter_0_50pvc, false);

                    horizontal = [
                            [[0, 0, 0], verticalPipeInsideDiameter_0_50pvc, false, true, 75],
                        ];
                    translate([horizontalJointOffset, 0, 0])
                        rotate([0, 0, 180]) joint(horizontal, horizontalPipeInsideDiameter_0_50pvc, false);

                    // NOTE: Keeping pin holes oriented front to back to avoid any possibility of
                    // pins or nuts interfearing with the legs as they rotate,
                    // although this will make them difficult to drill from both sides.
                    footBack = [
                        legInstance(rotation = [0, 90, - walkerAnkleBackAngle], insideDiameter =
                        horizontalPipeInsideDiameter_0_50pvc, flatBottom = true, pinHole = 90,
                        length = ankleJointLength, triangleSupport = [25, - (walkerAnkleBackAngle * 1.5), 60], labelText
                        = "B", reverseText = reverseText),
                        ];
                    joint(footBack, horizontalPipeInsideDiameter_0_50pvc, false);

                    footFront = [
                        legInstance(rotation = [0, 90, walkerAnkleFrontAngle], insideDiameter =
                        horizontalPipeInsideDiameter_0_50pvc, flatBottom = true, pinHole = 90,
                        length = ankleJointLength, triangleSupport = [25, (- walkerAnkleFrontAngle * 0.5), 60],
                        labelText = "F", reverseText = reverseText),
                        ];
                    joint(footFront, horizontalPipeInsideDiameter_0_50pvc, false);

                    // Extra triangle supports
                    horizontalSupportTriangleSize = 40;
                    rotate([- 90, 270, 0])
                        translate([10, 49, 0])
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

}

// NOTE: If walkerFootCenterOffset is set to 0, these should be the same, but test first!

// Left Side
//walkerFootAnkle("Left");

// Right Side
mirror([0, 1, 0])
    walkerFootAnkle("Right", true);
