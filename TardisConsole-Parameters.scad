// Parameters
// This is now 1520,
// But some original numbers were derived from 1111
//tableDiameter = 1111; // Corner to Corner, not side to side
tableDiameter = 1480; // Corner to Corner, not side to side
tableSideCount = 6;
jointInsideDiameter = horizontalPipeInsideDiameter_0_50pvc;
tableLegInsideJointDiameter = horizontalPipeInsideDiameter_0_50pvc;

RenderPipes = true;

tableRadiusForPanels = tableDiameter / 2;
tableRadius = tableRadiusForPanels + 14;
tableHeight = 750; // Does not affect printed parts.
tableTopCenterRise = 218;

// Calculated Constants
// NOTE: If this gets too small, the joint won't actually work properly.
tableSurfaceJointAngle = atan(tableRadius / tableTopCenterRise);
BaseRadius = tableRadius / 3;
PipeInsertDistance = jointLegLength * .6;
TableCornerSpacingInDegrees = 360 / tableSideCount;
TableOutsideJointAngle = (tableSideCount - 2) * 180 / tableSideCount;
PipeSize = jointInsideDiameter / 2 - .01;
//PipeSize = jointInsideDiameter * 2; // Pool Noodles for seeing them better.

// Pipes
echo("Manually determined pipe lenghts:");
tableUpperSurfaceLength = sqrt(pow(tableRadius, 2) + pow(tableRadius, 2) - 2 * tableRadius * tableRadius * cos(
TableCornerSpacingInDegrees));
// Eyeball this to make it NOT stick into the time roter holder
// Turn off the time roter holder pipes to see this. (includeLegs = false)
// And comment out panels()
tableUpperSurfacePipeLength = tableUpperSurfaceLength - 71;
echo("Upper Surface Pipe Length (mm):", tableUpperSurfacePipeLength);

// It helps to just comment out the corner joint to see how these meet.
tableLowerRadiusPipeStartingPoint = 77; // Eyball this until it doesn't cut into the surface pipe.
// Eyeball this until it doesn't cut into the center ring in the TimeRotorBase
// This is easiest to see by going into WalkerRotaryFoot-Lower-ShaftHolder and commenting out the legsAroundTheCenterPoint
tableLowerRadiusPipeLength = tableRadius - 110;
echo("Table Bottom Pipe Length (mm):", tableLowerRadiusPipeLength);

// It helps to just comment out the corner joint to see how these meet.
tableEdgePipeStartingPoint = 19; // Eyeball this until it doesn't cut into the surface pipe.
// Again, eyeball this until it doesn't cut into the other side of the surface pipe
tableEdgePipeLength = 702;
echo("Table Edge Pipe Length (mm):", tableEdgePipeLength);
