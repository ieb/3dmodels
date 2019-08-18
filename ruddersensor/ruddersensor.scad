
$fn=100;
module arm() {
difference() {
    union() {
        // arm
        hull() {
        cylinder(d=60,h=10);
        translate([139.7,0,0])
        cylinder(d=30,h=10);
        }

        translate([0,0,-15])
        cylinder(d=60,h=20);
        
        cylinder(d=60,h=20);
        cylinder(d=25,h=20);
        translate([139.7,0,0])
        cylinder(d=20,h=8);
    }

    translate([0,0,12])

    rotate([90,0,0])
      cylinder(d=4,h=35);

    translate([0,0,-1])
      cylinder(d=42,h=8);

    //shaft hole
    translate([0,0,-1])
      cylinder(d=6,h=19);
    translate([139.7,0,-1])
      cylinder(d=6,h=15);
    
    translate([0,0,-16])
        cylinder(d=56,h=15);
        
}
}

module slot() {
    difference() {
    cylinder(d=72,h=15);
       translate([0,0,-1])
    cylinder(d=62,h=17);
    rotate([0,0,75])
    translate([-50,0,-1])    
    cube([100,100,100]);
    rotate([0,0,-75])
    translate([-50,0,-1])    
    cube([100,100,100]);
    }
    rotate([0,0,75])
    translate([-33.5,0,0])    
    cylinder(d=5,h=15);
    rotate([0,0,75+30])
    translate([-33.5,0,0])    
    cylinder(d=5,h=15);
}


module body() {
translate([0,0,-41]) {
difference() {
    union() {
    // top
    cylinder(d=55,h=40);
    // body
    translate([0,0,-5])
        cylinder(d=55,h=40);
    // base
    translate([0,0,-5])
        cylinder(d=80,h=8);
    }
    translate([0,0,-6])
        cylinder(d=45,h=42);
    translate([0,0,-6])
        cylinder(d=48,h=5);
    
    translate([0,0,-6])
    slot();
    translate([0,0,-6])
    rotate([0,0,120])
    slot();
    translate([0,0,-6])
    rotate([0,0,-120])
    slot();
    
}
}
}

module pot() {

// pot Bourns 6657 1 turn 6657S-1-502
color("red") {
translate([0,0,-5])    
cylinder(d=6.35,h=22);
translate([0,0,-5])    
cylinder(d=10,h=10);
translate([0,0,-25])    
cylinder(d=33,h=20);
}
}

module base() {
    translate([0,0,-46])
        cylinder(d=47.5,h=5);
}

difference() {
union() {
arm();
pot();
body();
base();
}
//translate([0,0,-50])
//cube([150,150,150]);
}

