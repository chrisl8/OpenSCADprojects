// Load in some defaults
include <commonParameters.scad>;

panelThickness = 5;
panelHeight = 237;
panelWidth = 197;

pipeHolderLength = 30;

cube([panelHeight, panelWidth, panelThickness], center =
true);

// These are used to mount the panel to a pipe
include <jointModule.scad>;
jointPinHoleOffset = 15;
// Pick what size pipes you are using
horizontalPipeInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;

jointLegs = [
        [[0, 90, 0], horizontalPipeInsideDiameter, false, true, pipeHolderLength],
    ];

translate([(panelHeight / 4) + (pipeHolderLength / 2), 0, (horizontalPipeInsideDiameter / 2) + jointWallThickness])
    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, false);

translate([- (panelHeight / 4) + (pipeHolderLength / 2), 0, (horizontalPipeInsideDiameter / 2) + jointWallThickness])
    rotate([0, 0, 180]) joint(jointLegs, horizontalPipeInsideDiameter, false);
