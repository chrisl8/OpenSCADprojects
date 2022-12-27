// Load in some defaults
include <parameters/commonParameters.scad>;

module Generic12vBatteryBox() {
    difference() {
        union() {
            cube([
                    batteryWidth + (batteryHolderWallThickness * 2),
                    batteryLength + (batteryHolderWallThickness * 2),
                    batteryBoxDepth +
                    batteryHolderWallThickness
                ], center = true);
        }
        union() {
            // Cut out the space for the battery
            // +1 ensures the cut is full
            translate([0, 0, (batteryHolderWallThickness / 2) + 1])
                cube([batteryWidth, batteryLength, batteryBoxDepth + 1], center = true);
        }
    }

    //color("blue")
    //translate([0, 0, batteryHolderWallThickness / 2])
    //    cube([batteryWidth, batteryLength, batteryBoxDepth], center = true);

    // Fun Triangles for supports on the T side
    b = 15;
    b2 = 9;
    h = 98;
    h2 = - 4;
    w = 8;

    /*
translate([- horizontalPipeInsideDiameter / 2 - 1, jointLegLength / 1.75, horizontalPipeInsideDiameter / 2])
    rotate([- 90, - 90, 0])
        union() {
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h, 0], [0, b]], paths = [[0, 1, 2]]);
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h2, 0], [0, b2]], paths = [[0, 1, 2]]);
        }

translate([- horizontalPipeInsideDiameter / 2 - 1, - jointLegLength / 1.75, horizontalPipeInsideDiameter / 2])
    rotate([- 90, - 90, 0])
        union() {
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h, 0], [0, b]], paths = [[0, 1, 2]]);
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points = [[0, 0], [h2, 0], [0, b2]], paths = [[0, 1, 2]]);
        }
*/
}

//Generic12vBatteryBox();
