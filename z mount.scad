//TronxyX5S Z motor, guide rail mount, extra rigid version
use <BOSL/transforms.scad>;
use <BOSL/shapes.scad>;
use <BOSL/nema_steppers.scad>;
$fs = 0.05;


difference(){
//cube for the motor mount, make it a bit bigger than stock for bracing.
  union() {
      rrect([52,42,4.5],r=2,center=false);
      rrect([54+54+42,20,4.5],r=5);

  place_copies([[-21,15,14.5],[21,15,14.5]]) thinning_brace(h=20, l=11, thick=5, ang=40, strut=3, wall=3);
  translate([0,11,4.5])rrect([47,4,20]);
  translate([-20,7,12.25])rcube([40,5,5],center=false,r=2);
  translate([-20,-12,12.25])rcube([40,5,5],center=false,r=2);
  translate([0,-11,4.5])rrect([47,4,20]);
  rotate([0,0,180])place_copies([[-21,15,14.5],[21,15,14.5]]) thinning_brace(h=20, l=11, thick=5, ang=40, strut=3, wall=3);
  }
  size = 17;
  slop =0.1;
  plinth_diam = nema_motor_plinth_diam(size)+slop;
  screw_spacing = nema_motor_screw_spacing(size);
  screw_size = nema_motor_screw_size(size)+slop;
  l=0;
  depth=30;
  union() {
    xspread(screw_spacing) {
      yspread(screw_spacing) {
        if (l>0) {
          union() {
            yspread(l) cylinder(h=depth, d=screw_size, center=true, $fn=max(8,segs(screw_size/2)));
            cube([screw_size, l, depth], center=true);
          }
        } else {
          cylinder(h=depth, d=screw_size, center=true, $fn=max(8,segs(screw_size/2)));
        }
      }
    }
  }
  place_copies([[45,0,-1],[-45,0,-1]])cylinder(h=10,r=2.05);
  place_copies([[61,0,-1],[-61,0,-1]])cylinder(h=10,r=4.1);

}
