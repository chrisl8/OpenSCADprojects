// Modules
// legs is a vector of legs,
// each leg is a vector containing:
// vector of the joint rotation
// horizontalPipeInsideDiameter
// i.e. [[x, y, z], horizontalPipeInsideDiameter]
module joint(legs, sphereJointInsideDiameter, closeUpWithSphere)
{
    difference()
        {
            // Build
            union() color(JointColor)
                {
                    for (leg = legs) {
                        rotate(leg[0]) cylinder(
                        h = jointLegLength,
                        r = (leg[1] + jointWallThickness * 2) / 2);
                        // Add flat bottom
                        if (leg[2]) {
                            rotate(leg[0])
                                translate([
                                        (leg[1] / 2) + (jointWallThickness / 2),
                                    0,
                                        jointLegLength / 2
                                    ])
                                    cube([
                                        jointWallThickness,
                                        // The 0.4 is a guess at width. A parameter would probably be better.
                                            leg[1] * 0.5,
                                        jointLegLength
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
                        // The -0.01 ensures that the end of the tube is clear.
                        rotate(leg[0]) translate([0, 0, - 0.01]) cylinder(
                        h = jointLegLength + 0.02, r = leg[1] / 2);

                        // IF a flat bottom was added, also add a "cut" to ensure nothing
                        // else in the part extends below this flat bottom.
                        if (leg[2]) {
                            rotate(leg[0])
                                translate([
                                        (leg[1] / 2) + (jointWallThickness * 2),
                                    0,
                                        jointLegLength / 2
                                    ])
                                    cube([
                                        // The 0.00001 just ensures it doesn't clip the flat on the legs at all.
                                                jointWallThickness * 2 - 0.00001,
                                            leg[1] * 2,
                                            jointLegLength * 2
                                        ],
                                    center = true);
                        }
                        if (leg[3]) {
                            // Make a hole near the end of the leg for pinning
                            echo("Drilling Pinhole");
                            // The -0.01 ensures that the end of the tube is clear.
                            rotate([leg[0][0] + 90, leg[0][1], leg[0][2]]) translate([0, jointLegLength - 10, -
                            jointLegLength / 2]) cylinder(
                            h = jointLegLength + 0.02, d = jointPinningHoleDiameter);
                        }
                    }

                    if (closeUpWithSphere) {
                        // Hollow out the sphere
                        sphere(d = sphereJointInsideDiameter);
                    }

                }
        }
}
