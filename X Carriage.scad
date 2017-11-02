//X Carriage for the TronxyX5S by Keith Bailey
use <BOSL/transforms.scad>;
use <BOSL/shapes.scad>;
use <BOSL/nema_steppers.scad>;
$fs = 0.05;

//define the wheels, extrusion etc being used.
wheel_diameter = 10;
wheel_bolt = 5; //M Size
extrusion_width_x = 20;
extrusion_width_y = 20;

//Carriage Description
include_spacers = 1; //include printed spacers. no if you're going to use nut/washer stacks.
minimum_clearance = 4; //minimum space between edge of carriage and bolt holes.
belt_separation = 20; //separation of belts in Y direction. This drives positioning of the bolts to mount belt to.
max_belt_height = 30; //maximum distance from top of extrusion to top of belt
piezo_size = 27; //piezo outer diameter
carriage_thickness = 4; //thickness before strengthening.

//X endstop
stop_bolt_size = 3; //bolt size
stop_bolt_sep = 4; //separation between endstop bolts.
stop_bolt_to_activation =5; //distance between centerline of bolts and activation point.

printer_slop = 0.2; //added to all bolt holes


module belt_mount (negative=false) {
  if (!negative) {
    hull(){
      cylinder(r=(stop_bolt_size+minimum_clearance)/2,h=carriage_thickness);
      translate([5,0,0])cylinder(r=(stop_bolt_size+minimum_clearance)/2,h=carriage_thickness);
    }
    translate([0,belt_separation,0])hull(){
      cylinder(r=(stop_bolt_size+minimum_clearance)/2,h=carriage_thickness);
      translate([5,0,0])cylinder(r=(stop_bolt_size+minimum_clearance)/2,h=carriage_thickness);
    }

  }

}
belt_mount();
