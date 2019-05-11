
use <libs/bezier/quadratic_bezier.scad>
use <libs/NACA/shortcuts.scad>
use <libs/NACA/NACA4.scad>
use <libs/gears/parametric_involute_gear_v5.0.scad>

/*
*
* Design works on the basis of shaft drives a 2x bevel gear which drives the motor, which is on the head.
* The shafts are 10mm, running on deep groove BB. Stainless with integral seals.
* Bevel gears are 
Name: Bevel Gear 1.5 Mod 1:2 (15T/30T)
Proportion: 1: 2
90 ° Pairing
Material: 45 # steel
Bore: 15T: 6-8mm(rough machining);      30T: 8-10mm(rough machining)
Tooth outer diameter: 15T: 25mm;    30T: 46mm
Tooth length: 15T: 12mm;    30T: 12mm
Step diameter: 15T: 19mm;     30T: 38mm
Total thickness: 15T: 25mm;     30T: 29mm
https://www.ebay.co.uk/itm/2Pcs-Set-Bevel-Gear-1-5-Mod-1-2-15T-30T-90-Pairing-Use-Metal-Bevel-Gear/273218915005

Bearings
https://docs-emea.rs-online.com/webdocs/14c8/0900766b814c8124.pdf

Gear OD = 46mm (might need skimming)

Pod housing (1.6mm wall)
od=50.8, id=47.6, 

Pod bearing carrier fabricated from sheet and tube.(see drive train module) 10x35x11 Bearings RS Pro.
5.5mm wall
od 47, id 35, l=57

Small gear 25mm OD
10x22x8 bearing RS Pro.
Leg tube 3mm wall
26mm id, od = 32mm 

31x1.6 31-3.2 27.8

vertical holder (2mm wall)
id = 22, od = 26


https://www.metals4u.co.uk/aluminium/c1/tube/c22

Au Stock
od=57.1 id=53.9
od=57.1 id=50.7
od=50.8 id=47.6  << outer shell 
od=50.8 id=44.4
od=50.8 id=38
od=48.4 id=39.4
od=44.5 id=41.3
od=44.5 id=38.1
od=41.275 id=37.875
od=38.1 id=34.9 1.6mm << carrier tube 10x35x11 with end plates.
od=38.1 id=31.7
od=38.1 id=25.5 6.3mm << carrier tube  10x26x8

od=31.8  id=28.6
od=31.8  id=25.4 <<<< Pole
od=25.4  id=22.2
od=25.4  id=19  <<< carrier for 10x19x5 bearings, bevel will slide down pole, bearings press fit inside 
od=22.2  id=19
od=22.2  id=15.8
od=19 id=17  
od=19 id=17


Needs some redrawing


*/


Deltat=0.01;

 module tube(od= 20, id=10, l=40, center=true) {
    difference() {
     cylinder(r=od/2,h=l,center=center);
     cylinder(r=id/2,h=l+1,center=center);
    };
};    

module nose_cone(r=40,h=65) {
    
    p0 = [r,0]; 
    p1 = [r,h*(50/65)];
    p2 = [0,h];



    pt = [[0,h],[0,0],[r,0]];
    p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),pt);
    //echo(p);
    rotate_extrude()
    polygon(p);
};

module blade_stub(R=10, B=40, H=30, r=2.5, h=5) {
    
    translate([0,0,-B])
    union() {
    cylinder(r=R,h=(H-R));
    translate([0,0,H-R-h-r]) cylinder(r=R+r,h=h);
    //translate([0,0,H-R]) sphere(r=R);
    }
};
module blade_root(R=10, B=40, H=30) {
    //color("green") 
    //translate([0,0,0])
    //cylinder(r=R,h=10);
    
    p0 = [R,0]; 
    p1 = [R,15*(50/65)];
    p2 = [0,20];
    pt = [[0,20],[0,0],[R,0]];
    p = concat(bezier(p0=p0,p1=p1,p2=p2,deltat=Deltat),pt);
    translate([0,0,-B])
    scale([1.5,1])
    color("green") 
    rotate([180,0,0])
    rotate_extrude()
    polygon(p);

}

/*
 R = nose cone radius
 H = node cone height
 r = blade boss radius
 h = blade boss root lenth into boss
*/

module nose_cone_with_blades(R=40, H=65, r=8, h=20) {
        
    difference() {
        nose_cone(r=R, h=H);
        translate([0,0,r+5])
        
        rotate([-90,0,0])
        union() {
            rotate([0,0,0])
            blade_stub(R=r,B=R,H=h);
            rotate([0,120,0])
            blade_stub(R=r,B=R,H=h);
            rotate([0,-120,0])
            blade_stub(R=r,B=R,H=h);
        }
    }
}


module motor() {
    color("black") 
    rotate_extrude()
    polygon([[0,0],[(63/2)-5,0],[63/2,5],[63/2,74-5],[63/2-5,74],[0,74],[0,0]]);
    cylinder(r=5,h=100);
}



module bevel_gear_set (
	gear1_teeth = 41,
	gear2_teeth = 7,
    bore1 = 10,
    bore2 = 10,
	axis_angle = 90,

    pressure_angle = 20,
    face_width = 12,
	outside_circular_pitch=1000)
{
	outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
	outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

	rotate([0,0,90])
	translate ([0,0,0]) //pitch_apex1+20])
	{
		translate([0,0,-pitch_apex1])
        union() {
		bevel_gear (
			number_of_teeth=gear1_teeth,
			cone_distance=cone_distance,
			pressure_angle=pressure_angle,
            face_width=face_width,
            bore_diameter=bore1,
			outside_circular_pitch=outside_circular_pitch,
            finish=bevel_gear_flat);
        translate([0,0,-3/2])
            tube(od=outside_pitch_radius1*2-5,id=bore1,l=3);
        translate([0,0,-10/2])
            tube(od=outside_pitch_radius1*2-15,id=bore1,l=10);
        }
	
		rotate([0,-(pitch_angle1+pitch_angle2),0])
		translate([0,0,-pitch_apex2])
        union() {
		bevel_gear (
			number_of_teeth=gear2_teeth,
			cone_distance=cone_distance,
			pressure_angle=pressure_angle,
            face_width=face_width,
            bore_diameter=bore2,
			outside_circular_pitch=outside_circular_pitch,
            finish=bevel_gear_flat);
        translate([0,0,-3/2])
            tube(od=outside_pitch_radius2*2-5,id=bore2,l=3);
        translate([0,0,-10/2])
            tube(od=outside_pitch_radius2*2-15,id=bore2,l=10);
        }

	}
}

module drive_train() {
    bevel_gear_set(
        gear1_teeth = 30,
        gear2_teeth = 15,
        bore1 = 10,
        bore2 = 10,
        axis_angle = 90,
        pressure_angle = 20,
        face_width = 12,
        outside_circular_pitch=ocp
    );
    // bearing 10x26x8, stainless with seal
    color("red")
    translate([0,0,-26])
        tube(od=26,id=10,l=8);
    // bearing 10x26x8
    color("red")
    translate([0,0,-75])
            tube(od=26,id=10,l=8);
    // bearing case
     
    translate([0,0,-79])
        tube(od=46,id=26,l=57, center=false);
    // input drive shaft
    translate([0,0,-120-7])
        cylinder(d=10,h=120);
    // case OD 40, 2mm wall
    // vertical shaft
    rotate([90,0,0]) {
        // 10x19x5 bearings
        color("red")
            translate([0,0,-19])
                tube(od=19,id=10,l=5);
        color("red")
            translate([0,0,-100])
                tube(od=19,id=10,l=5);
        // bearing hold tube, od 21, id 19 slides
        // inside the leg with the bearings and gears installed. May use internal spacer to hold bearings.
        translate([0,0,-580-14])
            tube(od=21,id=19,l=580, center=false);
        // output drive shaft
        // could use 8mm shaft.
        translate([0,0,-580-14])
            cylinder(d=10,h=580);        
        }
}
// Outside diameter is 62
/*
Name: Bevel Gear 1.5 Mod 1:2 (15T/30T)
Proportion: 1: 2
90 ° Pairing
Material: 45 # steel
Bore: 15T: 6-8mm(rough machining);      30T: 8-10mm(rough machining)
Tooth outer diameter: 15T: 25mm;    30T: 46mm
Tooth length: 15T: 12mm;    30T: 12mm
Step diameter: 15T: 19mm;     30T: 38mm
Total thickness: 15T: 25mm;     30T: 29mm
*/
ocp = 46*180/30;

rotate([90,0,0]) {
  difference() {
     union() {
       drive_train();
       // pod case
        translate([0,0,-24])
            tube(od=50,id=46,l=110);
         
        rotate([90,0,0]) {
            //translate
            translate([0,0,-500-20]) {
            difference() {
                // filled foam with grp skin
                hull(){
                    // 25mm tube, joined to pod case body
                    cylinder(r=25/2,h=500);
                    // front tube
                    translate([0,60,40])
                    cylinder(r=4,h=480);
                    // back tube
                    translate([0,-60,20])
                    cylinder(r=2,h=500);
                }
                // vertical shaft id is 21mm
                translate([0,0,-5])
                    cylinder(r=(21)/2,h=510);
                rotate([-90,0,0])
                   translate([0,-500-20,-65])
                     cylinder(r=50/2,h=100);
                
            }
        }
        // leg
            translate([0,0,-610])
                {
                    motor();
                    // hinge plate
                    translate([-2.5,0,0])
                        difference() {
                            rotate([0,-90,0])
                            difference() {
                                hull() {
                                    translate([-40,55,-2.5])
                                        cylinder(r=10,h=5);
                                    translate([25,65,-2.5])
                                        cylinder(r=30,h=5);
                                    translate([110,50,-2.5])
                                        cylinder(r=25,h=5);
                                    translate([100,14,-2.5])
                                        cylinder(r=1,h=5);
                                    translate([190,14,-2.5])
                                        cylinder(r=1,h=5);
                                }
                                translate([-40,55,-5])
                                        cylinder(r=4,h=10);
                                translate([110,60,-5])
                                        cylinder(r=4,h=10);
                                translate([25,65,-5])
                                        cylinder(r=4,h=10);
                            }
                            
                            translate([0,0,-12])
                                cylinder(d=76, h=112,center=false);
                        }

                    // mounting plate
                    difference() {
                        union() {
                            // base plate
                            // has a access hole to tighten the grib screew on the keyway.
                            translate([0,0,87])
                                tube(od=73,id=30,l=25);
                            // attached to cover, sealed with orings.
                            // top plate
                            translate([0,0,-14])
                                cylinder(d=76,h=3, center=false);
                            // outer cover
                            translate([0,0,-12])
                                tube(od=76, id=73, l=112, center=false);
                        }
    // section                    translate([0,-50,-50])
    //                    
    //                        cube([200,200,200]);
                    }
                    
                }
        }
        translate([0,0,25])
            nose_cone(r=25, h=40);
        translate([0,0,-85])
          rotate([-180,0,0])
            nose_cone_with_blades(R=25, H=45, r=8, h=25);
    }
    translate([0,-200,-500])
    cube([100,1000,1000]);
    
}
    
}


