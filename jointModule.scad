// Modules
// legs is a vector of legs,
// each leg is a vector containing:
// vector of the joint rotation
// horizontalPipeInsideDiameter
// Optional Boolean requesting addition of a flat bottom
// Optional Boolean or number requesting a hole drilled near the end,
//      If it is a number, this is the angle at which it should be drilled.
//      For historical reasons, 0 and true are equivalent
//      Use false when you need to skip this but still add another vector entry
// i.e. [[x, y, z], horizontalPipeInsideDiameter]

/*
i.e.
jointLegs = [
        [[0, 90, 0], horizontalPipeInsideDiameter, true, true],
        [[90, 90, 0], horizontalPipeInsideDiameter, true, 45],
        [[90, 90, 180], horizontalPipeInsideDiameter, true, 90],
    ];

 */
module joint(legs, sphereJointInsideDiameter, closeUpWithSphere)
{
    difference()
        {
            // Build
            union() color(JointColor)
                {
                    for (leg = legs) {
                        thisJointLegLength = len(leg) > 4 && leg[4] != false ? leg[4] : jointLegLength;
                        rotate(leg[0]) cylinder(
                        h = thisJointLegLength,
                        r = (leg[1] + jointWallThickness * 2) / 2);
                        // Add flat bottom
                        if (leg[2]) {
                            rotate(leg[0])
                                translate([
                                        (leg[1] / 2) + (jointWallThickness / 2),
                                    0,
                                        thisJointLegLength / 2
                                    ])
                                    cube([
                                        jointWallThickness,
                                        // The 0.4 is a guess at width. A parameter would probably be better.
                                            leg[1] * 0.5,
                                        thisJointLegLength
                                        ],
                                    center = true);
                            // Add a cylinder at the end of the leg to close any gap between leg flats
                            // This also creates a solid floor in case the sphere is so big
                            // that the cut below cuts off the bottom of it.
                            rotate(leg[0])
                                rotate([0, 90, 0])
                                    translate([
                                        0,
                                        0,
                                            leg[1] / 2,
                                        ])
                                        cylinder(h = jointWallThickness, r = (leg[1] * 0.5) / 2);
                        }

                        // Triangles for improving stength
                        if (len(leg) > 5 && leg[5] != false) {
                            thisTriangleSize = leg[5] == true ? 50 : leg[5];
                            rotate([0, 0, leg[0][0] - 90])
                                linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                                    polygon(points = [[0, thisTriangleSize], [0, 0], [thisTriangleSize, 0]],
                                    paths =
                                        [[0, 1, 2]]);
                        }
                    }

                    if (closeUpWithSphere)
                    // Use a Sphere to close up the gap between the pipes.
                    // This is kinda hacky, but it looks good to me and does the job.
                        sphere(d = sphereJointInsideDiameter + jointWallThickness * 2);

                }

            // Hollow out
            union()
                {
                    for (leg = legs) {
                        thisJointLegLength = len(leg) > 4 && leg[4] != false ? leg[4] : jointLegLength;
                        // The -0.01 ensures that the end of the tube is clear.
                        rotate(leg[0]) translate([0, 0, - 0.01]) cylinder(
                        h = thisJointLegLength + 0.02, r = leg[1] / 2);

                        // IF a flat bottom was added, also add a "cut" to ensure nothing
                        // else in the part extends below this flat bottom.
                        if (leg[2]) {
                            rotate(leg[0])
                                translate([
                                        (leg[1] / 2) + (jointWallThickness * 2),
                                    0,
                                        thisJointLegLength / 2
                                    ])
                                    cube([
                                        // The 0.00001 just ensures it doesn't clip the flat on the legs at all.
                                                jointWallThickness * 2 - 0.00001,
                                            leg[1] * 2,
                                            thisJointLegLength * 2
                                        ],
                                    center = true);
                        }
                        if (len(leg) > 3 && leg[3] != false) {
                            // Make a hole near the end of the leg for pinning
                            echo("Drilling Pinhole");
                            // The -0.01 ensures that the end of the tube is clear.
                            rotate([leg[0][0] + 90, leg[0][1], leg[0][2]]) translate([0,
                                    thisJointLegLength - jointPinHoleOffset, 0]) rotate([0, leg[3] == true ? 0 : leg[3], 0]) cylinder(
                            h = thisJointLegLength + 0.02, d = jointPinningHoleDiameter, center = true);
                        }
                    }

                    if (closeUpWithSphere) {
                        // Hollow out the sphere
                        sphere(d = sphereJointInsideDiameter);
                    }

                }
        }
}
