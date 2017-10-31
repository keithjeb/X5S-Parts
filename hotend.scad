//Hotend Mount Generator for TronXY X5S.
//Keith Bailey - 2017
//inclusions
use<BOSL-master/metric_screws.scad>;
use<BOSL-master/transforms.scad>;
use<BOSL-master/shapes.scad>;
$fa= 1; // default minimum facet angle is now 0.5
$fs= 1.5; // default minimum facet size is now 0.5 mm
//set height of bar being used.
barheight = 20;
//desired carriage thickness
thickness = 3;
//include bracing ridges?
with_ridges = 1;

//include wheel spacers?
with_spacers = 1;
//height of wheel spacers
spacer_height = 5;
//wheel specifications
wheel_diameter = 20;
wheel_hole_size = 5;
minimum_wheel_spacing = 50;
//number of cable tie locations to include (you get 2* this number of holes)
cable_tie_points = 2;
cable_tie_size = 3;

//plane A height above Bar (to centerpoint of desired mount)
aheight = 18;

//plane B height above Bar
bheight = 11;

//endstop switch screw size (i.e. for m8 put 8)
stop_size = 2;
//enstop switch distance between activation point and screw holes
stop_distance = 5;

//the actual work starts here
//calculate the height
ysize = barheight + (2 * wheel_diameter);
zsize = thickness;
xsize = minimum_wheel_spacing + 20;

//jhead settings - Jhead mount lifted wholesale from
// Variables for J Head Mount
// Enter height in millimeters from the top of the J Head mount, usually that is the top of the cold end itself. The top of the mount is 3.7 mm from the top of the inner groove of the J Head mount.
genJHeadHeight = 0;
// J Head adjustments. How much to adjust the J Head mount. Really dependent on your printer. Print a calibration cube and enter the adjustments in size here. These are mm and will be added to their respective parameters. eg; you want to make the height of the collar in the middle smaller by .2mm, enter -.2 in innerCollarHeightAdjustment. If you want to make that same collar a larger hole by .2mm, enter .2 in innerCollarDiameterAdjustment.
upperCollarDiameterAdjustment = .1;
upperCollarHeightAdjustment = .15;
innerCollarDiameterAdjustment = .2;
innerCollarHeightAdjustment = -0.3;
lowerCollarDiameterAdjustment = .1;
lowerCollarHeightAdjustment = .15;

jHeadWidth = 26;
jHeadUpperCollarDiameter = upperCollarDiameterAdjustment + 16;
jHeadUpperCollarHeight = upperCollarHeightAdjustment + 3.7;
jHeadInnerCollarDiameter = innerCollarDiameterAdjustment + 12;
jHeadInnerCollarHeight =  innerCollarHeightAdjustment + 6;
jHeadLowerCollarDiameter = lowerCollarDiameterAdjustment + 16;
jHeadLowerCollarHeight = lowerCollarHeightAdjustment + 3;
jHeadMountHeight = jHeadUpperCollarHeight + jHeadInnerCollarHeight + jHeadLowerCollarHeight;
jHeadHEPosUD = 21;
jHeadMountWidth = 36;
jHeadCollarCornerRadius = 3;
jHeadMountBoltDiameter = 3.2;
jHeadMountNutDiameter = 6.5;
jHeadMountNutDepth = 2.4;
jHeadFanScrewOffset = 5;
jHeadMountScrewHorizontalOffset = (jHeadWidth / 4);
jHeadMountScrewVerticalOffset = (jHeadMountHeight / 2);

// Depth from center of hotend to face of carriage.
jHeadMountDepth = 35;

module backplane(width, height, thickness, fillet,ridgesize=5) {
  difference() {
  chamfcube(size=[width,thickness + ridgesize,height],chamfcorners=true,chamfaxes=[1,1,1],chamfer=1);
  translate([0,-0.1-ridgesize/2, (ridgesize/2)-height/2]) upcube([width-ridgesize,ridgesize,height-ridgesize]);
  }
};
module wheelholes(){
  //puts 3 wheel holes in the carriage
  rotate([-90,0,0]) translate([0,barheight/2+(wheel_diameter/2),-thickness+2.1])  cylinder(r=wheel_hole_size/2, h=thickness + 2);
  rotate([-90,0,0]) translate([minimum_wheel_spacing/2,-barheight/2-(wheel_diameter/2),-thickness+2.1])  cylinder(r=wheel_hole_size/2, h=thickness + 2);
  rotate([-90,0,0]) translate([-minimum_wheel_spacing/2,-barheight/2-(wheel_diameter/2),-thickness+2.1])  cylinder(r=wheel_hole_size/2, h=thickness + 2);
}
module jhead_holes(carriageDepth) {
     // Carve out the holes for the mount.
     // Upper collar hole
     translate([(jHeadMountWidth / 2), (jHeadMountDepth / 2), jHeadMountHeight - jHeadUpperCollarHeight])
	  cylinder(d=jHeadUpperCollarDiameter, h=jHeadUpperCollarHeight + .1, $fn=100);

     // Inner collar hole.
     translate([(jHeadMountWidth / 2), (jHeadMountDepth / 2), jHeadMountHeight - jHeadUpperCollarHeight - jHeadInnerCollarHeight - .1])
	  cylinder(d=jHeadInnerCollarDiameter, h=jHeadInnerCollarHeight + .2, $fn=100);

     // Lower collar hole.
     translate([(jHeadMountWidth / 2),
		(jHeadMountDepth / 2),
		jHeadMountHeight - jHeadUpperCollarHeight - jHeadInnerCollarHeight - jHeadLowerCollarHeight - .1])
	  cylinder(d=jHeadLowerCollarDiameter, h=jHeadLowerCollarHeight + .1, $fn=100);


     // Left Mounting Screw
     translate([jHeadMountScrewHorizontalOffset,
		-.1,
		jHeadMountScrewVerticalOffset])
	  rotate([-90,0,0])
	  bolt_hole(jHeadMountBoltDiameter, jHeadMountDepth + carriageDepth - jHeadMountNutDepth, jHeadMountNutDiameter, jHeadMountNutDepth + .1);

     // Right Mount Screw
     translate([jHeadMountWidth - jHeadMountScrewHorizontalOffset,
		-.1,
		jHeadMountScrewVerticalOffset])
	  rotate([-90,0,0])
	  bolt_hole(jHeadMountBoltDiameter, jHeadMountDepth + carriageDepth - jHeadMountNutDepth, jHeadMountNutDiameter, jHeadMountNutDepth + .1);

}
module bolt_hole(bdia, bdep, ndia, ndep) {
     union() {
	  // Note we shift the cylinders in the z axis by .1 and make then .2 bigger to avoid coincident faces.
	  // Screw hole
	  translate([0,0,-.2])
	       cylinder(d=bdia,h=bdep + .3,$fn=100);
	  // Nut Trap
	  translate([0,0,bdep])
	       cylinder(d=ndia,h=ndep + .1,$fn=6);
     }
}
module jhead_collar(carriageDepth) {
     difference() {
	  hull() {
	       // Create the base collar which the holes will be carved out of.
	       translate([jHeadCollarCornerRadius, jHeadCollarCornerRadius, 0])
		    cylinder(r=jHeadCollarCornerRadius, h=jHeadMountHeight, $fn=100);

	       translate([jHeadMountWidth - jHeadCollarCornerRadius, jHeadCollarCornerRadius, 0])
		    cylinder(r=jHeadCollarCornerRadius, h=jHeadMountHeight, $fn=100);

	       translate([0,(jHeadMountDepth / 4),0])
		    cube([jHeadMountWidth, (jHeadMountDepth / 4), jHeadMountHeight]);
	  }

	  // Carve out the holes.
	  jhead_holes(carriageDepth);
     }
}

module jhead_base() {
     // Create the base block which the holes will be carved out of.
     translate([0, (jHeadMountDepth / 2), 0])
	  cube([jHeadMountWidth, (jHeadMountDepth / 2)  + .1, jHeadMountHeight]);

}
// J Head style mount
module jhead_mount(carriageDepth) {
     difference() {
	  // Create the base block which the holes will be carved out of.
	  jhead_base();
	  jhead_holes(carriageDepth);
     }
}

difference(){
  backplane(xsize,ysize,zsize);
  wheelholes();
};
translate ([-jHeadMountWidth/2,jHeadMountDepth,jHeadMountHeight]) rotate([180,0,0]) {
  jhead_mount(3);
  jhead_collar(3);
};
