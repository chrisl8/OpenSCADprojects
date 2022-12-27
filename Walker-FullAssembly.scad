include <WalkerRotaryFoot-FullAssembly.scad>

include <WalkerBody-FullAssembly.scad>

translate([0, 0, walkerRotaryFootHeight + horizontalPipeInsideDiameter + (jointWallThickness * 2) + thrustBearingHeight]
)
    // Use this to change how it sits on the rotary foot for viewing
    // Just try it with and without the rotate to see how it works.
    rotate([0, 0, walkerRotaryFootLegSpacingInDegrees / 2])
        WalkerBodyFullAssembly();