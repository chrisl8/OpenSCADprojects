include <parameters/commonParameters.scad>;

include <TardisConsole-Parameters.scad>;

include <regularPolygonOutsideJoint.scad>;

include<WalkerRotaryFoot-Lower-ShaftHolder.scad>;

include<TardisConsole-InnerUpperTableCenter-TimeRotorHolder.scad>;

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

// Bottom of Table Base
translate([0, 0, - tableHeight]) {
  // Bottom of Table Base Center
  WalkerRotaryFootLowerShaftHolder(6);
  // Bottom of Table Base Outside joints
  for (i = [0:tableSideCount - 1]) {
    rotate([0, 0, (TableCornerSpacingInDegrees * i) + 90])
      translate([0, BaseRadius, 0])
        rotate([0, 0, 90]) {
          regularPolygonOutsideJoint(legCount = tableSideCount, legLength = 65);
          if (RenderPipes) {
            // Upright Legs
            color(PipeColor)
              rotate([0, 0, 0])
                cylinder(r = PipeSize, h = tableHeight + 100);
            // Radial pipes
            color(PipeColor)
              rotate([0, 90, 180])
                cylinder(r = PipeSize, h = BaseRadius - 15);
            // Outside Edge
            color(PipeColor)
              rotate([90, 0, 90 - ((tableSideCount - 2) * 180) / tableSideCount])
                cylinder(r = PipeSize, h = BaseRadius - 15);
          }
        }
  }
}

// Lower table surface center Time Roter Base
module buildTimeRotorBase() {
  WalkerRotaryFootLowerShaftHolder(6, 100);
  translate([0, 0, 56])
    TimeRotorHolder(legCount = 6, insideDiameter = 180, outsideRingDiameter = 190, ringHeight = 50, ringPosition = - 44, legAngle = tableSurfaceJointAngle, legLength = 120, includeLegs = false);
}
buildTimeRotorBase();

// Table Base Upper T Joints
for (i = [0:tableSideCount - 1]) {
  tableLegT_Joint(TableCornerSpacingInDegrees * i);
}
//!tableLegT_Joint(0);

tableUpperT_JointRise = 145.25; // Eyballed this for visualizing.
translate([0, 0, tableUpperT_JointRise])
  for (i = [0:tableSideCount - 1]) {
    tableUpperT_Joint(TableCornerSpacingInDegrees * i);
  }
//!tableUpperT_Joint(0);

// Table Top Outside Corner joints
for (i = [0:tableSideCount - 1]) {
  tableCornerJoint(TableCornerSpacingInDegrees * i);
}
//!tableCornerJoint(0);

include <modules/jointModule.scad>;

include <TardisConsole-LowerBaseJoint.scad>

module tableLegT_Joint(joint_location_in_degrees) {
  translate_x = (BaseRadius) * cos(joint_location_in_degrees);
  translate_y = (BaseRadius) * sin(joint_location_in_degrees);

  jointLegs = [
    // Horizontal Legs
    legInstance(rotation = [0, 0, 0], insideDiameter = jointInsideDiameter),
    legInstance(rotation = [0, 90, 0], insideDiameter = jointInsideDiameter),
    legInstance(rotation = [0, 90, 180], insideDiameter = jointInsideDiameter),
    // Verticle Leg
    legInstance(rotation = [0, 180, 0], insideDiameter = jointInsideDiameter),
    ];

  translate([translate_x, translate_y, 0])
    rotate([0, 0, 180 + joint_location_in_degrees]) joint(jointLegs, jointInsideDiameter);
}

module tableUpperT_Joint(joint_location_in_degrees) {
  translate_x = (BaseRadius) * cos(joint_location_in_degrees);
  translate_y = (BaseRadius) * sin(joint_location_in_degrees);

  jointLegs = [
    // Horizontal Legs
    legInstance(rotation = [0, tableSurfaceJointAngle, 0], insideDiameter = jointInsideDiameter),
    legInstance(rotation = [0, 180 + tableSurfaceJointAngle, 0], insideDiameter = jointInsideDiameter),
    // Verticle Leg
    legInstance(rotation = [0, 180, 0], insideDiameter = jointInsideDiameter),
    ];

  translate([translate_x, translate_y, 0])
    rotate([0, 0, 180 + joint_location_in_degrees]) joint(jointLegs, jointInsideDiameter);
}

module tableCornerJoint(joint_location_in_degrees)
{
  translate_x = tableRadius * cos(joint_location_in_degrees);
  translate_y = tableRadius * sin(joint_location_in_degrees);

  jointLegs = [
    legInstance(rotation = [0, 90, - (TableOutsideJointAngle / 2)], insideDiameter = jointInsideDiameter, flatBottom
    = true, triangleSupport = [0, - 75, 60], length = 75, pinHole = true),
    legInstance(rotation = [0, 90, + (TableOutsideJointAngle / 2)], insideDiameter = jointInsideDiameter, flatBottom
    = true, length = 75, pinHole = true),
    // If you extend this to run longer you can test to see if it lines up with the Upper T Joint and the Time Rotor Holder
    legInstance(rotation = [0, 90, 0], insideDiameter = jointInsideDiameter, flatBottom = true, triangleSupport = [0
      , - 15, 60], length = 150, pinHole = true),
    legInstance(rotation = [0, tableSurfaceJointAngle, 0], insideDiameter = jointInsideDiameter, length = 100, pinHole = true),
    ];

  // Comment this out to see how the pipes meet in the center to set lenghts.
  // Set the first of "true, true" to false to open up the end to see inside.
    translate([translate_x, translate_y, 0])
      rotate([0, 0, 180 + joint_location_in_degrees]) joint(jointLegs, jointInsideDiameter, true, true);

  if (RenderPipes) {

    // Table Bottom
    color(PipeColor)
      translate([translate_x, translate_y, 0])
        rotate([0, 90, 180 + joint_location_in_degrees])
          translate([0, 0, tableLowerRadiusPipeStartingPoint])
            cylinder(r = PipeSize, h = tableLowerRadiusPipeLength);

    // Table Edges
    color(PipeColor)
      translate([translate_x, translate_y, 0])
        rotate([0, 90, 180 + joint_location_in_degrees - (TableOutsideJointAngle / 2)])
          translate([0, 0, tableEdgePipeStartingPoint])
            cylinder(r = PipeSize, h = tableEdgePipeLength);

    // Table Upper Surface
    color(PipeColor)
      translate([translate_x, translate_y, 0])
        rotate([0, tableSurfaceJointAngle, 180 + joint_location_in_degrees])
          // translate([0, 0, 0]) // 0, 0, 0 Should be starting from the furthest point this pipe can fit into this joint. You can turn off the all on the end of the joint to see it.
          cylinder(r = PipeSize, h = tableUpperSurfacePipeLength); // 50 was eyebaalled to get pipes not to stick into time rotor.
  }
}

module tableCenter(tableSideCount)
{
  jointLegs = [for (i = [0:tableSideCount - 1]) legInstance(rotation = [0, 90, TableCornerSpacingInDegrees * i],
  insideDiameter = jointInsideDiameter, flatBottom = true, triangleSupport = [0
    , - 15 + TableCornerSpacingInDegrees * i, 30])];
  joint(jointLegs, tableLegInsideJointDiameter);
}

module buildTimeRotorHolder() {
  timeRotorHolderStartingHeight = 218; // Eyeballed this for visualization.
  translate([0, 0, timeRotorHolderStartingHeight]) {
    difference() {
      // ringPosition is eyeballed to sit flat on the print plate level with the end of the pipes.
      TimeRotorHolder(legCount = 6, insideDiameter = 180, outsideRingDiameter = 190, ringHeight = 60, ringPosition = - 50, legAngle = tableSurfaceJointAngle, legLength = 150);
      union() {
        difference() {
          // Cut this off to fit on the print bed
          cutoutHeight = 200; // 200
          cube(size = [350, 310, cutoutHeight],
          center = true);
          cube(size = [250, 210, cutoutHeight + 1],
          center = true);
        }
        // Cut the bottom off to ensure that the bottom of the ring and all pipes touch the print bed
        bottomOfTimeRotorHolderCutoff = - 97.5;
        translate([0, 0, bottomOfTimeRotorHolderCutoff])
          cube(size = [350, 310, 100], center = true);
      }
    }
  }
}
buildTimeRotorHolder();
