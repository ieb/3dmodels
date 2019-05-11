
use <libs/gears/parametric_involute_gear_v5.0.scad>


 module tube(od= 20, id=10, l=40, center=false) {
    difference() {
     cylinder(r=od/2,h=l,center=center);
     translate([0,0,-1])
     cylinder(r=id/2,h=l+2,center=center);
    };
};  
module shaft() {
    union() {
     cylinder(r=6,h=150);
     tube(od=30,id=12,l=5);
     translate([0,0,45])   
     tube(od=30,id=12,l=5);   
    }
}
module roller() {
    rotate([90,0,0])
    union() {
        tube(od=40,id=30,l=600);
        translate([0,0,600-50])
            shaft();
        translate([0,0,50])
        rotate([180,0,0])
            shaft();
    }
}
module bearing(withBoss=true) {
   
    rotate([90,0,180])
    union() {
        tube(id=12,od=40,l=5);
        tube(id=12,od=16,l=25);
        if (withBoss) {
            difference() {
                union() {
                    translate([0,8,0])
                    cylinder(r=8,h=10);
                    translate([-8,0,0])
                        cube([16,8,10]);
                    translate([-8,0,10])
                        cube([16,16,15]);
                }
                // recess in boss
                translate([0,17,18])
                    rotate([90,0,0])
                    cylinder(r=6,h=6);
                translate([0,0,-2])
                    cylinder(r=6,h=30);
            }
        }
    }
}
module endplate() {
    slotrad=12/2;
    plateh=75;
    platew=2*plateh/tan(60);
    platet=5;
    rotate([90,0,0])
    translate([15,15,0])
    union() {
        difference() {
            hull() {
              translate([platew-15,-10-15,0])
                cube([30,30,platet]);
              translate([platew,plateh,0])
                cylinder(r=15,h=platet);
              translate([0,plateh,0])
                cylinder(r=15,h=platet);
              translate([-15,-10-15,0])
                cube([30,30,platet]);
            }
            translate([5,5,-1])
              cylinder(r=slotrad,h=platet+2);
/*            hull() {
              translate([40,5,-1])
              cylinder(r=slotrad,h=platet+2);
              translate([platew-5,5,-1])
              cylinder(r=slotrad,h=platet+2);
            }
            */
            hull() {
              translate([20,40,-1])
              cylinder(r=slotrad,h=7);
              translate([20,55,-1])
              cylinder(r=slotrad,h=7);
              translate([80,5,-1])
              cylinder(r=slotrad,h=7);
              translate([40,5,-1])
              cylinder(r=slotrad,h=7);
            }
        }
        
        translate([-15,-10-15,-plateh/2])
            cube([platew+30,platet,plateh/2]);
    }

}

/*
translate([20,0,20]) {
    roller();
   //* translate([0,0,0]) 
    color("red")
    bearing(withBoss=false);
    translate([0,-600,0]) 
    color("red")
    rotate([0,0,180])
    bearing(withBoss=false);
    * /
}

translate([60,0,20]) {
    roller();
    /*
    rotate([0,90,0])
    translate([0,0,0]) 
    color("red")
    bearing(withBoss=false);
    rotate([0,90,0])
    translate([0,-600,0]) 
    color("red")
    rotate([0,0,180])
    bearing(withBoss=false);
    * /
}
translate([20+20,0,20+20*tan(60)]) {
    roller();
    /*
    translate([0,0,0]) 
    color("red")
    bearing(withBoss=false);
    translate([0,-600,0]) 
    color("red")
    rotate([0,0,180])
    bearing(withBoss=false);
    * /
}

color("blue")
translate([0,10,0])
endplate();
color("blue")
translate([0,-610,0])
mirror([0,1,0])
endplate();
*/

/**
 Plain bearing
$fn=100;
tube(id=16.5,od=22,l=30);
*/
// 2 shafts

bendd = 10;
gearh = 20;

/*
translate([-35,0,0])
    cylinder(r=8,h=60);
translate([35,0,0])
    cylinder(r=8,h=60);
translate([0,bendd,0])
cylinder(r=8,h=60);

translate([-35,0,-60])
    cylinder(r=15.5,h=60);
translate([35,0,-60])
    cylinder(r=15.5,h=60);
translate([0,bendd,-60])
cylinder(r=15.5,h=60);
    
echo("rendering gear");
translate([-35,0,0])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = 2gearh5);
translate([35,0,0])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);
translate([0,bendd,0])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);


out=25;
translate([-out,out,0])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);

translate([out,out,0])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);

*/

$fn=100;
/*
difference() {
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);
translate([0,0,gearh])
rotate([90,0,0])
    cylinder(r=3,h=25,center=true);
}
*/

/*
gear (pcd=30,
    gear_mod=2,
    bore_diameter=11,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);
*/    

module gearset(seperation=40) {
translate([0,0,5])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);
translate([seperation,0,5])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=11,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);
translate([seperation/2,sqrt((30*30)-((seperation/2)*(seperation/2))),5])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=11,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);
}


/*
Plate
*/
module plate(seperation=40) {
    difference() {
    hull() {
        translate([70,12,0])
            cylinder(r=8,h=5);
        translate([40,0,0])
            cylinder(r=12,h=5);
        translate([20,sqrt((30*30)-(20*20)),0])
            cylinder(r=18,h=5);
        cylinder(r=18,h=5);
        
    }    
    cylinder(r=16.5/2,h=12,center=true);
    translate([65,12,0])
       cylinder(r=3,h=12,center=true);
    translate([seperation/2,sqrt((30*30)-((seperation/2)*(seperation/2))),0])
     cylinder(r=5.5,h=12,center=true);
    translate([seperation,0,0])
     cylinder(r=5.5,h=12,center=true);
    }
}

module tblock() {
// tightening block
translate([65-15/2,12-15/2,5])
difference() {
    union() {
    cube([15,15,gearh]);
    translate([15/2,15/2,-10])    
    cylinder(r=3,h=gearh+20);
    }
    translate([15/2,0,gearh/2])
    rotate([90,0,0])
    cylinder(r=3,h=gearh+20,center=true);
}
}

module arm() {
    gearset();
    plate();
    tblock();
}

/*
translate([10,-35,5])
gear (pcd=30,
    gear_mod=2,
    bore_diameter=16.5,
    gear_thickness = gearh,
    rim_thickness = gearh,
    hub_thickness = gearh);



rotate([0,0,-25])
arm();
translate([0,-70,0])
mirror([0,1,0])
rotate([0,0,-25])
arm();
*/

plate();
//tblock();
