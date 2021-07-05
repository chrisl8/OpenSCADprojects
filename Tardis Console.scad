include <commonParameters.scad>;

// ******************************************
// To Export a part for printing:
// If there is one command per part,
// prefix it with ! to say "only show this",
// otherwise, there should be a non-loop
// entry commented out that you can use.
// ******************************************

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
tableSideCount = 6;
jointLegLength = 50;
jointInsideDiameter = 10;
tableLegInsideJointDiameter = 14;
jointWallThickness = 2;
tableSurfaceJointAngle = 45;

RenderPipes = false;

// These are more for the full visual, than the actual printed parts,
// but it will demonstrate problems like overlapping parts.
tableRadius = tableDiameter / 2; // Does not affect printed parts.
tableHeight = 250; // Does not affect printed parts.

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
// !tableBaseJoint(0); // Also set RenderPipes to false

// table base center
translate([0, 0, - tableHeight]) tableCenter(tableSideCount);

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

include <jointModule.scad>;

module tableBaseJoint(joint_location_in_degrees)
{
    translate_x = (BaseRadius) * cos(joint_location_in_degrees);
    translate_y = (BaseRadius) * sin(joint_location_in_degrees);

    jointLegs = [
            [[0, 90, - (TableOutsideJointAngle / 2)], jointInsideDiameter, true],
            [[0, 90, + (TableOutsideJointAngle / 2)], jointInsideDiameter, true],
            [[0, 0, 0], tableLegInsideJointDiameter],
            [[0, 90, 0], jointInsideDiameter, true],
        ];

    translate([translate_x, translate_y, - tableHeight])
        rotate([0, 0, 180 + joint_location_in_degrees]) joint(jointLegs, tableLegInsideJointDiameter, true);

    if (RenderPipes) {
        // TODO: Properly calculate pipe insert distance and length and echo them
        color(PipeColor)
            translate([translate_x, translate_y, - tableHeight + PipeInsertDistance])
                cylinder(r = PipeSize,
                h = tableHeight - PipeInsertDistance * 2);

        color(PipeColor)
            translate([translate_x, translate_y, - tableHeight])
                rotate([0, 90, 180 +
                    joint_location_in_degrees])
                    translate([0, 0, jointLegLength / 2])
                        cylinder(r = PipeSize, h = BaseRadius - (
                            jointLegLength * 2) + (PipeInsertDistance * 2));

        baseEdgeLength = sqrt(pow(BaseRadius, 2) + pow(BaseRadius, 2) - 2 * BaseRadius * BaseRadius * cos(
        TableCornerSpacingInDegrees));

        color(PipeColor)
            translate([translate_x, translate_y, - tableHeight])
                rotate([0, 90, 180 + joint_location_in_degrees - (TableOutsideJointAngle / 2)])
                    translate([0, 0, jointLegLength / 2])
                        cylinder(r = PipeSize, h = baseEdgeLength - jointLegLength);
    }
}

module tableLegT_Joint(joint_location_in_degrees) {
    translate_x = (BaseRadius) * cos(joint_location_in_degrees);
    translate_y = (BaseRadius) * sin(joint_location_in_degrees);

    jointLegs = [
            [[0, 90, 0], jointInsideDiameter],
            [[0, 90, 180], jointInsideDiameter],
            [[0, 180, 0], jointInsideDiameter],
        ];

    translate([translate_x, translate_y, 0])
        rotate([0, 0, 180 + joint_location_in_degrees]) joint(jointLegs, jointInsideDiameter);
}

module tableCorner(joint_location_in_degrees)
{
    translate_x = tableRadius * cos(joint_location_in_degrees);
    translate_y = tableRadius * sin(joint_location_in_degrees);

    jointLegs = [
            [[0, 90, - (TableOutsideJointAngle / 2)], jointInsideDiameter, true],
            [[0, 90, + (TableOutsideJointAngle / 2)], jointInsideDiameter, true],
            [[0, tableSurfaceJointAngle, 0], jointInsideDiameter],
            [[0, 90, 0], jointInsideDiameter, true],
        ];

    translate([translate_x, translate_y, 0])
        rotate([0, 0, 180 + joint_location_in_degrees]) joint(jointLegs, jointInsideDiameter, true);

    if (RenderPipes) {
        // TODO: Properly calculate pipe insert distance and length and echo them
        pipeLength = tableRadius - (jointLegLength * 2) + (PipeInsertDistance * 2);
        color(PipeColor)translate([translate_x, translate_y, 0])rotate([0, 90, 180 + joint_location_in_degrees])
            translate([0, 0, jointLegLength - PipeInsertDistance])cylinder(r = PipeSize, h = pipeLength);
        tableEdgeLength = sqrt(pow(tableRadius, 2) + pow(tableRadius, 2) - 2 * tableRadius * tableRadius * cos(
        TableCornerSpacingInDegrees));
        color(PipeColor)translate([translate_x, translate_y, 0])rotate([0, 90, 180 + joint_location_in_degrees - (
            TableOutsideJointAngle / 2)])translate([0, 0, jointLegLength / 2])cylinder(r = PipeSize, h = tableEdgeLength
            - PipeInsertDistance * 2);
    }
}

module tableCenter(tableSideCount)
{
    jointLegs = [for (i = [0:tableSideCount - 1]) [[0, 90, TableCornerSpacingInDegrees * i], jointInsideDiameter]];
    joint(jointLegs, tableLegInsideJointDiameter);
}
