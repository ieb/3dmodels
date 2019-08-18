use <../libs/threads-library-by-cuiso-v1.scad>

/*
* Vacuum bag frog
*/
$fn=100;
module screw() {
    difference() {
        union() {
            thread_for_screw(diameter=15, length=20); 
            cylinder(d=35, h=6, $fn=12);
        }
        cylinder(d=6, h=25);
        translate([0,0,4])
        difference() {
            cylinder(d=29, h=3);
            cylinder(d=21, h=3);
        }
    }
}


module washer() {
    difference(){
      cylinder(d=35, h=3); 
      cylinder(d=16, h=4); 
    }
}

module  nut() {
    difference(){
      cylinder(d=35, h=6, $fn = 6); 
         thread_for_nut(diameter=15, length=6, usrclearance=0.1); 
    }
}

nut();