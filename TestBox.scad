// ******************************************
// To Export a part for printing:
// If there is one command per part,
// prefix it with ! to say "only show this",
// otherwise, there should be a non-loop
// entry commented out that you can use.
// ******************************************

// Resoution
// This is perfect for 3D Printing,
// but you may want to comment it out while working to improve preview
// performance
$fa = 1;
$fs = 0.4;

// All measurements in millimeters

// Original designs specs:
// Table Diameter: 1408.735 mm
// Table Surface Triangle riser Inner Height: 160.00 mm
// Original base diameter: 704.367 mm

// Pipe types and measurements:jointInsideDiameter * 2
// Legs (upright): 1" PVC
// Table (flat): 3/4" PVC
//      Same for Base base.
// Table Surface (raised triangles): 1/2" PVC
// Center "hold down": 1/2" PVC

// Parameters
tableDiameter = 1410;
tableSideCount = 4;
jointLegLength = 50;
jointInsideDiameter = 21.6;
tableLegInsideJointDiameter = 21.6;
jointWallThickness = 2;
tableSurfaceJointAngle = 45;

RenderPipes = false;

// These are more for the full visual, than the actual printed parts,
// but it will demonstrate problems like overlapping parts.
tableRadius = tableDiameter / 2; // Does not affect printed parts.
tableHeight = 250; // Does not affect printed parts.

// Colors
JointColor = "CornflowerBlue";
PipeColor = "Pink";

// Calculated Constants
BaseRadius = tableRadius / 3;
PipeInsertDistance = jointLegLength * .6;
TableCornerSpacingInDegrees = 360 / tableSideCount;
TableOutsideJointAngle = (tableSideCount - 2) * 180 / tableSideCount;
PipeSize = jointInsideDiameter / 2 - .01;
//PipeSize = jointInsideDiameter * 2; // Pool Noodles for seeing them better.

// Parts
// Table base joints
for (i = [0:tableSideCount - 1]) {
    tableBaseJoint(TableCornerSpacingInDegrees * i);
}
 !tableBaseJoint(0); // Also set RenderPipes to false

// table base center
translate([ 0, 0, -tableHeight ]) tableCenter(tableSideCount);

// Table base t_joints
for (i = [0:tableSideCount - 1]) {
    tableLegT_Joint(TableCornerSpacingInDegrees * i);
}
// !tableLegT_Joint(0);

// Table corner joints
for (i = [0:tableSideCount - 1]) {
    tableCorner(TableCornerSpacingInDegrees * i);
}
// !tableCorner(0); // Also set RenderPipes to false

// Lower table surface center
tableCenter(tableSideCount);

// Modules
// legs is a vector of legs,
// each leg is a vector containing:
// vector of the joint rotation
// jointInsideDiameter
// i.e. [[x, y, z], jointInsideDiameter]
module joint(legs, sphereJointInsideDiameter)
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

            // Use a Sphere to close up the gap between the pipes.
            // This is kinda hacky, but it looks good to me and does the job.
            sphere(d = sphereJointInsideDiameter + jointWallThickness * 2);
        }

        // Hollow out
        union()
        {
            for (leg = legs) {
                // The -0.01 ensures that the end of the tube is clear.
                rotate(leg[0]) translate([ 0, 0, -0.01 ]) cylinder(
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

            }

            // Hollow out the sphere
            sphere(d = sphereJointInsideDiameter);

        }
    }
}

module tableBaseJoint(joint_location_in_degrees)
{
    translate_x = (BaseRadius) * cos(joint_location_in_degrees);
    translate_y = (BaseRadius) * sin(joint_location_in_degrees);

    jointLegs = [
        [[ 0, 90, -(TableOutsideJointAngle / 2) ], jointInsideDiameter, true],
        [[ 0, 90, +(TableOutsideJointAngle / 2) ], jointInsideDiameter, true],
        [[ 0, 0, 0 ], tableLegInsideJointDiameter],
        [[ 0, 90, 0 ], jointInsideDiameter, true],
    ];

    translate([ translate_x, translate_y, -tableHeight ])
        rotate([ 0, 0, 180 + joint_location_in_degrees ]) joint(jointLegs, tableLegInsideJointDiameter);

    if(RenderPipes){
        // TODO: Properly calculate pipe insert distance and length and echo them
        color(PipeColor)translate([ translate_x, translate_y, -tableHeight + PipeInsertDistance ])cylinder(r=PipeSize, h= tableHeight - PipeInsertDistance * 2);
        color(PipeColor)translate([ translate_x, translate_y, -tableHeight ])rotate([0,90,180 + joint_location_in_degrees])translate([0, 0, jointLegLength/2])cylinder(r=PipeSize, h= BaseRadius - (jointLegLength * 2) + (PipeInsertDistance * 2));
        baseEdgeLength = sqrt(pow(BaseRadius, 2) + pow(BaseRadius, 2) - 2 * BaseRadius * BaseRadius * cos(TableCornerSpacingInDegrees));

        color(PipeColor)
        translate([ translate_x, translate_y, -tableHeight ])
        rotate([0,90, 180 + joint_location_in_degrees - (TableOutsideJointAngle / 2)])
        translate([0, 0, jointLegLength/2])
        cylinder(r=PipeSize, h= baseEdgeLength - jointLegLength);
    }
}

module tableLegT_Joint(joint_location_in_degrees) {
    translate_x = (BaseRadius) * cos(joint_location_in_degrees);
    translate_y = (BaseRadius) * sin(joint_location_in_degrees);

    jointLegs = [
        [[ 0, 90, 0 ], jointInsideDiameter],
        [[ 0, 90, 180 ], jointInsideDiameter],
        [[ 0, 180, 0 ], jointInsideDiameter],
    ];

    translate([ translate_x, translate_y, 0 ])
        rotate([ 0, 0, 180 + joint_location_in_degrees ]) joint(jointLegs, jointInsideDiameter);
}

module tableCorner(joint_location_in_degrees)
{
    translate_x = tableRadius * cos(joint_location_in_degrees);
    translate_y = tableRadius * sin(joint_location_in_degrees);

    jointLegs = [
        [[ 0, 90, -(TableOutsideJointAngle / 2) ], jointInsideDiameter, true],
        [[ 0, 90, +(TableOutsideJointAngle / 2) ], jointInsideDiameter, true],
        [[ 0, tableSurfaceJointAngle, 0 ], jointInsideDiameter],
        [[ 0, 90, 0 ], jointInsideDiameter, true],
    ];

    translate([ translate_x, translate_y, 0 ])
        rotate([ 0, 0, 180 + joint_location_in_degrees ]) joint(jointLegs, jointInsideDiameter);

    if(RenderPipes){
        // TODO: Properly calculate pipe insert distance and length and echo them
        pipeLength = tableRadius - (jointLegLength * 2) + (PipeInsertDistance * 2);
        color(PipeColor)translate([ translate_x, translate_y, 0 ])rotate([0,90,180 + joint_location_in_degrees])translate([0, 0, jointLegLength - PipeInsertDistance])cylinder(r=PipeSize, h= pipeLength);
        tableEdgeLength = sqrt(pow(tableRadius, 2) + pow(tableRadius, 2) - 2 * tableRadius * tableRadius * cos(TableCornerSpacingInDegrees));
        color(PipeColor)translate([ translate_x, translate_y, 0 ])rotate([0,90, 180 + joint_location_in_degrees - (TableOutsideJointAngle / 2)])translate([0, 0, jointLegLength/2])cylinder(r=PipeSize, h= tableEdgeLength - PipeInsertDistance * 2);
    }
}

module tableCenter(tableSideCount)
{
    jointLegs = [for (i = [0:tableSideCount -1]) [[0, 90, TableCornerSpacingInDegrees * i], jointInsideDiameter]];
    joint(jointLegs, tableLegInsideJointDiameter);
}
