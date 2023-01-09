// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <modules/jointModule.scad>;
include <verticalShaftHolder.scad>;

module timeRotorOffsetLegsAroundCenterPoint(legCount = 1, legLength = false, includeTriangleSupports = true, legAngle) {
  legSpacingInDegrees = 360 / legCount;

  for (i = [0:legCount - 1]) {
    jointLeg = [legInstance(rotation = [0, 180 - legAngle, 0], insideDiameter = horizontalPipeInsideDiameter, pinHole = true, length = legLength)];
    rotate([0, 0, legSpacingInDegrees * i])
      joint(legs = jointLeg, sphereJointInsideDiameter = 0, closeUpWithSphere = false, addCircleToFlatBottom = false, jointPinHoleOffset = 40);
  }
}


module timeRotorHolderCenter(supportHeight, outsideRingDiameter, insideDiameter, ringHeight, ringPosition) {
  totalPartHeight = comfortablePinnedSectionHeight + supportHeight;

  translate([0, 0, ringPosition])
    cylinder(h = ringHeight, d = outsideRingDiameter);
}

module TimeRotorHolder(legCount = 6, insideDiameter = 45, outsideRingDiameter = 50, ringHeight = 100, ringPosition = - 50, legAngle = 10, legLength = 80, includeLegs = true) {
  difference()
    {
      union()
        {
          timeRotorHolderCenter(supportHeight = horizontalPipeInsideDiameter + (jointWallThickness * 2), outsideRingDiameter = outsideRingDiameter, insideDiameter = insideDiameter, ringHeight = ringHeight, ringPosition = ringPosition);

          if (includeLegs)
          timeRotorOffsetLegsAroundCenterPoint(legCount = legCount, legLength = legLength, legAngle = legAngle);
        }
      union()
        {
          // Hollow out for the pipe to fit in.
          translate([0, 0, - 500])
            cylinder(h = 1000, d = insideDiameter);
        }
    }
}

//TimeRotorHolder(legCount = 6, insideDiameter = 180, outsideRingDiameter = 190, ringHeight = 50, ringPosition = -44, legAngle = 25, legLength = 75);