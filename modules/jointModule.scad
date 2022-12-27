// Modules
// legs is a vector of legs,
//      each leg is a vector containing:
//      vector of the joint rotation
// horizontalPipeInsideDiameter
// Optional Boolean requesting addition of a flat bottom
// Optional Boolean or number requesting a hole drilled near the end,
//      If it is a number, this is the angle at which it should be drilled.
//      For historical reasons, 0 and true are equivalent
//      Use false when you need to skip this but still add another vector entry
// Option integer indicating an override for the length of this leg
// i.e. [[x, y, z], horizontalPipeInsideDiameter]

/*
i.e.
jointLegs = [
        [[0, 90, 0], horizontalPipeInsideDiameter, true, true],
        [[90, 90, 0], horizontalPipeInsideDiameter, true, 45],
        [[90, 90, 180], horizontalPipeInsideDiameter, true, 90, 500],
    ];

 */

// This function makes creating the array for the joint module much easier.
// Just name any parameters and skip those you don't care about and defaults will be injected.
// The only REQUIRED paremeter is the insideDiameter, although a suitable default could be added here (instead of 0, so technically it isn't required).
function legInstance(rotation = [0, 0, 0], insideDiameter = 0, flatBottom = false, pinHole = false, length = false,
triangleSupport = false, labelText = false, reverseText = false) = [rotation,
  insideDiameter, flatBottom, pinHole, length, triangleSupport, labelText, reverseText];

// Pinholes have to be further from the ends because the ends are cut off to fit in the print bed.
module joint(legs = [], sphereJointInsideDiameter = 0, closeUpWithSphere = false, addCircleToFlatBottom = false, jointPinHoleOffset = jointPinHoleOffset)
{
  difference()
    {
      // Build
      union() color(JointColor)
        {
          for (leg = legs) {
            thisJointLegLength = len(leg) > 4 && leg[4] != false ? leg[4] : jointLegLength;
            rotate(leg[0])
              cylinder(
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
                    // The 0.5 is a guess at width. A parameter would probably be better.
                      leg[1] * 0.5,
                    thisJointLegLength
                    ],
                  center = true);
            }

            // Triangles for improving stength
            if (len(leg) > 5 && leg[5] != false) {

              // TODO: Document this
              thisTrianglePointA = leg[5][0] ? leg[5][0] : 10;
              thisTriangleRotateZ = leg[5][1] ? leg[5][1] : leg[0][2] * 1.5;
              thisTrianglePointB = leg[5][2] ? leg[5][2] : 40;
              thisTriangleRotatex = leg[5][3] ? leg[5][3] : 90 - leg[0][1];
              thisTriangleRotateY = leg[5][4] ? leg[5][4] : 0;

              rotate([thisTriangleRotatex, thisTriangleRotateY, thisTriangleRotateZ])
                linear_extrude(height = 8, center = true, convexity = 10, twist = 0)
                  polygon(points = [[thisTrianglePointA, thisTrianglePointB], [0, 0], [
                    thisTrianglePointB, thisTrianglePointA]],
                  paths =
                    [[0, 1, 2]]);
            }
          }

          if (closeUpWithSphere)
          // Use a Sphere to close up the gap between the pipes.
          // This is kinda hacky, but it looks good to me and does the job.
            sphere(d = sphereJointInsideDiameter + jointWallThickness * 2);

          if (addCircleToFlatBottom)
          // Add a cylinder at the end of the leg to close any gap between leg flats
          // This also creates a solid floor in case the sphere is so big
          // that the cut below cuts off the bottom of it.
            rotate(legs[0][0])
              rotate([0, 90, 0])
                translate([
                  0,
                  0,
                    legs[0][1] / 2,
                  ])
                  cylinder(h = jointWallThickness, r = (legs[0][1] * 0.5) / 2);

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
              // The -0.01 ensures that the end of the tube is clear.
              rotate([leg[0][0] + 90, leg[0][1], leg[0][2]])
                translate([0,
                    thisJointLegLength - jointPinHoleOffset, 0])
                  rotate([0, leg[3] == true ? 0 : leg[3],
                    0])
                    cylinder(
                    h = leg[1] + jointWallThickness * 2 + 0.01, d = jointPinningHoleDiameter, center
                    = true);
            }
            // Add text to bottom of a flat leg
            if (len(leg) > 6 && leg[6] != false) {
              rotate([leg[0][0], leg[0][1] + 90, leg[0][2]])
                translate([
                      - thisJointLegLength + jointPinHoleOffset + jointPinningHoleDiameter
                  ,
                  0,
                        sphereJointInsideDiameter / 2 + jointWallThickness - 1
                  ])
                  mirror([0, leg[7] == true ? 1 : 0, 0])
                    linear_extrude(1.1)
                      text(leg[6], size = 5, font = "Liberation Mono", valign = "center", halign =
                      "left");
            }
          }

          if (closeUpWithSphere) {
            // Hollow out the sphere
            sphere(d = sphereJointInsideDiameter);
          }

        }
    }
}
