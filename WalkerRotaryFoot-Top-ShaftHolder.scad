// Load in some defaults
include <parameters/commonParameters.scad>;

// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
shaftPipeInsideDiameter = verticalPipeInsideDiameter_1_25pvc;

include <modules/jointModule.scad>;
include <modules/legsAroundTheCenterPoint.scad>;
include <verticalShaftHolder.scad>;

module WalkerRotaryFootTopShaftHolder() {
    difference()
        {
            union()
                {
                    legsAroundTheCenterPoint(legCount = 8, legLength = 80);
                }
            union()
                {
                    // The -0.01 ensures that the end of the tube is clear.
                    translate([0, 0, - (horizontalPipeInsideDiameter / 2) - jointWallThickness - 0.01])
                        cylinder(h = jointLegLength, d = shaftPipeInsideDiameter);
                }
        }

    translate([0, 0, - horizontalPipeInsideDiameter / 2 - jointWallThickness])
        verticalShaftHolder(includePinnedRing = false, horizontalPipeInsideDiameter + (jointWallThickness * 2),
        rollerBearingHeightAboveThrustBearing = walkerBodyLowerShaftHolderRollerBearingHeightAboveThrustBearing);

    // TODO: You must place a pinned ring UNDER this part, to hold it up,
    //       In a pefect world, the pinned ring would be part of this part,
    //       but printing them together is difficult, and the radiant legs should prevent
    //       this piece from spinning
}

//WalkerRotaryFootTopShaftHolder();

// Use this to view Walker Box Bottom
// along with Rotary Foot Top
//include <WalkerBody-Lower-CenterShaftRotationPoint.scad>;
//translate([20, 20, 30])
//    WalkerBodyLowerCenterShaftRotationPoint();