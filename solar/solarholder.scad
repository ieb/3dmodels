$fn=100;

module baseblock() {
    difference() {
    cylinder(d=50,h=26);
    translate([0,0,12])
      cylinder(d=28,h=15);
    translate([0,0,6])
    rotate([90,0,0])    
    cylinder(d=8,h=55,center=true);
        
            translate([0,0,20])
        rotate([90,0,0])    
        cylinder(d=8,h=55,center=true);

      hull() {
        translate([0,0,15])
        rotate([0,90,0])    
        cylinder(d=5,h=55,center=true);
        translate([0,0,55])
        rotate([0,90,0])    
        cylinder(d=5,h=55,center=true);
      }
    }
}

module clamp1() {
    difference() {
      hull() {
        cylinder(d=15,h=40,center=true);
        rotate([0,90,0])    
        translate([10,20,0])
        cylinder(d=20,h=15,center=true);
      }
    rotate([0,90,0])    
     translate([10,20,0])
    cylinder(d=5,h=90,center=true);
    cylinder(d=8,h=90,center=true);
      
    translate([7.5,0,0])
    rotate([0,90,0])    
     translate([10,20,0]) {
         translate([0,-10,-7.5])
        cube([30,30,15]);
        cylinder(d=22,h=15,center=true);
     }

  }
}
module clamp2() {
    difference() {
      hull() {
        translate([0,60,-7.5])
        rotate([90,0,0])
        cylinder(d=15,h=40);
        rotate([0,90,0])    
        translate([10,20,0])
        cylinder(d=20,h=15,center=true);
      }
    rotate([0,90,0])    
     translate([10,20,0])
    cylinder(d=5,h=90,center=true);
   translate([0,75,-7.5])
        rotate([90,0,0])
        cylinder(d=8,h=40);
      
    translate([-7.5,0,0])
    rotate([0,90,0])    
     translate([10,20,0]) {
         translate([0,-20,-7.5])
        cube([30,30,15]);
        cylinder(d=22,h=15,center=true);
     }

  }
}

module clamp3() {
    difference() {
      hull() {
        cylinder(d=15,h=40,center=true);
        rotate([0,90,0])    
        translate([0,10,0])
        cylinder(d=15,h=15,center=true);
      };
    cylinder(d=8,h=90,center=true);
    rotate([0,90,0])    
      hull() {
        translate([0,-10,0])
        cylinder(d=5,h=40,center=true);
        translate([0,10,0])
        cylinder(d=5,h=40,center=true);
      }
    }; 
}



clamp1();
clamp2();
translate([0,100,0])
rotate([90,0,0])
clamp3();

