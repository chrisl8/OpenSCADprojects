// Load in some defaults
include <parameters/commonParameters.scad>;

//include <TardisConsole-Parameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
verticalPipeInsideDiameter = verticalPipeInsideDiameter_0_50pvc;

include <modules/jointModule.scad>;

module lowerBaseJoint(joint_location_in_degrees)
{
  translate_x = (BaseRadius) * cos(joint_location_in_degrees);
  translate_y = (BaseRadius) * sin(joint_location_in_degrees);

  jointLegs = [
    // Center Leg
    legInstance(rotation = [0, 90, 0], insideDiameter = horizontalPipeInsideDiameter_0_50pvc, flatBottom = true, pinHole = true),
    // Perimiter Legs
    legInstance(rotation = [0, 90, - (TableOutsideJointAngle / 2)], insideDiameter = horizontalPipeInsideDiameter_0_50pvc, flatBottom = true, triangleSupport = [0, - 75, 0]),
    legInstance(rotation = [0, 90, + (TableOutsideJointAngle / 2)], insideDiameter =
    horizontalPipeInsideDiameter_0_50pvc, flatBottom
    = true),
    // Upright Leg
    legInstance(rotation = [0, 0, 0], insideDiameter = verticalPipeInsideDiameter_0_50pvc, triangleSupport = [
      1, 0, 0, 0, 0]),
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

// Only uncomment for testing thsi single file alone
// Normally leave commented for use in other files.
//lowerBaseJoint(TableCornerSpacingInDegrees * i);
